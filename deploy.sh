#!/usr/bin/env bash
hexo g

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "先push到git，再deploy个人服务器"
git push --set-upstream jisumanbu.io hexo

hexo d

