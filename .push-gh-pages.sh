#!/bin/bash

# automatically exit on error
set -e

# copy _site/ from master branch over to gh-pages and push to github
git checkout master
COMMIT=`git rev-parse HEAD`
git checkout gh-pages
# since _site/ is in .gitignore, it should be copied over automatically
rm .Rhistory || true
cp -r _site/* .
rm -rf _site/
git add *
git commit -m "_site/ folder pertaining to commit: ${COMMIT}"
git push origin gh-pages
git checkout master
