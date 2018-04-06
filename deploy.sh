#!/usr/bin/env bash
hexo clean
hexo g
hexo d

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "添加百度统计"
git push luodifz@www.bbetterman.com:/data/gitLibrary/jisumanbu.git hexo


