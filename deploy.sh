#!/usr/bin/env bash
hexo clean
hexo g
hexo d

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "不显示全文，只显示预览"
git push luodifz@www.bbetterman.com:/data/gitLibrary/jisumanbu.git hexo


