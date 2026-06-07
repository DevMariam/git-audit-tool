# git-audit-tool

A modular Bash tool that audits the health of any Git repository and saves a dated report.

---

## Project Structure

```
git-audit-tool/
├── audit.sh          # Main entry point — run this
├── config.sh         # Global settings (thresholds, colours, paths)
├── modules/
│   ├── git.sh        # Core repo validation & working tree status
│   ├── stale.sh      # Stale branch detection (local + remote)
│   ├── merge.sh      # Unmerged & diverged branch detection
│   └── health.sh     # Repo hygiene (.gitignore, large files, remote, history)
├── reports/
│   └── audit-YYYY-MM-DD.txt   # Auto-generated on each run
└── README.md
```

---

## Usage

```bash
# Make the script executable (first time only)
chmod +x audit.sh

# Audit the current directory
./audit.sh

# Audit a specific repo
./audit.sh /path/to/your/repo

# Show help
./audit.sh --help
```

---

## What It Checks

| Module | Checks |
|---|---|
| `git.sh` | Is it a git repo? Current branch, remote URL, last commit, working tree dirty? |
| `stale.sh` | Local + remote branches with no activity in >30 days |
| `merge.sh` | Branches not merged into `main`; branches ahead/behind remote |
| `health.sh` | Missing `.gitignore`, files >1MB, remote reachability, commit count, branch count |

---

## Configuration

Edit `config.sh` to customise behaviour:

| Variable | Default | Description |
|---|---|---|
| `STALE_DAYS` | `30` | Days of inactivity before a branch is flagged as stale |
| `BASE_BRANCH` | `main` | Branch to compare against for merge checks |
| `LOG_DEPTH` | `10` | Number of recent commits to inspect |
| `REPORTS_DIR` | `./reports` | Where audit reports are saved |

---

## Output

Each run prints a colour-coded summary to the terminal **and** saves a clean plain-text report to:

```
reports/audit-YYYY-MM-DD.txt
```

---

## Requirements

- Bash 4+
- Git installed and on `$PATH`

---

## Authors

devmariam — built as a real-world Bash scripting project.
Damirex25 -
Shup01 -