#!/usr/bin/env bash
hexo g
hexo d

git add .
DATE=`date +%Y-%m-%d.%T`
git commit -m "$DATE"
git push