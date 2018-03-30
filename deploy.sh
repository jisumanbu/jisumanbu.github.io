#!/usr/bin/env bash
hexo g
hexo d

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "SEO优化 - 添加蜘蛛协议robots.txt"
git push