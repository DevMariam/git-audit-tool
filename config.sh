#!/bin/bash
#config.sh - central configuration for git-audit-tool
# All global settings live here. Source this file in any other scripts.
# Source  "$(dirname "$0")/config.sh"

#project root
TOOL_DIR="$TOOL_DIR/reports"
REPORT_DATE=$(date +"%Y-%m-%d")
REPORT_FILE="$REPORTS_DIR/audit-$REPORT_DATE.txt"

#stale branch threshold
# branch with no commits in the last 30 days is considered stale
STALE_DAYS=30

# unmerged branch base
#the branch to compare against when checking unmerged branches
BASE_BRANCH="main"

#log depth
# how many recent commits to inspect per branch
LOG_DEPTH=10

# colors (for terminal output)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

#Symbols
CHECK_MARK="\xE2\x9C\x94"
WARNING_SIGN="\xE2\x9A\xA0"
FAILED_SIGN="\xE2\x9D\x8C"
INFO_SIGN="\xE2\x84\xB9"


# Ensure the reports directory exists
mkdir -p "$REPORTS_DIR"