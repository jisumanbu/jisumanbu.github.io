#!/usr/bin/env bash
hexo clean
hexo g
hexo d

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "MongoDB从选型到落地到性能调优"
git push https://github.com/jisumanbu/jisumanbu.github.io.git hexo


