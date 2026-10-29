# Legacy Economy migration

This command imports the old JSONL economy ledger and the old database ownership relations into a fresh new-format bbolt ledger. It uses the official SurrealDB Go SDK for database queries.

The migration is intentionally a snapshot import:

- Currency: old final balances become `Currency{0}` mints. Amounts are converted from micro-units to whole units with floor rounding; dust is reported.
- Assets: old `created` relations become issuing sources. Old `ownsAsset` relations become asset-item ownership.
- Packages: old `packageItem` relations become `PackageSource` components. Nested packages are supported.
- Places/groups: old `ownsPlace`/`ownsGroup` relations become `Place`/`Group` ledger ownership.
- Users: every referenced user is checked against the current `user` table, so a deleted account cannot receive a balance or own a migrated source/item.
- Old history notes/links are not represented in the new ledger. Keep the old JSONL file as the archive.

## Safety

Run with the Site and Economy service stopped. Back up:

- the old `data/economy/ledger`
- the old ledger currently used by the new service (`Economy/mydb.db`)
- the SurrealDB data directory

The command refuses to overwrite an existing output unless `--force` is passed. A dry run builds and verifies a temporary ledger, then removes it.

## Workflow

From `Economy/`:

```sh
# 1. export the legacy database snapshot for review
go run ./cmd/migrate \
  --export /tmp/legacy-export.json \
  --old-ledger ../data/economy/ledger \
  --report /tmp/export-report.json

# 2. validate and build a temporary ledger
go run ./cmd/migrate \
  --input /tmp/legacy-export.json \
  --dry-run \
  --report /tmp/migration-report.json

# If the export contains stale relations or unowned records, either clean them  up in the database or add:
#   --skip-orphans --fallback-user <existing user id>
# --skip-orphans only drops broken rows; it never invents an owner. The fallback user is assigned to assets/places/groups that have no creator or owner.

# 3. resolve reported errors, then create the real ledger
go run ./cmd/migrate \
  --input /tmp/legacy-export.json \
  --out ../data/economy/mydb.migrated.db \
  --report /tmp/migration-report.json

# 4. start against the migrated ledger for a staging check
./Economy -db ../data/economy/mydb.migrated.db -addr :2010
```

The Site client reads `ECONOMY_URL` and defaults to `http://localhost:2009`, so a staging Site can be pointed at the migrated service with:

```sh
ECONOMY_URL=http://localhost:2010 bun run dev
```

If using the Docker layout, the final ledger path is `/data/economy/mydb.db`; the container command already points there.

## Flags

- `--export PATH`: write a legacy snapshot and exit.
- `--input PATH`: migrate from an exported snapshot instead of querying SurrealDB.
- `--old-ledger PATH`: old JSONL ledger (default `../data/economy/ledger`).
- `--out PATH`: new bbolt ledger. Required unless using `--dry-run` or `--export`.
- `--report PATH`: JSON report (default `migration-report.json`).
- `--surreal URL`, `--namespace`, `--database`, `--surreal-user`, `--surreal-pass`: SurrealDB access.
- `--fallback-user ID`: owner for otherwise unresolved assets/places/groups. Must be an existing user.
- `--skip-orphans`: ignore creator/owner/package relations that point to missing records, and balances for missing users.
- `--dry-run`: build and verify a temporary ledger without writing the output.
- `--force`: replace an existing output ledger.
- `--batch-size N`: transfers per bbolt import batch (default 500).

## Known limits

- Old ledger records with non-empty `Returns` are rejected; they need manual handling.
- Fractional old currency is floored; the report includes dust.
- Every migrated user receives a fresh 12-hour stipend cooldown because balance mints are stipend-shaped.
- A child in more than one package is a hard error for now (the 2E decision). The report lists the conflicting packages.
- Empty packages are migrated as source ownership but are not sellable.
- A balance, creator, owner, or fallback user that does not exist in the `user` table is an error. With `--skip-orphans`, the affected balance or relation is dropped and reported; the fallback user is always required to exist.
- Snapshots are versioned. Re-export if the snapshot version is older than the command expects.
- The old ledger and old database relations are left untouched. Do not delete them until the migrated ledger has been verified.
