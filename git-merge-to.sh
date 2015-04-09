#!/bin/bash

WITHPUSH=0
TARGETBRANCH="master"

function printusage() {
/bin/cat << EOF
USAGE: $0 [OPTIONS] BRANCH_NAME
OPTIONS:
    -p: with Push
    -c: with Commit
EOF
}

if [ $# -eq 0 ]; then
    printusage
    exit -1
fi

WITHPUSH=0
CURBRANCH=`git status | head -n 1 | awk '{print $3}'`
TARGETBRANCH=""

while getopts "p" opt; do
    case $opt in
        p)
            WITHPUSH=1
            ;;
        ?)
        exit
        ;;
    esac
done

shift $((OPTIND-1))
TARGETBRANCH=$@

echo "# Checking out $TARGETBRANCH"
git checkout $TARGETBRANCH
if [ $? -ne 0 ]; then
    echo "# Failed to checkout $TARGETBRANCH."
    exit -1
fi

echo "# Merging $CURBRANCH"
git merge $CURBRANCH
if [ $? -ne 0 ]; then
    echo "# Failed to merge $CURBRANCH."
    exit -1
fi

if [ $WITHPUSH -eq 1 ]; then
    echo "# Pushing current branch $TARGETBRANCH"
    git push origin $TARGETBRANCH
    if [ $? -ne 0 ]; then
        echo "# Failed to push..."
        exit -1
    fi
fi

echo "# Finish."
git checkout $CURBRANCH
