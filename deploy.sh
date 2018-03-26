#!/usr/bin/env bash
git add .
DATE=`date +%Y-%m-%d.%T`
git commit -m "$DATE"
git push jisumanbu.io hexo
hexo g
hexo d