#!/bin/bash
# modules/merge.sh - Safely merge or rebase branches

set -e

# 1. Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "❌ Error: Your working tree is dirty. Commit or stash changes first."
    exit 1
fi

TARGET_BRANCH="${1:-main}"
CURRENT_BRANCH=$(git branch --show-current)

echo "🔄 Current branch: $CURRENT_BRANCH"
echo "🎯 Target branch:  $TARGET_BRANCH"

# Prevent merging a branch into itself
if [ "$CURRENT_BRANCH" == "$TARGET_BRANCH" ]; then
    echo "❌ Error: You are already on '$TARGET_BRANCH'."
    exit 1
fi

# 2. Sync target branch with remote
echo "📥 Fetching latest changes and updating $TARGET_BRANCH..."
git fetch origin
git checkout "$TARGET_BRANCH"
git pull origin "$TARGET_BRANCH"

# 3. Perform the merge/rebase choice
echo "❓ Choose integration method for $CURRENT_BRANCH into $TARGET_BRANCH:"
select method in "Standard Merge" "Rebase" "Abort"; do
    case $method in
        "Standard Merge")
            echo "🚀 Merging $CURRENT_BRANCH into $TARGET_BRANCH..."
            git merge "$CURRENT_BRANCH" --no-ff
            break
            ;;
        "Rebase")
            echo "🚀 Rebasing $CURRENT_BRANCH onto $TARGET_BRANCH..."
            git checkout "$CURRENT_BRANCH"
            git rebase "$TARGET_BRANCH"
            echo "✅ Rebase complete. Switch back to $TARGET_BRANCH to fast-forward merge if needed."
            break
            ;;
        "Abort")
            echo "🛑 Integration canceled."
            git checkout "$CURRENT_BRANCH"
            exit 0
            ;;
    esac
done

echo "✅ Integration process finished successfully."

