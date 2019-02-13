#!/usr/bin/env bash
hexo clean
hexo g
hexo d

git add -A .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "年终总结之2018 - 目标驱动元年"
git push https://github.com/jisumanbu/jisumanbu.github.io.git hexo


