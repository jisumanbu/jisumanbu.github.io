#!/usr/bin/env bash
hexo g

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "Enable baidu push"
git push --set-upstream jisumanbu.io hexo

hexo d

