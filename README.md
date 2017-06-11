## 爱思想网

自从共识网被关闭之后，爱思想网是为数不多的供学者向公众发布学术成果和进行公共发言的网站。以防失联，做全站文章备份。

截止到 2017 年 1 月 20 日的全部数据下载地址 https://pan.baidu.com/s/1i4AkVOD （7Zip等软件可解压，解压后约 2.2G，99530篇）

此外，爱思想网会将被和谐的文章标题等信息保留，可以借此研究哪些文章容易被和谐。

aisixiang_2017-01-20_com.csv 文件 availablity 字段， 0 为受限文章（被和谐）。

## 获取文章列表

爱思想网提供了所有文章的 [点击排行](http://www.aisixiang.com/toplist/index.php?id=1&period=all)，根据此排行榜，获取文章列表。运行 00.get_metadata.R 即可。

00.get_metadata.R 中的 `Get_catalog()` 函数默认参数为'7'，表示获取一周排行，'30'表示获取一月排行，'1'表示每日排行，'all'表示所有排行。

可以部署在腾讯云或者阿里云，利用 `crontab -e`设置定期运行，如将 `Get_catalog()` 参数设置为 'all' 并保存为新文件 00.get_metadata_all.R，每月 1号、10号、20号的凌晨五点运行：

```
0 5 1,10,20 * * cd aisixiang/ && R CMD BATCH 00.get_metadata_all.R 
```

这里已经获取到 2017 年 1 月 20 日和 5 月 24 日的文章列表，保存为 aisixiang_2017-01-20.csv 和 aisixiang_2017-05-24.csv。

## 获取非会员文章

将上一步骤获取的文章列表保存，并修改 `02.download_1.py` 文件中 `D0 = pandas.read_csv("all_aisixiang_2017-05-24.csv")`
运行 `python3 02.download_1.py`，这个过程可能会持续数天，最好部署在腾讯云或者阿里云，运行

`nohup python3 02.download_1.py`

## 获取会员文章

获取会员文章的相关代码在 `login` 文件夹中。首先需要去 [爱思想网](http://www.aisixiang.com/) 注册和登录，然后导出 cookies 文件，Firefox 浏览器可以使用 [Export Cookies](https://addons.mozilla.org/en-US/firefox/addon/export-cookies/) 扩展，不过要在导出后的文件首行加入 `# Netscape HTTP Cookie File`，否则 Python 无法识别。`D_login_20170524.csv` 文件是该日文章列表中的会员可见文章，由于文章在不停增删，需要加上日期戳。

运行 `python3 02.download_0.py` 即可得到会员文章。

全部会员文章和非会员文章地址为 [百度云http://pan.baidu.com/s/1dFy5bXJ](http://pan.baidu.com/s/1dFy5bXJ)