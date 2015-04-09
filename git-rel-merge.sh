#!/bin/bash
# Script for git release.
# It works with this sequence:
#   $ git checkout master
#   $ git merge [BRANCH]

echo "# Merge Current Branch to Master. Authorized by Seorenn <hirenn@gmail.com>"
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

echo "# Trying merge current branch [$BRANCH] to [master]..."

git checkout master
if [ $? -ne 0 ]; then
    echo "# Failed to checkout master."
    exit -1
fi

git merge $BRANCH
if [ $? -ne 0 ]; then
    echo "# Failed to merge from branch [$BRANCH]."
    exit -1
fi

echo "# Finish merge."
echo "# GIT STATUS ON [master] ========================================================="
git status
