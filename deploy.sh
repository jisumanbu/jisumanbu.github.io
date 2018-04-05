#!/usr/bin/env bash
hexo clean
hexo g
hexo d

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "怎样才能生活得更好-奇特的一生读书笔记"
git push luodifz@www.bbetterman.com:/data/gitLibrary/jisumanbu.git hexo


