#!/usr/bin/env bash
hexo clean
hexo g
hexo d

git add .
#DATE=`date +%Y-%m-%d.%T`
git commit -m "rebuild after remove _config.yml from repository"
git push https://github.com/jisumanbu/jisumanbu.github.io.git hexo


