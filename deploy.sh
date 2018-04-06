#!/usr/bin/env bash
hexo clean
hexo g
hexo d

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "页面宽度调节"
git push luodifz@www.bbetterman.com:/data/gitLibrary/jisumanbu.git hexo


