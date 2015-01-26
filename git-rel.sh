#!/bin/bash
# Script for git release.
# It works with this sequence:
#   $ git rebase master
#   $ git checkout master
#   $ git merge BRANCH_NAME
echo "# Release Current Branch to Master with Single Commit. Authorized by Seorenn <hirenn@gmail.com>"
BRANCH=`git status | head -n 1 | awk '{print $3}'`
if [ "$BRANCH" == "master" ]; then
    echo "# Current branch is [master] already. Please check-out branch first."
    exit -1
fi

# Check Changes with Master.
DIFF=`git diff master --no-color | wc -l`
if [ $DIFF -eq 0 ]; then
    echo "# Current branch [$BRANCH] has no differences with Master branch. Skip operations."
    exit 0
fi

# Check Remote. And Update Master
REMOTE=`git remote -v | wc -l`
if [ $REMOTE -gt 0 ]; then
    echo "# This repository has remote. Updating [master] to recently..."
    git checkout master
    if [ $? -ne 0 ]; then
        echo "# Failed to checkout master."
        exit -1
    fi
    git pull
    if [ $? -ne 0 ]; then
        echo "# Failed to pull master from remote."
        exit -1
    fi

    echo "# Finish update [master]. Moving back to branch [$BRANCH]..."
    git checkout $BRANCH
fi

echo "# Checking update of current bracnh [$BRANCH]..."
UPDATES=`git log master..HEAD --oneline | wc -l`
if [ $UPDATES -eq 0 ]; then
    echo "# No changes. Quit."
    exit 0
fi

echo "# Trying rebase-merge current branch [$BRANCH] to [master]..."

git rebase master
if [ $? -ne 0 ]; then
    echo "# Failed to rebase master."
    exit -1
fi

git checkout master
if [ $? -ne 0 ]; then
    echo "# Failed to checkout master."
    exit -1
fi

if [ $UPDATES -eq 1 ]; then
    echo "# Found single commit. Using normal merge."
    git merge $BRANCH
    if [ $? -ne 0 ]; then
        echo "# Failed to merge from branch [$BRANCH]."
        exit -1
    fi
    echo "# Finish merge."
    echo "# GIT STATUS ON [master] ========================================================="
    git status
elif [ $UPDATES -gt 1 ]; then
    echo "# Found $UPDATES commits. Using squash merge."
    git merge $BRANCH --squash
    if [ $? -ne 0 ]; then
        echo "# Failed to merge from branch [$BRANCH]."
        exit -1
    fi
    echo "# Finish merge."
    echo "# Current branch is [master]. And changes are not commited yet."
    echo "# You can commit and push by manually."
    echo "# GIT STATUS ON [master] ========================================================="
    git status
fi

