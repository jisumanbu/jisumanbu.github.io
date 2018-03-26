#!/usr/bin/env bash
DATE=`date +%Y-%m-%d.%T`
git commit -m "$DATE"
hexo g
hexo d