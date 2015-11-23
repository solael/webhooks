#!/bin/bash
set -e
set -x
# This script is meant to be run automatically
# as part of the jekyll-hook application.
# https://github.com/developmentseed/jekyll-hook

repo=$1
branch=$2
owner=$3
giturl=$4
source=$5
build=$6

# Check to see if repo exists. If not, git clone it
#mv $source ${source}.bak
if [ ! -d $source ]; then
    git clone $giturl $source
fi

# Git checkout appropriate branch, pull latest code
cd $source
git checkout $branch

# Pull the images from images lfs if needed and available
# If the images are not displayed correctly, git-lfs might not be installed here
hash "git-lfs" 2> /dev/null
LFSTEST=$?
if [[ $LFSTEST -eq 0 ]]; then
    git lfs pull
fi

git pull origin $branch

cd -

# Run jekyll
cd $source
jekyll build -s $source -d $build
cd -
