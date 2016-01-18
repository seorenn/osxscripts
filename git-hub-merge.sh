#!/bin/bash
# Script for git merge to master(or selecting) branch
# git checkout BRANCH
# git merge WORKING_BRANCH
# git branch -D WORKING_BRANCH

function print_usage() {
    echo "$0 [-d] BRANCH_NAME(to merge)"
}

if [ $# -eq 0 ]; then
    print_usage
    exit -1
fi

BRANCH=`git status | head -n 1 | awk '{print $3}'`
if [ "$BRANCH" == "master" ]; then
    echo "Current branch is [master]. Please checkout another branch."
    exit 0
fi

ELIMINATE=0
while getopts "d" opt; do
    case $opt in
        d)
            ELIMINATE=1
            ;;
        ?)
            exit
            ;;
    esac
done

shift $((OPTIND-1))

TARGET=$@

echo ""
echo "-> Checkout branch $TARGET"
git checkout $TARGET
if [ $? -ne 0 ]; then
    echo "-> Failed to checkout branch $TARGET"
    exit -1
fi

echo ""
echo "-> Merge branch $BRANCH"
git merge $BRANCH
if [ $? -ne 0 ]; then
    echo "-> Failed to merge branch $TARGET"
    exit -1
fi

if [ $ELIMINATE -eq 1 ]; then
    echo ""
    echo "-> Delete bracnh $BRANCH"
    git branch -D $BRANCH
    if [ $? -ne 0 ]; then
        echo "-> Filed to remove branch $TARGET"
        exit -1
    fi
else
    echo ""
    echo "NOTE: Branch [$BRANCH] remaining in local repository."
    echo "      You can remove it by yourself if not needed."
    echo ""
fi
