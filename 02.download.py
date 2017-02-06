#!/usr/bin/python3

import os
from urllib.request import urlopen
from bs4 import BeautifulSoup
import pandas
import time


D0 = pandas.read_csv("aisixiang_2017-01-20.csv")

# 意外中断时，可以修改 j 的值
j = 0

D = D0[j:]
print(D.columns)
print(D['Title_url'])

for i in D['Title_url']:
    Url = "http://www.aisixiang.com" + i
    print(Url)
    try:
        html = urlopen(Url)
    except:
        f1 = open("broken-new.txt", 'a')
        Broken = str(j) + '-' + Url + ',' + '\n'
        f1.write(Broken)
        f1.close
        print(Broken)
        j += 1

        global Availability
        Availability = 3

        f2 = open("Av.txt", 'a')
        f2.write(str(Availability) + '_' + str(j) + ',' + '\n')
        f2.close

    else:
        Soup = BeautifulSoup(html, "html.parser")
        Article = Soup.find(id = "content2")

        Article_page = ''

        Availability = 3

        if type(Article) == type(None):
            global Availability
            Availability = 0
        else:
            global Availability
            Availability = 1
            Page = Soup.find(class_ = "list_page")

            if type(Page) == type(None):
                Article_page = Article_page + Article.get_text()
            else:
                Page_number = Page.find_all("a")
                N = int(Page_number[-2].get_text())
                for i in range(1, N+1):
                    Url2 = Url[:(len(Url)-5)] + '-' + str(i) + '.html'
                    print(Url2)
                    try:
                        html2 = urlopen(Url2)
                    except:
                        i += 1
                        ft2 = open("broken2.txt", 'a')
                        Broken2 = str(j + 1) + '-' + Url2 + ',' + '\n'
                        ft2.write(Broken2)
                        ft2.close
                        print(Broken2)
                    else:
                        Soup2 = BeautifulSoup(html2, "html.parser")
                        Article = Soup2.find(id = "content2")
                        Article_page = Article_page + Article.get_text()
                        time.sleep(1)
        Name = str(Availability) + '-' + str(j+1) + '-' + D0.iloc[j,0] + '.txt'
        f = open(Name, 'w')
        f.write(Article_page)
        f.close()
        print(Name + '\n')
        j += 1
        time.sleep(1)

        f2 = open("Av.txt", 'a')
        f2.write(str(Availability) + '_' + str(j) + ',' + '\n')
        f2.close
