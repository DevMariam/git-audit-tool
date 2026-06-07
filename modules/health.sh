#!/bin/bash

# ==============================================================================
# Script Name: health.sh
# Description: Modular Repository Storage and Object Health Check
# ==============================================================================

run_health_checks() {
    local target_repo="${1:-$(pwd)}"
    
    if ! cd "$target_repo" 2>/dev/null; then
        echo -e "\033[0;31m[ERROR]\033[0m Target path not found: $target_repo"
        return 1
    fi

    echo "----------------------------------------"
    echo "  Repository Disk & Object Health Check:"
    echo "----------------------------------------"

    # 1. Calculate Total Git Repository Size
    if [ -d ".git" ]; then
        local repo_size
        repo_size=$(du -sh .git | cut -f1)
        echo -e "  ${INFO_SIGN} Total Git Database Size (.git): \033[1m$repo_size\033[0m"
    fi

    # 2. Check for Untracked Files (Potential Garbage/Secret leaks)
    local untracked_count
    untracked_count=$(git status --porcelain | grep -c "^??" || true)
    
    if [ "$untracked_count" -gt 0 ]; then
        echo -e "  ${WARNING_SIGN} \033[0;33mWARN:\033[0m Found $untracked_count untracked file(s) in workspace."
    else
        echo -e "  ${CHECK_MARK} \033[0;32mCLEAN:\033[0m No loose untracked garbage files detected."
    fi

    # 3. Check for Large Files (DevOps rule: Prevent files > 50MB from entering git history)
    echo -e "  ${INFO_SIGN} Scanning for files exceeding 50MB..."
    local large_files
    large_files=$(find . -type f -not -path '*/.*' -size +50M || true)

    if [ -n "$large_files" ]; then
        echo -e "  ${FAILED_SIGN} \033[0;31mCRITICAL:\033[0m Large files detected that could break pushing to GitHub:"
        echo "$large_files" | sed 's/^/    - /'
    else
        echo -e "  ${CHECK_MARK} \033[0;32mPASS:\033[0m Storage audit passed. No oversized files found."
    fi
}
