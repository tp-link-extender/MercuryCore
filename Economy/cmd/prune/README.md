# Prune legacy assets

`cmd/prune` removes unwanted assets from the new Economy ledger and the Site database in one operation. By default it removes:

- all packages (`type 32`) and everything inside them, including retained asset types
- all hats (`8`), faces (`18`), and gear (`19`)
- image assets that become orphaned by those removals
- the matching asset files and thumbnails

The active ledger is normally `Economy/mydb.db` when the Site starts the Economy service from the `Economy/` directory. The old JSONL archive at `data/economy/ledger` is not touched.

## Safety

Stop the Site and the Economy service first. The command opens the ledger with bbolt's exclusive lock, so it waits 10 seconds for the Economy service to release it before failing.

If the Site starts SurrealDB (`Database.AutoStart`), stopping the Site also stops it. Start SurrealDB manually for the command, or leave a separately managed instance running. SurrealDB must be running; the Site and Economy service must not be.

The cleanup transaction can take longer than the SDK's 10 second default on a large database. The command defaults to a 5 minute request timeout; raise `--surreal-timeout` (for example `15m`) if it still times out, or use `0` to disable the per-request timeout.

Back up:

- `Economy/mydb.db`
- `data/surreal`
- `data/assets`
- `data/thumbnails`

The command refuses to overwrite an existing output ledger unless `--force` is passed. `--out` must be a different file from `--db`; the current ledger is never edited in place.

## Ledger behaviour

The new ledger is append-only, so pruning writes a fresh ledger from the current state:

- currency balances, places, groups, retained sources, and retained item ownership are preserved
- every package source, package item, and package child is dropped
- removed asset sources and items are dropped
- package-source-held currency is burned
- transfer history is reset
- every retained user gets a fresh 12-hour stipend cooldown

The new ledger is reopened and verified before the database is touched.

## Site behaviour

The command runs one SurrealDB transaction that:

- deletes `createdComment`, `commentLink`, likes/dislikes, and comments for removed assets
- deletes `likes`, `dislikes`, `wearing`, and `recentlyWorn` rows for removed assets
- deletes `imageAsset` relations for removed and orphaned image assets
- deletes notifications and render rows for removed assets/comments
- deletes old `created` and `ownsAsset` rows for removed assets
- deletes all `packageItem` rows if the table still exists
- deletes the `asset` rows

Audit logs, reports, and moderation history are left alone. After the transaction commits, `data/assets/<id>` and `data/thumbnails/<id>` are removed for every removed asset and orphaned image.

## Usage

From `Economy/`:

```sh
# 1. dry run: build and verify a temporary ledger, report database/file changes
go run ./cmd/prune \
  --db mydb.db \
  --dry-run \
  --drop-orphans \
  --report prune-report.json

# 2. apply to a new ledger and clean the database
go run ./cmd/prune \
  --db mydb.db \
  --out mydb.pruned.db \
  --drop-orphans \
  --report prune-report.json

# 3. stop the Economy service, swap the ledger, rebuild, and start the Site
mv mydb.db mydb.db.pre-prune
mv mydb.pruned.db mydb.db
```

`--drop-orphans` drops ledger items whose asset no longer exists in SurrealDB. Without it, those items abort the prune so they can be reviewed.

## Flags

- `--db PATH`: current ledger (default `mydb.db`).
- `--out PATH`: pruned ledger. Required unless `--dry-run` or `--skip-ledger`.
- `--report PATH`: JSON report (default `prune-report.json`).
- `--remove-types LIST`: comma-separated asset types to remove. Packages are always removed. Default `8,18,19,32`.
- `--surreal URL`, `--namespace`, `--database`, `--surreal-user`, `--surreal-pass`: SurrealDB access.
- `--surreal-timeout DURATION`: per-request SurrealDB timeout (default `5m`; `0` disables it). The cleanup runs as one transaction, so a large database can need several minutes.
- `--assets-dir PATH`, `--thumbnails-dir PATH`: file locations (defaults `../data/assets`, `../data/thumbnails`).
- `--dry-run`: build a temporary ledger and report database/file changes without applying them.
- `--force`: overwrite an existing output ledger.
- `--skip-ledger`: skip the ledger build and only clean the database/files.
- `--skip-site`: skip the database transaction and file deletion; only build the ledger.
- `--skip-files`: clean the database but keep asset files.
- `--drop-orphans`: drop ledger items that have no matching asset in SurrealDB.
- `--keep-orphan-images`: do not delete image assets that are only linked to removed assets.
- `--batch-size N`: transfers per ledger import batch (default 500).

`--skip-site` implies `--skip-files`. `--skip-ledger` and `--skip-site` cannot be used together.

## Notes

- The database transaction is committed before files are deleted. If a file cannot be removed, the report lists it and the command exits non-zero; the database and ledger are already clean.
- If the SurrealDB transaction fails, it rolls back and the pruned ledger file remains available for inspection.
- The report includes removed asset IDs/types/names, package children, orphan images, ledger counts, database row counts, and file results.
