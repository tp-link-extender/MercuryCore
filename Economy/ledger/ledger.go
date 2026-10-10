package ledger

import (
	"bytes"
	"errors"
	"fmt"

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
			// check if it's an asset mint from an unlimited source, if it is then skip this check
			if send.Owner != nil && !send.UnlimitedSourceAssetMint() && !inv.One.Has(coo) {
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

		if !sale {
			for item, qty := range send.Items.Many {
				dst.Many.Add(item, qty)
				oMany := s.GetOwnersMany(item)
				oMany.Add(other.Owner, qty)
			}
			continue
		}

		// TODO:
		// If the source owner is a user, this is handled correctly, items are added to their inventory
		// If the source owner is a group, this should work fine (funds should have to be withdrawn from groups manually)
		// we could make it the same for sources though I don't really see why
		for item, qty := range send.Items.Many {
			if src, ok := other.Owner.(CanOwnOne); ok {
				s.addToSourceOwner(src, item, qty)
			}
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

	return &Ledger{db, s}, nil
}

func (l *Ledger) Close() error {
	l.state = State{}
	return l.db.Close()
}

func (l *Ledger) Inventory(id Owner) *Items {
	return l.state.GetInventory(id)
}

func (l *Ledger) Transfer(tid TransferID, t Transfer) error {
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
	tid, ok := l.state.userLastStipend[u]
	return tid, ok
}
