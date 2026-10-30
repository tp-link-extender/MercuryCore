package main

import (
	"bufio"
	"context"
	"encoding/json"
	"fmt"
	"os"
	"sort"
	"strings"
	"time"

	surrealdb "github.com/surrealdb/surrealdb.go"
)

const snapshotVersion = 2

type legacyAsset struct {
	ID   uint32 `json:"id"`
	Type int    `json:"type"`
	Name string `json:"name"`
}

type legacyCreator struct {
	AssetID uint32 `json:"assetId"`
	UserID  string `json:"userId"`
}

type legacyAssetOwner struct {
	AssetID uint32 `json:"assetId"`
	UserID  string `json:"userId"`
}

type legacyPackageChild struct {
	PackageID uint32 `json:"packageId"`
	ChildID   uint32 `json:"childId"`
}

type legacyPlace struct {
	ID   uint32 `json:"id"`
	Name string `json:"name"`
}

type legacyPlaceOwner struct {
	PlaceID uint32 `json:"placeId"`
	UserID  string `json:"userId"`
}

type legacyGroup struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type legacyGroupOwner struct {
	GroupID string `json:"groupId"`
	UserID  string `json:"userId"`
}

type legacySnapshot struct {
	Version         int                  `json:"version"`
	CreatedAt       time.Time            `json:"createdAt"`
	OldLedger       string               `json:"oldLedger"`
	Users           []string             `json:"users"`
	Assets          []legacyAsset        `json:"assets"`
	Creators        []legacyCreator      `json:"creators"`
	AssetOwners     []legacyAssetOwner   `json:"assetOwners"`
	PackageChildren []legacyPackageChild `json:"packageChildren"`
	Places          []legacyPlace        `json:"places"`
	PlaceOwners     []legacyPlaceOwner   `json:"placeOwners"`
	Groups          []legacyGroup        `json:"groups"`
	GroupOwners     []legacyGroupOwner   `json:"groupOwners"`
	BalancesMicro   map[string]uint64    `json:"balancesMicro"`
	DustMicro       map[string]uint64    `json:"dustMicro"`
	LastStipends    map[string]uint64    `json:"lastStipends"`
	Warnings        []string             `json:"warnings"`
}

type surrealClient struct {
	ctx context.Context
	db  *surrealdb.DB
}

func newSurrealClient(url, namespace, database, user, pass string) (*surrealClient, error) {
	ctx := context.Background()
	db, err := surrealdb.FromEndpointURLString(ctx, url)
	if err != nil {
		return nil, fmt.Errorf("connect surreal: %w", err)
	}

	if err := db.Use(ctx, namespace, database); err != nil {
		db.Close(ctx)
		return nil, fmt.Errorf("use surreal namespace/database: %w", err)
	}
	if _, err := db.SignIn(ctx, surrealdb.Auth{Username: user, Password: pass}); err != nil {
		db.Close(ctx)
		return nil, fmt.Errorf("sign in to surreal: %w", err)
	}

	return &surrealClient{ctx: ctx, db: db}, nil
}

func (c *surrealClient) Close() error {
	return c.db.Close(c.ctx)
}

func query[T any](c *surrealClient, sql string, vars map[string]any) ([]T, error) {
	results, err := surrealdb.Query[[]T](c.ctx, c.db, sql, vars)
	if err != nil {
		return nil, err
	}
	if results == nil || len(*results) == 0 {
		return nil, fmt.Errorf("surreal returned no statement results")
	}
	if len(*results) != 1 {
		return nil, fmt.Errorf("surreal returned %d statement results, expected 1", len(*results))
	}

	qr := (*results)[0]
	if qr.Error != nil {
		return nil, fmt.Errorf("surreal query failed: %w", qr.Error)
	}
	if qr.Status != "OK" {
		return nil, fmt.Errorf("surreal query status %q", qr.Status)
	}
	return qr.Result, nil
}

func exportSnapshot(c *surrealClient, oldLedger string) (*legacySnapshot, error) {
	s := &legacySnapshot{
		Version:       snapshotVersion,
		CreatedAt:     time.Now().UTC(),
		OldLedger:     oldLedger,
		BalancesMicro: make(map[string]uint64),
		DustMicro:     make(map[string]uint64),
		LastStipends:  make(map[string]uint64),
	}

	if rows, err := query[string](c, "SELECT VALUE record::id(id) FROM user;", nil); err != nil {
		return nil, fmt.Errorf("query users: %w", err)
	} else {
		s.Users = rows
	}
	if rows, err := query[legacyAsset](c, "SELECT record::id(id) AS id, type, name FROM asset;", nil); err != nil {
		return nil, fmt.Errorf("query assets: %w", err)
	} else {
		s.Assets = rows
	}
	if rows, err := query[legacyCreator](c, "SELECT record::id(in) AS userId, record::id(out) AS assetId FROM created;", nil); err != nil {
		return nil, fmt.Errorf("query created: %w", err)
	} else {
		s.Creators = rows
	}
	if rows, err := query[legacyAssetOwner](c, "SELECT record::id(in) AS userId, record::id(out) AS assetId FROM ownsAsset;", nil); err != nil {
		return nil, fmt.Errorf("query ownsAsset: %w", err)
	} else {
		s.AssetOwners = rows
	}
	if rows, err := query[legacyPackageChild](c, "SELECT record::id(in) AS packageId, record::id(out) AS childId FROM packageItem;", nil); err != nil {
		return nil, fmt.Errorf("query packageItem: %w", err)
	} else {
		s.PackageChildren = rows
	}
	if rows, err := query[legacyPlace](c, "SELECT record::id(id) AS id, name FROM place;", nil); err != nil {
		return nil, fmt.Errorf("query places: %w", err)
	} else {
		s.Places = rows
	}
	if rows, err := query[legacyPlaceOwner](c, "SELECT record::id(in) AS userId, record::id(out) AS placeId FROM ownsPlace;", nil); err != nil {
		return nil, fmt.Errorf("query ownsPlace: %w", err)
	} else {
		s.PlaceOwners = rows
	}
	if rows, err := query[legacyGroup](c, "SELECT record::id(id) AS id, name FROM group;", nil); err != nil {
		return nil, fmt.Errorf("query groups: %w", err)
	} else {
		s.Groups = rows
	}
	if rows, err := query[legacyGroupOwner](c, "SELECT record::id(in) AS userId, record::id(out) AS groupId FROM ownsGroup;", nil); err != nil {
		return nil, fmt.Errorf("query ownsGroup: %w", err)
	} else {
		s.GroupOwners = rows
	}

	if oldLedger != "" {
		if err := parseOldLedger(oldLedger, s); err != nil {
			return nil, err
		}
	}

	sortSnapshot(s)
	return s, nil
}

// holy sorting taskmanager
func sortSnapshot(s *legacySnapshot) {
	sort.Strings(s.Users)
	sort.Slice(s.Assets, func(i, j int) bool { return s.Assets[i].ID < s.Assets[j].ID })
	sort.Slice(s.Creators, func(i, j int) bool {
		if s.Creators[i].AssetID != s.Creators[j].AssetID {
			return s.Creators[i].AssetID < s.Creators[j].AssetID
		}
		return s.Creators[i].UserID < s.Creators[j].UserID
	})
	sort.Slice(s.AssetOwners, func(i, j int) bool {
		if s.AssetOwners[i].AssetID != s.AssetOwners[j].AssetID {
			return s.AssetOwners[i].AssetID < s.AssetOwners[j].AssetID
		}
		return s.AssetOwners[i].UserID < s.AssetOwners[j].UserID
	})
	sort.Slice(s.PackageChildren, func(i, j int) bool {
		if s.PackageChildren[i].PackageID != s.PackageChildren[j].PackageID {
			return s.PackageChildren[i].PackageID < s.PackageChildren[j].PackageID
		}
		return s.PackageChildren[i].ChildID < s.PackageChildren[j].ChildID
	})
	sort.Slice(s.Places, func(i, j int) bool { return s.Places[i].ID < s.Places[j].ID })
	sort.Slice(s.PlaceOwners, func(i, j int) bool {
		if s.PlaceOwners[i].PlaceID != s.PlaceOwners[j].PlaceID {
			return s.PlaceOwners[i].PlaceID < s.PlaceOwners[j].PlaceID
		}
		return s.PlaceOwners[i].UserID < s.PlaceOwners[j].UserID
	})
	sort.Slice(s.Groups, func(i, j int) bool { return s.Groups[i].ID < s.Groups[j].ID })
	sort.Slice(s.GroupOwners, func(i, j int) bool {
		if s.GroupOwners[i].GroupID != s.GroupOwners[j].GroupID {
			return s.GroupOwners[i].GroupID < s.GroupOwners[j].GroupID
		}
		return s.GroupOwners[i].UserID < s.GroupOwners[j].UserID
	})
}

type oldLedgerRecord struct {
	To      string            `json:"To"`
	From    string            `json:"From"`
	Amount  uint64            `json:"Amount"`
	Note    string            `json:"Note"`
	Link    string            `json:"Link"`
	Time    uint64            `json:"Time"`
	ID      string            `json:"Id"`
	Returns map[string]uint64 `json:"Returns"`
}

func parseOldLedger(path string, s *legacySnapshot) error {
	if s.BalancesMicro == nil {
		s.BalancesMicro = make(map[string]uint64)
	}
	if s.DustMicro == nil {
		s.DustMicro = make(map[string]uint64)
	}
	if s.LastStipends == nil {
		s.LastStipends = make(map[string]uint64)
	}

	f, err := os.Open(path)
	if err != nil {
		return fmt.Errorf("open old ledger: %w", err)
	}
	defer f.Close()

	const microPerUnit = 1_000_000
	raw := make(map[string]uint64)

	scanner := bufio.NewScanner(f)
	scanner.Buffer(make([]byte, 0, 64<<10), 4<<20)
	lineNo := 0
	for scanner.Scan() {
		lineNo++
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}

		parts := strings.SplitN(line, " ", 2)
		if len(parts) != 2 {
			return fmt.Errorf("%s:%d: malformed ledger line", path, lineNo)
		}

		var rec oldLedgerRecord
		if err := json.Unmarshal([]byte(parts[1]), &rec); err != nil {
			return fmt.Errorf("%s:%d: decode record: %w", path, lineNo, err)
		}
		if len(rec.Returns) > 0 {
			return fmt.Errorf("%s:%d: old asset returns are not supported by the snapshot migration", path, lineNo)
		}
		if rec.Amount == 0 {
			return fmt.Errorf("%s:%d: zero-amount records are not supported", path, lineNo)
		}

		switch parts[0] {
		case "Mint":
			if rec.To == "" {
				return fmt.Errorf("%s:%d: mint has no recipient", path, lineNo)
			}
			if raw[rec.To] > ^uint64(0)-rec.Amount {
				return fmt.Errorf("%s:%d: mint overflows balance for %s", path, lineNo, rec.To)
			}
			raw[rec.To] += rec.Amount
			if rec.Note == "Stipend" && rec.Time > s.LastStipends[rec.To] {
				s.LastStipends[rec.To] = rec.Time
			}
		case "Burn":
			if rec.From == "" {
				return fmt.Errorf("%s:%d: burn has no sender", path, lineNo)
			}
			if rec.Amount > raw[rec.From] {
				return fmt.Errorf("%s:%d: burn exceeds balance for %s", path, lineNo, rec.From)
			}
			raw[rec.From] -= rec.Amount
		case "Transaction":
			if rec.From == "" || rec.To == "" {
				return fmt.Errorf("%s:%d: transaction missing sender or recipient", path, lineNo)
			}
			if rec.Amount > raw[rec.From] {
				return fmt.Errorf("%s:%d: transaction exceeds balance for %s", path, lineNo, rec.From)
			}
			raw[rec.From] -= rec.Amount
			if raw[rec.To] > ^uint64(0)-rec.Amount {
				return fmt.Errorf("%s:%d: transaction overflows balance for %s", path, lineNo, rec.To)
			}
			raw[rec.To] += rec.Amount
		default:
			return fmt.Errorf("%s:%d: unknown ledger record type %q", path, lineNo, parts[0])
		}
	}
	if err := scanner.Err(); err != nil {
		return fmt.Errorf("read old ledger: %w", err)
	}

	for user, micro := range raw {
		units := micro / microPerUnit
		dust := micro % microPerUnit
		if units > 0 {
			s.BalancesMicro[user] = micro // conversion happens in the planner
		}
		if dust > 0 {
			s.DustMicro[user] = dust
		}
	}

	if len(s.DustMicro) > 0 {
		s.Warnings = append(s.Warnings, fmt.Sprintf("%d users have sub-unit old balances; dust will be dropped", len(s.DustMicro)))
	}
	return nil
}

func writeJSON(path string, v any) error {
	data, err := json.MarshalIndent(v, "", "  ")
	if err != nil {
		return err
	}
	data = append(data, '\n')
	if err := os.WriteFile(path, data, 0o600); err != nil {
		return err
	}
	return nil
}

func readSnapshot(path string) (*legacySnapshot, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var s legacySnapshot
	if err := json.Unmarshal(data, &s); err != nil {
		return nil, err
	}
	if s.Version != snapshotVersion {
		return nil, fmt.Errorf("snapshot version %d is not supported; re-export with --export (expected version %d)", s.Version, snapshotVersion)
	}
	return &s, nil
}
