#!/usr/bin/env bash
hexo clean
hexo g
hexo d

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "add 阅读次数"
git push luodifz@www.bbetterman.com:/data/gitLibrary/jisumanbu.git hexo


