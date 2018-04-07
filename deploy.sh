#!/usr/bin/env bash
hexo clean
hexo g
hexo d

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "怎样才能生活得更好-读奇特的一生"
git push https://github.com/jisumanbu/jisumanbu.github.io.git hexo


