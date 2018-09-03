#!/usr/bin/evn python3
#coding=utf-8
import os
import sys

def parseArgument():
    for i in range(0,len(sys.argv)):
         print(sys.argv[i])
         argu = sys.argv[i]
    return argu

if __name__ == '__main__':
    argu = parseArgument()
    os.system('git add -A') #所有变化提交到暂存区
    # os.system('git stash') #保存当前工作进度，会把暂存区和工作区的改动保存起来。-但没有提交到本地仓库
   
    os.system('git fetch origin master')#//从远程的origin的master主分支上获取最新版本到origin/master分支上
    # os.system('git log -p master..origin/master') #//比较本地的master分支和origin/master分支的区别
    os.system('git merge origin/master')

    # os.system('git pull --rebase')
    # os.system('git pull')#//相当于进行了 git fetch 和 git merge两部操作

    os.system('git commit -m ' + '\"' + argu + '\"')#提交到本地仓库
    os.system('git push origin master') 














