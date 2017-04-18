#!/bin/bash

git branch -D gh-pages  # delete old branch -- no reason to version control gh-pages
git push origin :gh-pages

cd /tmp/
git clone ~/git/reproduce-ma17jnci

cd /tmp/reproduce-ma17jnci/
git checkout --orphan gh-pages  # create new
git rm -rf .

cp ~/git/reproduce-ma17jnci/reports/reproduce-ma17jnci.html ./index.html

git add index.html
git commit -m "Update gh-page"
git push origin gh-pages

cd ..
rm -fR reproduce-ma17jnci

cd ~/git/reproduce-ma17jnci

git push origin gh-pages
