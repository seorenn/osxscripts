#!/bin/bash
# Script for git release.
# It works with this sequence:
#   $ git rebase master
#   $ git checkout master
#   $ git merge BRANCH_NAME
echo "Release Current Branch to Master via Git. Authorized by Seorenn <hirenn@gmail.com>"
BRANCH=`git status | head -n 1 | awk '{print $3}'`
if [ "$BRANCH" == "master" ]; then
    echo "Current branch is already master. Please check-out branch to release."
    exit -1
fi

echo "Trying Rebase-Merge Current Branch [$BRANCH] to Master..."

git rebase master
if [ "$?" != "0" ]; then
    echo "Failed to rebase master."
    exit -1
fi

git checkout master
if [ "$?" != "0" ]; then
    echo "Failed to checkout master."
    exit -1
fi

git merge $BRANCH
if [ "$?" != "0" ]; then
    echo "Failed to merge from branch [$BRANCH]."
    exit -1
fi

echo "Finish. Good Luck. :-)"
echo "Current branch is master. You can push or checkout another branch."
