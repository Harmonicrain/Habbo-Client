# Tools

The old one-off PHP/Python scripts have been consolidated into a TypeScript CLI.
Install dependencies once, then use `npm run tool -- <command>` from the repository root.

```bash
npm install
npm run tool -- --help
```

## Common Commands

```bash
npm run build:swf
npm run tool -- assets report
npm run tool -- gamedata migrate --gamedata C:\habbo\client\habbo-swfs\gamedata
npm run tool -- packets report --format json --out packets.json
```

## Destructive Commands

Source cleanup commands are dry-run by default. Add `--apply` only after reviewing the planned output.

```bash
npm run tool -- assets normalize
npm run tool -- assets normalize --apply
npm run tool -- symbols compare functions --reference air --out analyse.txt
```

## Command Map

| New command | Replaces | Notes |
| --- | --- | --- |
| `build` | `compile.js`, `compile.php` | Uses `asconfig.json`, `FLEX_HOME`, `JAVA_HOME`, and archives builds in `bin/`. |
| `gamedata migrate` | `migrate_gamedata_to_json.py` | Keeps round-trip verification and strict duplicate handling. |
| `imports generate` | `getImport.php` | Uses package declarations rather than Windows-only path splitting. |
| `assets report` | Manual asset checks | Shows missing embed sources and wrapper/source mismatches. |
| `assets normalize` | `renameImages.php`, `renameBinary.php` | Dry-run first; renames `_Str_` asset files from `Class` assignments. |
| `assets rename-wrappers` | `renameAs3.php` | Dry-run first; safely renames wrapper classes/files. |
| `symbols compare` | `renameFunction.php`, `renameVar.php` | Generic reference-tree comparison instead of hard-coded classes. |
| `packets report` | `searthAs3.php` | Exports incoming/outgoing packet id maps. |
| `swf extract-assets` | `extract.py`, `extract2.py` | Extracts image tags from SWF data with optional CID/name filters. |