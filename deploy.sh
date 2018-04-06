#!/usr/bin/env bash
hexo clean
hexo g
hexo d

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "remove hexo-symbols-count-time"
git push luodifz@www.bbetterman.com:/data/gitLibrary/jisumanbu.git hexo


