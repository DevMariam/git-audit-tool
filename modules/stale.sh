#!/bin/bash
# modules/stale.sh - Flag branches untouched for 14+ days

# Define threshold in seconds (14 days = 14 * 24 * 60 * 60)
THRESHOLD_DAYS=14
THRESHOLD_SECS=$(( THRESHOLD_DAYS * 24 * 60 * 60 ))
CURRENT_TIME=$(date +%s)

echo "🔍 Scanning for local branches inactive for $THRESHOLD_DAYS+ days..."
echo "--------------------------------------------------------"

# Loop through all local branches
git for-each-ref --format='%(refname:short) %(committerdate:raw)' refs/heads/ | while read -r branch committer_time tz; do
    
    # Calculate age
    AGE_SECS=$(( CURRENT_TIME - committer_time ))
    AGE_DAYS=$(( AGE_SECS / 86400 ))
    
    # Get last commit details for context
    LAST_COMMIT_HASH=$(git log -1 --format="%h" "$branch")
    LAST_COMMIT_MSG=$(git log -1 --format="%s" "$branch")
    
    # Check if branch exceeds threshold
    if [ "$AGE_SECS" -ge "$THRESHOLD_SECS" ]; then
        echo "⚠️  STALE: [$branch] - Untouched for $AGE_DAYS days!"
        echo "   ↳ Last Commit: $LAST_COMMIT_HASH - \"$LAST_COMMIT_MSG\""
        echo ""
    else
        echo "✅ Active: [$branch] - Last commit $AGE_DAYS days ago."
    fi
done
echo "--------------------------------------------------------"
echo "💡 Audit complete. Consider deleting or archiving stale branche."
