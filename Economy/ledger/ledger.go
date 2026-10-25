package ledger

import (
	"bytes"
	"errors"
	"fmt"
	"sync"

	bolt "go.etcd.io/bbolt"
)

type State struct {
	ownerItems      map[Owner]*Items
	itemOwnersOne   map[CanOwnOne]*OwnersOne
	itemOwnersMany  map[CanOwnMany]*OwnersMany
	userLastStipend map[User]TransferID
}

func makeState() State {
	return State{
		ownerItems:      make(map[Owner]*Items),
		itemOwnersOne:   make(map[CanOwnOne]*OwnersOne),
		itemOwnersMany:  make(map[CanOwnMany]*OwnersMany),
		userLastStipend: make(map[User]TransferID),
	}
}

func (s *State) GetInventory(id Owner) *Items {
	inv, ok := s.ownerItems[id]
	if !ok {
		inv = &Items{}
		s.ownerItems[id] = inv
		return inv
	}

	for i, qty := range inv.Many {
		if qty == 0 {
			delete(inv.Many, i)
		}
	}
	s.ownerItems[id] = inv
	return inv
}

func (s *State) GetOwnersOne(i CanOwnOne) *OwnersOne {
	oo, ok := s.itemOwnersOne[i]
	if !ok {
		oo = &OwnersOne{}
		s.itemOwnersOne[i] = oo
	}
	return oo
}

func (s *State) GetOwnersMany(i CanOwnMany) *OwnersMany {
	om, ok := s.itemOwnersMany[i]
	if !ok {
		om = &OwnersMany{}
		s.itemOwnersMany[i] = om
	}
	return om
}

// The snapshot methods below are read-only: they never create or clean entries, so callers can hold a read lock while using them.
// They copy the maps so callers never see a map being mutated by a later transfer.

func (s *State) snapshotInventory(id Owner) Items {
	inv, ok := s.ownerItems[id]
	if !ok {
		return Items{}
	}
	return inv.cloneNonZero()
}

func (s *State) snapshotOwnersOne(i CanOwnOne) OwnersOne {
	oo, ok := s.itemOwnersOne[i]
	if !ok {
		return OwnersOne{}
	}

	out := make(OwnersOne, len(*oo))
	for o := range *oo {
		out[o] = struct{}{}
	}
	return out
}

func (s *State) snapshotOwnersMany(i CanOwnMany) OwnersMany {
	om, ok := s.itemOwnersMany[i]
	if !ok {
		return OwnersMany{}
	}

	out := make(OwnersMany, len(*om))
	for o, qty := range *om {
		out[o] = qty
	}
	return out
}

// inventoryOne is the read-only counterpart to GetInventory, used while walking package contents.
func (s *State) inventoryOne(id Owner) ItemsOne {
	inv, ok := s.ownerItems[id]
	if !ok {
		return nil
	}
	return inv.One
}

func (s *State) ownsOne(o Owner, i CanOwnOne) bool {
	inv, ok := s.ownerItems[o]
	if !ok {
		return false
	}
	_, ok = inv.One[i]
	return ok
}

// canIssue reports whether o may issue item i without holding it.
// Any source can always issue the item it creates, and holding a source entitles its holder to issue what that source creates - including, for a nested package, everything inside it.
// Sources are only obtainable by paying for them, so this can't conjure items out of nothing.
// Only assets are covered, because they're the only items that can be owned one-per-person; places and groups must always be held.
func (s *State) canIssue(o Owner, i CanOwnOne) bool {
	switch o := o.(type) {
	case Source:
		return s.packageContents(o).Has(i)
	}
	return false
}

// packageContents returns everything a source will hand over to a buyer: the item it creates, the assets of every source it holds, and the contents of any package sources it holds, recursively. Cycles are guarded against so a package can't contain itself by way of a longer loop.
func (s *State) packageContents(src Source) ItemsOne {
	contents := ItemsOne{}
	s.collectPackageContents(src, contents, make(map[Source]struct{}))
	return contents
}

func (s *State) collectPackageContents(src Source, into ItemsOne, seen map[Source]struct{}) {
	if _, ok := seen[src]; ok {
		return
	}
	seen[src] = struct{}{}

	// a source always hands over the item it creates
	switch src := src.(type) {
	case LimitedSource:
		return // limited assets are CanOwnMany, so they can't go in a One
	case UnlimitedSource:
		into.Add(src.Create())
	case PackageSource:
		into.Add(src.Create())
	}

	for item := range s.inventoryOne(src) {
		switch item := item.(type) {
		case Source:
			s.collectPackageContents(item, into, seen)
		}
	}
}

// PackageContents returns everything a package source will hand over to a buyer: the package itself, plus every asset inside it, nested packages included.
func (s *State) PackageContents(src PackageSource) ItemsOne {
	return s.packageContents(src)
}

// PackageItems returns every asset that is inside some package, across every package in the ledger.
// The Site uses this to keep bundle contents out of catalog and search results, which used to be done by checking for a packageItem relation in the database.
//
// The lookup walks each package source rather than the ownership index: handing a component's source to a package source moves the source, not the asset, so nothing about the asset itself records that it belongs to a bundle.
func (s *State) PackageItems() ItemsOne {
	items := ItemsOne{}

	for owner := range s.ownerItems {
		ps, ok := owner.(PackageSource)
		if !ok {
			continue
		}

		for item := range s.packageContents(ps) {
			// the package itself is for sale, so it's not one of its own contents
			if item == ps.Create() {
				continue
			}
			items.Add(item)
		}
	}

	return items
}

func (s State) CanApply(t Transfer) error {
	if err := t.Valid(); err != nil {
		return fmt.Errorf("invalid transfer: %w", err)
	}

	var errs []error

	for i, send := range t {
		if send.Items.IsEmpty() {
			continue
		}
		inv := s.GetInventory(send.Owner)
		otherinv := s.GetInventory(t[1-i].Owner)
		for coo := range send.Items.One {
			// a source can issue what it's entitled to issue without holding it
			if send.Owner != nil && !s.canIssue(send.Owner, coo) && !inv.One.Has(coo) {
				errs = append(errs, fmt.Errorf("item %v not owned by user %s", coo, send.Owner))
			}

			// check for non-fungible item duplication
			if otherinv.One.Has(coo) {
				errs = append(errs, fmt.Errorf("item %v already owned by user %s", coo, t[1-i].Owner))
			}
		}
		for com, qty := range send.Items.Many {
			if send.Owner != nil && inv.Many[com] < qty {
				errs = append(errs, fmt.Errorf("insufficient quantity of item %v for user %s", com, send.Owner))
			}
		}
	}

	if len(errs) > 0 {
		return errors.Join(errs...)
	}
	return nil
}

func (s *State) addToSourceOwner(src CanOwnOne, i CanOwnMany, qty Quantity) {
	// add currency to to source owner
	var o Owner
	for oo := range *s.GetOwnersOne(src) {
		o = oo
		break
	}
	rdst := s.GetInventory(o)

	rdst.Many.Add(i, qty)
	oMany := s.GetOwnersMany(i)
	oMany.Add(o, qty)
}

// ⚠️ DANGEROUS!! ⚠️ Make sure you've called CanApply first!
func (s *State) ForceApply(t Transfer) {
	sale := t.Sale()

	for i, send := range t {
		if send.Owner != nil {
			src := s.GetInventory(send.Owner)
			for item := range send.Items.One {
				delete(src.One, item)
				oOne := s.GetOwnersOne(item)
				delete(*oOne, send.Owner)
			}
			for item, qty := range send.Items.Many {
				src.Many[item] -= qty
				oMany := s.GetOwnersMany(item)
				(*oMany)[send.Owner] -= qty
			}
		}

		other := t[1-i]
		if other.Owner == nil {
			// nil user, we need not send anything to them
			continue
		}

		dst := s.GetInventory(other.Owner)
		// fmt.Printf("Starting inventory for %v: %v\n", other.Owner, dst)
		for item := range send.Items.One {
			dst.One.Add(item)
			oOne := s.GetOwnersOne(item)
			oOne.Add(other.Owner)
		}

		for item, qty := range send.Items.Many {
			// on a sale, currency is the payment rather than the goods, so it belongs to whoever owns the source
			if _, isCurrency := item.(Currency); sale && isCurrency {
				if src, ok := other.Owner.(CanOwnOne); ok {
					s.addToSourceOwner(src, item, qty)
					continue
				}
			}

			dst.Many.Add(item, qty)
			oMany := s.GetOwnersMany(item)
			oMany.Add(other.Owner, qty)
		}
		// fmt.Printf("Ending inventory for %v: %v\n", other.Owner, dst)
		// fmt.Printf("Ending inventory for %v: %v\n", other.Owner, s.GetInventory(other.Owner))
	}
}

func (s *State) TryApply(t Transfer) error {
	if err := s.CanApply(t); err != nil {
		return err
	}

	s.ForceApply(t)
	return nil
}

const bucketName = "ledger"

var bucketNameBytes = []byte(bucketName)

func (s *State) updateStipend(tid TransferID, t Transfer) {
	for _, send := range t {
		user, ok := send.Owner.(User)
		if !ok {
			continue
		}
		s.userLastStipend[user] = tid
		return
	}
}

func (s *State) applyKVPair() func(k, v []byte) error {
	return func(k, v []byte) error {
		tid, err := DeserialiseTransferID(k)
		if err != nil {
			return fmt.Errorf("decode transfer ID: %w", err)
		}

		// decode v into Transfer
		t, err := DeserialiseTransfer(bytes.NewReader(v))
		if err != nil {
			return fmt.Errorf("decode transfer %v: %w", tid, err)
		}

		if err := t.Valid(); err != nil {
			return fmt.Errorf("invalid transfer with ID %v: %w", tid, err)
		}

		// apply transfer to state
		if err := s.TryApply(t); err != nil {
			return fmt.Errorf("apply transfer %v: %w", tid, err)
		}

		if t.Stipend() {
			s.updateStipend(tid, t)
		}

		return nil
	}
}

func ReadState(db *bolt.DB) (State, error) {
	s := makeState()

	err := db.View(func(tx *bolt.Tx) error {
		bucket := tx.Bucket(bucketNameBytes)
		if bucket == nil {
			return nil // empty state
		}

		return bucket.ForEach(s.applyKVPair())
	})
	return s, err
}

type Ledger struct {
	// mu guards state. Transfers hold the write lock for the whole check, persist and apply sequence, so no two transfers can validate against the same state.
	mu    sync.RWMutex
	db    *bolt.DB
	state State
}

func NewLedger(dbPath string) (*Ledger, error) {
	db, err := bolt.Open(dbPath, 0o600, nil)
	if err != nil {
		return nil, fmt.Errorf("open db: %w", err)
	}

	s, err := ReadState(db)
	if err != nil {
		return nil, fmt.Errorf("read state: %w", err)
	}

	return &Ledger{db: db, state: s}, nil
}

func (l *Ledger) Close() error {
	l.mu.Lock()
	defer l.mu.Unlock()

	l.state = State{}
	return l.db.Close()
}

func (l *Ledger) OwnsOne(o Owner, i CanOwnOne) bool {
	l.mu.RLock()
	defer l.mu.RUnlock()

	return l.state.ownsOne(o, i)
}

func (l *Ledger) OwnsMany(o Owner, i CanOwnMany) Quantity {
	l.mu.RLock()
	defer l.mu.RUnlock()

	inv, ok := l.state.ownerItems[o]
	if !ok {
		return 0
	}
	return inv.Many[i]
}

func (l *Ledger) Inventory(id Owner) Items {
	l.mu.RLock()
	defer l.mu.RUnlock()

	return l.state.snapshotInventory(id)
}

func (l *Ledger) OwnersOne(i CanOwnOne) OwnersOne {
	l.mu.RLock()
	defer l.mu.RUnlock()

	return l.state.snapshotOwnersOne(i)
}

func (l *Ledger) OwnersMany(i CanOwnMany) OwnersMany {
	l.mu.RLock()
	defer l.mu.RUnlock()

	return l.state.snapshotOwnersMany(i)
}

func (l *Ledger) PackageContents(src PackageSource) ItemsOne {
	l.mu.RLock()
	defer l.mu.RUnlock()

	return l.state.PackageContents(src)
}

func (l *Ledger) PackageItems() ItemsOne {
	l.mu.RLock()
	defer l.mu.RUnlock()

	return l.state.PackageItems()
}

func (l *Ledger) Transfer(tid TransferID, t Transfer) error {
	return l.transferWithCheck(tid, t, nil)
}

// transferWithCheck locks the ledger, runs check against the current state, then validates, persists and applies the transfer.
// Keeping the check inside the lock is what stops two concurrent requests from both acting on the same pre-transfer state.
func (l *Ledger) transferWithCheck(tid TransferID, t Transfer, check func(*State) error) error {
	l.mu.Lock()
	defer l.mu.Unlock()

	if check != nil {
		if err := check(&l.state); err != nil {
			return err
		}
	}

	return l.applyLocked(tid, t)
}

// transferPrepared builds the transfer inside the lock, so anything read from state to build it can't change before it is applied.
// prepare must only use the State it is given, not call back into Ledger methods that take the lock.
func (l *Ledger) transferPrepared(tid TransferID, prepare func(*State) (Transfer, error)) error {
	l.mu.Lock()
	defer l.mu.Unlock()

	t, err := prepare(&l.state)
	if err != nil {
		return err
	}

	return l.applyLocked(tid, t)
}

// applyLocked validates, persists and applies a transfer. The caller must hold l.mu.
func (l *Ledger) applyLocked(tid TransferID, t Transfer) error {
	// Process the transfer
	if err := l.state.CanApply(t); err != nil {
		return fmt.Errorf("validate transfer: %w", err)
	}

	// Append the transfer to the database
	err := l.db.Update(func(tx *bolt.Tx) error {
		bucket, err := tx.CreateBucketIfNotExists(bucketNameBytes)
		if err != nil {
			return fmt.Errorf("create bucket: %w", err)
		}

		buf := &bytes.Buffer{}
		if err := t.Serialise(buf); err != nil {
			return fmt.Errorf("serialise transfer: %w", err)
		}
		if err := bucket.Put(tid.Serialise(), buf.Bytes()); err != nil {
			return fmt.Errorf("put transfer: %w", err)
		}

		return nil
	})
	if err != nil {
		return fmt.Errorf("append transfer to db: %w", err)
	}

	if t.Stipend() {
		l.state.updateStipend(tid, t)
	}

	// Apply the transfer to the in-memory state
	l.state.ForceApply(t)
	return nil
}

func (l *Ledger) TransferHistory(n int) (twids []TransferWithID, err error) {
	// funky return ordering
	return twids, l.db.View(func(tx *bolt.Tx) error {
		bucket := tx.Bucket(bucketNameBytes)
		if bucket == nil {
			return nil // no transfers
		}

		c := bucket.Cursor()
		for k, v := c.Last(); v != nil && len(twids) < n; k, v = c.Prev() {
			t, err := DeserialiseTransfer(bytes.NewReader(v))
			if err != nil {
				return fmt.Errorf("decode transfer: %w", err)
			}

			id, err := DeserialiseTransferID(k)
			if err != nil {
				return fmt.Errorf("decode transfer ID: %w", err)
			}

			twids = append(twids, TransferWithID{
				ID:       id,
				Transfer: t,
			})
		}

		return nil
	})
}

func (l *Ledger) TransferHistoryOwner(n int, o Owner) (twids []TransferWithID, err error) {
	return twids, l.db.View(func(tx *bolt.Tx) error {
		bucket := tx.Bucket(bucketNameBytes)
		if bucket == nil {
			return nil // no transfers
		}

		c := bucket.Cursor()
		for k, v := c.Last(); v != nil && len(twids) < n; k, v = c.Prev() {
			t, err := DeserialiseTransfer(bytes.NewReader(v))
			if err != nil {
				return fmt.Errorf("decode transfer: %w", err)
			}

			// TODO: find a better way because this could iterate over ALL the transactions
			if t[0].Owner != o && t[1].Owner != o {
				continue
			}

			id, err := DeserialiseTransferID(k)
			if err != nil {
				return fmt.Errorf("decode transfer ID: %w", err)
			}

			twids = append(twids, TransferWithID{
				ID:       id,
				Transfer: t,
			})
		}

		return nil
	})
}

func (l *Ledger) GetTransfer(tid TransferID) (t Transfer, err error) {
	return t, l.db.View(func(tx *bolt.Tx) error {
		bucket := tx.Bucket(bucketNameBytes)
		if bucket == nil {
			return nil
		}

		v := bucket.Get(tid.Serialise())
		if v == nil {
			return nil
		}

		var err2 error
		t, err2 = DeserialiseTransfer(bytes.NewReader(v))
		if err2 != nil {
			return fmt.Errorf("decode transfer: %w", err2)
		}

		return nil
	})
}

func (l *Ledger) GetUserLastStipend(u User) (TransferID, bool) {
	l.mu.RLock()
	defer l.mu.RUnlock()

	tid, ok := l.state.userLastStipend[u]
	return tid, ok
}
