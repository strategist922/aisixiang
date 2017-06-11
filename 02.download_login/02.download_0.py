#!/usr/bin/python3

import os
from urllib.request import urlopen
from bs4 import BeautifulSoup
import pandas
import time
import http.cookiejar
import urllib

cookie = http.cookiejar.MozillaCookieJar()
cookie.load('cookies.txt', ignore_discard=True, ignore_expires=True)  # 从文件中读取cookie内容到变量

D0 = pandas.read_csv("D_login_20170524.csv")

# 意外中断时，可以修改 j 的值
j = 0
D = D0[j:]

for i in D['ID']:
    Url = "http://www.aisixiang.com/data/" + str(i) + ".html"
    try:
        req=urllib.request.Request(Url)
        handler=urllib.request.HTTPCookieProcessor(cookie)
        opener=urllib.request.build_opener(handler)
        html=opener.open(req).read().decode('gbk')

    except:
        f1 = open("broken-new.txt", 'a')
        Broken = str(i) + '-' + Url + ',' + '\n'
        f1.write(Broken)
        f1.close
        j += 1

        Availability = 3

        f2 = open("Av.txt", 'a')
        f2.write(str(Availability) + '_' + str(i) + ',' + '\n')
        f2.close

    else:
        Soup = BeautifulSoup(html, "html.parser")
        Article = Soup.find(id = "content2")
        Article_page = ''

        if type(Article) == type(None):
            Availability = 0
        else:
            Availability = 1
            Page = Soup.find(class_ = "list_page")

            if type(Page) == type(None):
                Article_page = Article_page + Article.get_text()
            else:
                Page_number = Page.find_all("a")
                N = int(Page_number[-2].get_text())
                for k in range(1, N+1):
                    Url2 = Url[:(len(Url)-5)] + '-' + str(k) + '.html'
                    print(Url2)
                    try:
                        req=urllib.request.Request(Url2)
                        print(req)
                        handler=urllib.request.HTTPCookieProcessor(cookie)
                        opener=urllib.request.build_opener(handler)
                        html2=opener.open(req).read().decode('gbk')
                    except:
                        k += 1
                        ft2 = open("broken2.txt", 'a')
                        Broken2 = str(i) + '-' + Url2 + ',' + '\n'
                        ft2.write(Broken2)
                        ft2.close
                        #print(Broken2)
                    else:
                        Soup2 = BeautifulSoup(html2, "html.parser")
                        Article = Soup2.find(id = "content2")
                        Article_page = Article_page + Article.get_text()
                        time.sleep(1)
        Name = str(Availability) + '-' + str(i) + '-' + str(D0.iloc[j,1]) + '.txt'
        Name = Name.replace('/','')
        f = open(Name, 'w')
        f.write(Article_page)
        f.close()
        j += 1
        time.sleep(1)

        f2 = open("Av.txt", 'a')
        f2.write(str(Availability) + '_' + str(i) + ',' + '\n')
        f2.close
