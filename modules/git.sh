#!/bin/bash

# ==============================================================================
# Script Name: git.sh
# Description: Modular Git Repository Checks for git-audit-tool
# ==============================================================================

run_git_checks() {
    # Accept the repository path passed by the main orchestrator (defaults to current directory)
    local target_repo="${1:-$(pwd)}"
    
    # DevOps Best Practice: Safeguard execution by jumping into the target directory safely
    # If the directory doesn't exist, we exit gracefully instead of crashing the whole pipeline
    if ! cd "$target_repo" 2>/dev/null; then
        echo -e "\033[0;31m[ERROR]\033[0m Target path not found: $target_repo"
        return 1
    fi

    # 1. Show current branch and working tree status
    echo "----------------------------------------"
    echo "  Current Branch & Working Status:"
    echo "----------------------------------------"
    git status -s

    # 2. Print git log graph of recent history
    echo -e "\n----------------------------------------"
    echo "  Recent Git History Graph:"
    echo "----------------------------------------"
    git log --oneline --graph -n 10

    # 3. Flag branches untouched in 14+ days (stale)
    echo -e "\n----------------------------------------"
    echo "  Stale Local Branches (14+ Days Active Threshold):"
    echo "----------------------------------------"
    local current_time
    current_time=$(date +%s)

    git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)|%(committerdate:raw)' | while read -r line; do
        local branch_name raw_date relative_date age_seconds age_days
        branch_name=$(echo "$line" | cut -d'|' -f1)
        raw_date=$(echo "$line" | cut -d'|' -f2 | cut -d' ' -f1)
        relative_date=$(git log -1 --format="%cr" "$branch_name")
        
        # Calculate time difference in days
        age_seconds=$((current_time - raw_date))
        age_days=$((age_seconds / 86400))
        
        if [ "$age_days" -ge 14 ]; then
            echo -e "  \033[0;33m[WARN]\033[0m STALE: $branch_name ($relative_date)"
        else
            echo "         ACTIVE: $branch_name ($relative_date)"
        fi
    done
}
