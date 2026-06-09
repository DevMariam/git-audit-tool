#!/bin/bash
#audit.sh - git-audit-tool Entry point

#usage:
#   ./audit.sh - audit current directory
#   ./audit.sh /path/to/repo - audit a specific repo
#  ./audit.sh --help    - show usage


set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load config and all modules
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/modules/git.sh"
source "$SCRIPT_DIR/modules/stale.sh"
source "$SCRIPT_DIR/modules/merge.sh"
source "$SCRIPT_DIR/modules/health.sh"

#Usage

usage() {
    echo -e "${BOLD}git-audit-tool${RESET} - Repository Health Auditor"
    echo ""
    echo "Usage:"
    echo "  ./audit.sh [REPO_PATH]"
    echo ""
    echo "Options:"
    echo "  REPO_PATH   Path to the Git repository (defaults to current directory)"
    echo "  --help      Show this help message"
    echo ""
    echo "Output:"
    echo "  Terminal: color-coded summary"
    echo "  File:    $REPORTS_DIR/audit_report_$(date +%Y%m%d_%H%M%S).txt"


}


#Print header
print_header() {
    echo -e "${BOLD}${CYAN}"
    echo "========================================"
    echo "        GIT AUDIT TOOL - v1.0"
    echo "========================================"
    echo -e "${RESET}"
    echo -e "  ${INFO_SIGN} Target repo : ${BOLD}$REPO_PATH${RESET}"
    echo -e "  ${INFO_SIGN} Report file : ${BOLD}$REPORT_FILE${RESET}"
    echo -e "  ${INFO_SIGN} Report date : ${BOLD}$REPORT_DATE${RESET}"

}

#print footer
print_footer() {
    echo -e "\n${BOLD}${CYAN}========================================${RESET}"
    echo -e "  ${GREEN}${CHECK_MARK} Audit complete.${RESET}"
    echo -e "  Report saved to: ${BOLD}$REPORT_FILE${RESET}"
    echo -e "${BOLD}${CYAN}========================================${RESET}\n"
}


#run_audit <repo_path>
#runs all module checks and saves output to a report file
run_audit() {
    local repo_path="$1"
    {
        print_header
        echo ""
        echo "## 1. Git Repository Checks"
        run_git_checks "$repo_path"

        #echo ""
        #echo "## 2. Stale Branch Checks"
        #run_stale_checks "$repo_path"
        
        #echo ""
        #echo "## 3. Merge & Divergence Checks"
        #run_merge_checks "$repo_path"

        echo ""
        echo "## 4. Repository Health Checks"
        run_health_checks "$repo_path"

        print_footer

    } | tee "$REPORT_FILE"

    # Strip ANSI color codes from the saved report for better readability
    sed -i '' 's/\x1b\[[0-9;]*m//g' "$REPORT_FILE" 2>/dev/null || true
}
    #main

main() {
    #handles --help
    if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
        usage
        exit 0
    fi

    #target repo: first arg or current dir
    REPO_PATH="${1:-$(pwd)}"

    #Rsolve to absolute path
    REPO_PATH="$(cd "$REPO_PATH" 2>/dev/null && pwd)" || {
        echo -e "${RED}${FAIL} Path not found: ${1}${RESET}"
        exit 1
    }

    run_audit "$REPO_PATH"
}
main "$@"