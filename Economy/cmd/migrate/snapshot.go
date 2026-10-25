package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"sort"
	"strings"
	"time"
)

const snapshotVersion = 1

type legacyAsset struct {
	ID   uint32 `json:"id"`
	Type int    `json:"type"`
	Name string `json:"name"`
}

type legacyCreator struct {
	AssetID uint32 `json:"assetId"`
	UserID  string `json:"userId"`
	Created string `json:"created"`
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
	url, namespace, database, user, pass string
	http                                 *http.Client
}

type surrealResult struct {
	Result  json.RawMessage `json:"result"`
	Status  string          `json:"status"`
	Details any             `json:"details"`
}

func newSurrealClient(url, namespace, database, user, pass string) *surrealClient {
	return &surrealClient{
		url:       strings.TrimRight(url, "/"),
		namespace: namespace,
		database:  database,
		user:      user,
		pass:      pass,
		http:      &http.Client{Timeout: 60 * time.Second},
	}
}

func (c *surrealClient) query(sql string, out any) error {
	req, err := http.NewRequest(http.MethodPost, c.url+"/sql", bytes.NewBufferString(sql))
	if err != nil {
		return fmt.Errorf("build surreal request: %w", err)
	}
	req.Header.Set("Accept", "application/json")
	req.Header.Set("surreal-ns", c.namespace)
	req.Header.Set("surreal-db", c.database)
	req.SetBasicAuth(c.user, c.pass)

	res, err := c.http.Do(req)
	if err != nil {
		return fmt.Errorf("query surreal: %w", err)
	}
	defer res.Body.Close()

	body, err := io.ReadAll(io.LimitReader(res.Body, 256<<20))
	if err != nil {
		return fmt.Errorf("read surreal response: %w", err)
	}
	if res.StatusCode != http.StatusOK {
		return fmt.Errorf("surreal returned %d: %s", res.StatusCode, strings.TrimSpace(string(body)))
	}

	var results []surrealResult
	if err := json.Unmarshal(body, &results); err != nil {
		return fmt.Errorf("decode surreal response: %w", err)
	}
	if len(results) == 0 {
		return fmt.Errorf("surreal returned no statement results")
	}
	if results[0].Status != "OK" {
		return fmt.Errorf("surreal query failed: %v", results[0].Details)
	}
	if out == nil {
		return nil
	}
	if err := json.Unmarshal(results[0].Result, out); err != nil {
		return fmt.Errorf("decode surreal result: %w", err)
	}
	return nil
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

	if err := c.query("SELECT record::id(id) AS id, type, name FROM asset;", &s.Assets); err != nil {
		return nil, fmt.Errorf("query assets: %w", err)
	}
	if err := c.query("SELECT record::id(in) AS userId, record::id(out) AS assetId, created FROM created;", &s.Creators); err != nil {
		return nil, fmt.Errorf("query created: %w", err)
	}
	if err := c.query("SELECT record::id(in) AS userId, record::id(out) AS assetId FROM ownsAsset;", &s.AssetOwners); err != nil {
		return nil, fmt.Errorf("query ownsAsset: %w", err)
	}
	if err := c.query("SELECT record::id(in) AS packageId, record::id(out) AS childId FROM packageItem;", &s.PackageChildren); err != nil {
		return nil, fmt.Errorf("query packageItem: %w", err)
	}
	if err := c.query("SELECT record::id(id) AS id, name FROM place;", &s.Places); err != nil {
		return nil, fmt.Errorf("query places: %w", err)
	}
	if err := c.query("SELECT record::id(in) AS userId, record::id(out) AS placeId FROM ownsPlace;", &s.PlaceOwners); err != nil {
		return nil, fmt.Errorf("query ownsPlace: %w", err)
	}
	if err := c.query("SELECT record::id(id) AS id, name FROM group;", &s.Groups); err != nil {
		return nil, fmt.Errorf("query groups: %w", err)
	}
	if err := c.query("SELECT record::id(in) AS userId, record::id(out) AS groupId FROM ownsGroup;", &s.GroupOwners); err != nil {
		return nil, fmt.Errorf("query ownsGroup: %w", err)
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
	sort.Slice(s.Assets, func(i, j int) bool { return s.Assets[i].ID < s.Assets[j].ID })
	sort.Slice(s.Creators, func(i, j int) bool {
		if s.Creators[i].AssetID != s.Creators[j].AssetID {
			return s.Creators[i].AssetID < s.Creators[j].AssetID
		}
		if s.Creators[i].Created != s.Creators[j].Created {
			return s.Creators[i].Created < s.Creators[j].Created
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
	return &s, nil
}
