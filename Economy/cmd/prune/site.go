package main

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"

	sdb "Economy/internal/surreal"
)

type dbInfo struct {
	Tables map[string]any `json:"tables"`
}

type countRow struct {
	N int `json:"n"`
}

func loadTables(c *sdb.Client) (map[string]bool, error) {
	info, err := sdb.QueryOne[dbInfo](c, "INFO FOR DB;", nil)
	if err != nil {
		return nil, fmt.Errorf("query database info: %w", err)
	}
	tables := make(map[string]bool, len(info.Tables))
	for name := range info.Tables {
		tables[name] = true
	}
	return tables, nil
}

func loadAssets(c *sdb.Client) ([]dbAsset, error) {
	rows, err := sdb.Query[dbAsset](c, "SELECT record::id(id) AS id, type, name FROM asset;", nil)
	if err != nil {
		return nil, fmt.Errorf("query assets: %w", err)
	}
	return rows, nil
}

func loadPackageChildren(c *sdb.Client, tables map[string]bool) ([]dbPackageChild, error) {
	if !tables["packageItem"] {
		return nil, nil
	}
	rows, err := sdb.Query[dbPackageChild](c, "SELECT record::id(in) AS packageId, record::id(out) AS childId FROM packageItem;", nil)
	if err != nil {
		return nil, fmt.Errorf("query packageItem: %w", err)
	}
	return rows, nil
}

func loadCommentIDs(c *sdb.Client, removedIDs []uint32, removedIDStrings []string) ([]string, error) {
	rows, err := sdb.Query[string](c, `SELECT VALUE record::id(id) FROM comment WHERE type[0] = "asset" AND (type[1] IN $removedIds OR type[1] IN $removedIdStrings);`, map[string]any{
		"removedIds":       removedIDs,
		"removedIdStrings": removedIDStrings,
	})
	if err != nil {
		return nil, fmt.Errorf("query asset comments: %w", err)
	}
	return rows, nil
}

func loadOrphanImages(c *sdb.Client, tables map[string]bool, primary []uint32) ([]uint32, error) {
	if !tables["imageAsset"] {
		return nil, nil
	}
	candidates, err := sdb.Query[uint32](c, `SELECT VALUE record::id(out) FROM imageAsset WHERE record::id(in) IN $primary;`, map[string]any{"primary": primary})
	if err != nil {
		return nil, fmt.Errorf("query imageAsset candidates: %w", err)
	}
	kept, err := sdb.Query[uint32](c, `SELECT VALUE record::id(out) FROM imageAsset WHERE record::id(in) NOT IN $primary;`, map[string]any{"primary": primary})
	if err != nil {
		return nil, fmt.Errorf("query retained imageAsset: %w", err)
	}
	keptSet := make(map[uint32]struct{}, len(kept))
	for _, id := range kept {
		keptSet[id] = struct{}{}
	}
	seen := make(map[uint32]struct{}, len(candidates))
	orphans := make([]uint32, 0, len(candidates))
	for _, id := range candidates {
		if _, ok := keptSet[id]; ok {
			continue
		}
		if _, ok := seen[id]; ok {
			continue
		}
		seen[id] = struct{}{}
		orphans = append(orphans, id)
	}
	sort.Slice(orphans, func(i, j int) bool { return orphans[i] < orphans[j] })
	return orphans, nil
}

type countQuery struct {
	name string
	sql  string
}

func siteCounts(c *sdb.Client, tables map[string]bool, removedIDs []uint32, removedIDStrings []string, commentIDs []string, orphanIDs []uint32) (map[string]int, error) {
	vars := map[string]any{
		"removedIds":       removedIDs,
		"removedIdStrings": removedIDStrings,
		"commentIds":       commentIDs,
		"orphanIds":        orphanIDs,
	}
	queries := []countQuery{
		{"assets", `SELECT count() AS n FROM asset WHERE record::id(id) IN $removedIds GROUP ALL;`},
		{"comments", `SELECT count() AS n FROM comment WHERE record::id(id) IN $commentIds GROUP ALL;`},
	}
	if tables["commentLink"] {
		queries = append(queries, countQuery{"commentLinks", `SELECT count() AS n FROM commentLink WHERE record::id(in) IN $commentIds OR record::id(out) IN $commentIds GROUP ALL;`})
	}
	if tables["createdComment"] {
		queries = append(queries, countQuery{"createdComments", `SELECT count() AS n FROM createdComment WHERE record::id(out) IN $commentIds GROUP ALL;`})
	}
	if tables["likes"] {
		queries = append(queries, countQuery{"likes", `SELECT count() AS n FROM likes WHERE record::id(out) IN $removedIds OR record::id(out) IN $commentIds GROUP ALL;`})
	}
	if tables["dislikes"] {
		queries = append(queries, countQuery{"dislikes", `SELECT count() AS n FROM dislikes WHERE record::id(out) IN $removedIds OR record::id(out) IN $commentIds GROUP ALL;`})
	}
	if tables["wearing"] {
		queries = append(queries, countQuery{"wearing", `SELECT count() AS n FROM wearing WHERE record::id(out) IN $removedIds GROUP ALL;`})
	}
	if tables["recentlyWorn"] {
		queries = append(queries, countQuery{"recentlyWorn", `SELECT count() AS n FROM recentlyWorn WHERE record::id(out) IN $removedIds GROUP ALL;`})
	}
	if tables["imageAsset"] {
		queries = append(queries, countQuery{"imageAssets", `SELECT count() AS n FROM imageAsset WHERE record::id(in) IN $removedIds OR record::id(out) IN $removedIds OR record::id(out) IN $orphanIds GROUP ALL;`})
	}
	if tables["notification"] {
		queries = append(queries, countQuery{"notifications", `SELECT count() AS n FROM notification WHERE relativeId IN $commentIds OR (type = "ItemPurchase" AND relativeId IN $removedIdStrings) GROUP ALL;`})
	}
	if tables["render"] {
		queries = append(queries, countQuery{"renders", `SELECT count() AS n FROM render WHERE (relativeId IN $removedIds OR relativeId IN $removedIdStrings) AND type != "Avatar" GROUP ALL;`})
	}
	if tables["created"] {
		queries = append(queries, countQuery{"createdRelations", `SELECT count() AS n FROM created WHERE record::id(out) IN $removedIds GROUP ALL;`})
	}
	if tables["ownsAsset"] {
		queries = append(queries, countQuery{"ownsAssetRelations", `SELECT count() AS n FROM ownsAsset WHERE record::id(out) IN $removedIds GROUP ALL;`})
	}
	if tables["packageItem"] {
		queries = append(queries, countQuery{"packageItems", `SELECT count() AS n FROM packageItem GROUP ALL;`})
	}

	counts := make(map[string]int, len(queries))
	for _, q := range queries {
		rows, err := sdb.Query[countRow](c, q.sql, vars)
		if err != nil {
			return nil, fmt.Errorf("count %s: %w", q.name, err)
		}
		if len(rows) > 0 {
			counts[q.name] = rows[0].N
		}
	}
	return counts, nil
}

func cleanupSQL(tables map[string]bool) string {
	lines := []string{"BEGIN TRANSACTION;"}
	add := func(table, sql string) {
		if tables[table] {
			lines = append(lines, sql)
		}
	}
	add("createdComment", "DELETE createdComment WHERE record::id(out) IN $commentIds;")
	add("commentLink", "DELETE commentLink WHERE record::id(in) IN $commentIds OR record::id(out) IN $commentIds;")
	add("likes", "DELETE likes WHERE record::id(out) IN $removedIds OR record::id(out) IN $commentIds;")
	add("dislikes", "DELETE dislikes WHERE record::id(out) IN $removedIds OR record::id(out) IN $commentIds;")
	add("wearing", "DELETE wearing WHERE record::id(out) IN $removedIds;")
	add("recentlyWorn", "DELETE recentlyWorn WHERE record::id(out) IN $removedIds;")
	add("imageAsset", "DELETE imageAsset WHERE record::id(in) IN $removedIds OR record::id(out) IN $removedIds OR record::id(out) IN $orphanIds;")
	add("notification", `DELETE notification WHERE relativeId IN $commentIds OR (type = "ItemPurchase" AND relativeId IN $removedIdStrings);`)
	add("render", `DELETE render WHERE (relativeId IN $removedIds OR relativeId IN $removedIdStrings) AND type != "Avatar";`)
	add("created", "DELETE created WHERE record::id(out) IN $removedIds;")
	add("ownsAsset", "DELETE ownsAsset WHERE record::id(out) IN $removedIds;")
	add("packageItem", "DELETE packageItem;")
	lines = append(lines,
		"DELETE comment WHERE record::id(id) IN $commentIds;",
		"DELETE asset WHERE record::id(id) IN $removedIds;",
		"COMMIT TRANSACTION;",
	)
	return strings.Join(lines, "\n")
}

func applySite(c *sdb.Client, tables map[string]bool, removedIDs []uint32, removedIDStrings []string, commentIDs []string, orphanIDs []uint32) error {
	return sdb.Exec(c, cleanupSQL(tables), map[string]any{
		"removedIds":       removedIDs,
		"removedIdStrings": removedIDStrings,
		"commentIds":       commentIDs,
		"orphanIds":        orphanIDs,
	})
}

func deleteFiles(ids []uint32, assetsDir, thumbnailsDir string, dryRun bool) fileReport {
	var report fileReport
	seen := make(map[uint32]struct{}, len(ids))
	for _, id := range ids {
		if _, ok := seen[id]; ok {
			continue
		}
		seen[id] = struct{}{}
		for _, path := range []string{
			filepath.Join(assetsDir, fmt.Sprintf("%d", id)),
			filepath.Join(thumbnailsDir, fmt.Sprintf("%d", id)),
		} {
			info, err := os.Stat(path)
			if os.IsNotExist(err) {
				report.Missing = append(report.Missing, path)
				continue
			}
			if err != nil {
				report.Errors = append(report.Errors, fmt.Sprintf("%s: %v", path, err))
				continue
			}
			if info.IsDir() {
				report.Errors = append(report.Errors, fmt.Sprintf("%s: is a directory", path))
				continue
			}
			if dryRun {
				report.Planned = append(report.Planned, path)
				continue
			}
			if err := os.Remove(path); err != nil {
				report.Errors = append(report.Errors, fmt.Sprintf("%s: %v", path, err))
				continue
			}
			report.Deleted = append(report.Deleted, path)
		}
	}
	return report
}
