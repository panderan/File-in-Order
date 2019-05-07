## 照片、文件分类归档－File Classification

## 1. 背景

　　写这个图片 / 文件分类脚本的是因为本人有这个需求。电脑换过，手机也换过，相对应的就会在各个角落里遗留下各种各样的有用的，没有用，不知道有没有用的文件照片和不知道什么时候建立的临时备份，同时也会产生大量的重复文件。所以就花了几天时间整理了我所有的备份文件。

　　云相册和各种网盘是个不错的解决方法。尤其是云相册，可以自动在连接到WIFI的情况下把手机中的照片同步的云盘中。但是我依旧要自己分类存储在本地基于以下几点理由。首先是一些自己的照片或是文件并不想放到网络中，不确定网盘中的文件是否可以被搜索。其次则是我的网络速度比较慢。这个脚本开始本来只是想用于把照片按时间归类，但在随后编写的过程中把其他常用文件也包括了。

## 2. 程序简介

　　本程序使用Bash Shell脚本加上AWK脚本编写完成的。分类目录如下：
![](http://oj8tpbqx0.bkt.clouddn.com/17-1-15/27588251-file_1484478052242_139fb.jpg)

　　　$^{～～　图　1　～～}$

　　目录名以“数字_分类名”组成。01~09为照片图片类，目前只分了Camera、Screenshot、WeiXin和Otherpics这4类。10以后开始为各种类型文件，11为Word、12为PPT、13为PDF、14为音乐文件、15为压缩文件和16为文本文件。98存放手动分类的文件，99存放无法归类的文件。除98和99以外，每一个分类目录中都有一个或多个*.awk的脚本文件。\.script目录中存放一些公共方法。只需将待分类的文件全部放到与run-classify.sh同一级目录中，通过运行run-classify.sh脚本搭配不同的参数将本目录中的待分类文件进行分类，移动到所属的目录中去。

## 3. 归类目录简介

### 1. Camera

　　照片分类主要存放手机摄像头所拍摄的照片和相机所拍摄的照片，区别于网络图片或是其他来源。分类到该目录有以下两种方法：

#### **按名称分类：**

　　按这种分类的共同特点是有着相似结构的文件名，其中大部分类型的文件名中包含有拍摄日期信息。由于照片在转存复制的过程中可能会导致文件的目录项中记录创建时间并不是照片真实的拍摄时间，故文件名中记录的时间会更加准确。只有当文件名中没有时间信息时才使用文件创建时间作为照片的拍摄时间。该分类方法将会匹配以下正则表达，并提出时间信息，在Camera目录中以月为单位建立子目录存放当月所拍摄的照片，子目录名以“xxxx年xx月”命名。应用的正则表达式如下表所述。

| 序号   | 正则表达式(不区分大小写)                            | 举例                            | 时间获取   |
| ---- | ---------------------------------------- | ----------------------------- | ------ |
| 01   | ^IMG\_\\d{8}\_\\d{6}                     | IMG\_20160101\_123456         | 文件名    |
| 02   | ^IMG\\d{8}                               | IMG20131010                   | 文件名    |
| 03   | ^IMG\\w{5,10}                            | IMG0001A                      | 文件创建时间 |
| 04   | ^VID\_\\d{8}\_\\d{6}                     | VID\_20160101\_123456         | 文件名    |
| 05   | ^PANO\_\\d{8}\_\\d{6}                    | PANO\_20130101\_123456        | 文件名    |
| 06   | ^MYXJ\_\\d{8}\_\\d{6}                    | MYXJ\_20130101\_123456        | 文件名    |
| 07   | ^\\d{4}\-\\d{2}\-\\d{2}\_\\d\*           | 2013\-01\-01\_1234567890      | 文件名    |
| 08   | ^\\d{4}\_\\d{2}\_\\d{2}\_\\d{2}\_\\d{2}\_\\d{2} | 2013\_01\_01\_11\_11\_11      | 文件名    |
| 09   | ^\\d{8,10}.jpg                           | 20130101123.jpg               | 文件名    |
| 10   | ^MTXX\_\\d{14}.jpg                       | MTXX_20130101123456.JPG       | 文件名    |
| 11   | ^DSC\\d{5,10}.jpg                        | DSC01234.JPG                  | 文件创建时间 |
| 12   | ^wx\_camera\_\\d{13}.jpg                 | wx\_camera\_1234567898765.jpg | 文件创建时间 |
　　　$^{～～　表　1　～～}$
#### **按创建时间分类：**

　　由于各种相机手机所用的照片命名规则不尽相同，有些也可以自定义命名规则。因此就会导致表１中所列出的规则并不能匹配全部。所以作为补充，当遇到拥有一定命名规则且并不在表１所列规则中时就可以使用按照创建时间分类。在命令行应用该分类规则时，需要自己在命令行提供欲匹配正则表示式字符串作为参数。

### 2. Screenshots

　　屏幕截图作为目前智能手机最普遍的功能被广泛使用，因此屏幕截图就可以作为较为稳定的图片来源。一般来讲截图命名通常都图片名称都都带有“screenshot”字样。因此该目录下的awk脚本就以此为过滤。分类该类型时，处理过程有两个步骤。第一重命名，一般来说截图的图片名不具有特定的意义，所以在分类移动到02\_Screenshot目录前先将匹配的截图文件统一命名。时间以图片文件创建时间为来源，名称以正则表述为 “^screenshot\-\\d{4}\-\\d{2}.\\w{8,32}” 。 \\w{8,32}用于处理重复文件，稍后叙述。第二步是将改名后的文件移动到02\_Screenshot目录中。

### 3. WeiXin

　　微信作为普遍在手机端使用的及时聊天工具。照片分享也使用的十分普遍，其中不乏一些值得留念的照片。所以微信中的照片也算是一个稳定的照片来源。出于同样的方法，分类到03\_WeiXin的命令处理同样也有两个步骤，第一步改名，第二步是移动。用于筛选微信照片的正则表达式表述为 “^microMsg[a\-z0\-9A\-Z.\_\\-]\*.jp[e]?g” 、 “^mmexport[a\-z0\-9A\-Z.\_\-]\*.jp[e]?g\|^mmexport[a\-z0\-9A\-Z.\_\-]\*.gif” 和 “^wx_camera[a\-z0\-9A\-Z.\_\\-]\*.mp4” 。其所对应的统一命名格式的正则表述为 “^microMsg\-\\d{4}\-\\d{2}.\\w{8,32}.jp[e]?g” 、 “^mmexport\-\\d{4}\-\\d{2}.\\w{8,32}.jp[e]?g\|^mmexport\-\\d{4}\-\\d{2}.\\w{8,32}.gif” 和 “^wx_camera\-\\d{4}\-\\d{2}.\\w{8,32}.mp4”。

### 4. Otherpics

　　 该目录中用于存放无确定来源的图片。命令过程与Screenshot和WeiXin类似。其相应的正则规则详见该目录中的classify\-otherpics\-pic.awk文件。

### 5. 10\_Word~16\_Text

　　10~16用于分类不同的文件扩展名的文件，过滤规则主要依据文件的扩展名。由于源文件名可能是具有一定意义的，故改名的规则为“源文件名+后缀.扩展名”，其中后缀的正则表述为：“\\d{4}\-\\d{2}.\\w{8,32}” 。

### 6. 98_Manual

　　该目录中存放已经手动分类好的子目录。如某一次演讲素材，某一门课程的材料等。

## 4. 重复文件

　　关于重复文件的筛选比较是一个老生常谈的话题了。互联网上拥有众多的文件去重，相似图片查找的工具。因此这里没有必要做太多的工作。本脚本中文件重复比较采用MD5值比较的方法。

　　对于01\_Camera目录中，如果欲移动的文件在01\_Camera目录中已存在同名文件，则分别计算两个文件的MD5值，如果相同则执行覆盖操作。如果不同则以源文件名加上8位MD5组成的新文件名来移动欲分类的文件来保留两个文件。　对于其他分类，在第一次改名操作中如果当前目录中已存在名为新生成文件名的文件，则意味中这两个文件的MD5的前8位相同。此后再依次比较第9，第10位一直到32位。如果到某一个位MD5值不同了，则新文件文的MD5后缀就到该位为止。如果MD5值完全相同则返会同样的文件名（详见get\_newfilename函数位于\.script/funcs.sh）。之后执行mv操作进行覆盖。在第二部移动过程中，如果分类目录中以存在同名文件，则分别计算两个文件的MD5，如果相同则执行覆盖操作。如果不同，待移动的文件名再加MD5的前8位后缀使文件名不同从而同时保留两个文件。

　　在这里推荐两个文件比较工具：

- 图片去重比较 VisiPics - http://www.visipics.info/index.php?title=Main_Page
- 重复文件清理 Duplicate Cleaner Pro - http://pan.baidu.com/s/1jIFieDw（提取码：xz8c，已破解，来源于网络）

## 5. 命令行使用方法

　　帮助信息如下所示：
```
➜  FileClassification git:(master) ✗ ./run-classify.sh --help
用法: run-classify.sh [OPTION]...
分类该目录下的待分类的文件。

选项：
  -e            替换文件名中的特殊字符，将' '、'`'、'@'、'\'、'$'、'%'、'#'、
                '{'和'}'删除掉，将'('、')'、'['、']'、'+'、'&'、','替换为'_'。
  -p, --pic     分类图片类型文件，需指定参数'name'、'createdtime'、'screenshot'、
                'wechat'和'otherpic'其中的一个。
  -f, --file    分类其他类型文件，需指定参数'word'、'excel'、'pdf'、'music'、
                'text'、'compressionfile'和'ppt'其中的一个。
      --regstr  指定正则表达式，需与 --pic createdtime 一起使用。
      --test    只打印输出日志，而不实际执行命令。对于需要先改名再分类的文件则该
                选项只debug改名部分。
      --test2   只打印输出日志，而不实际执行命令。对于需要先改名再分类的文件则该
                选项只debug分类移动部分。
  -h, --help    显示帮助信息

➜  FileClassification git:(master) ✗
                                   
```
### 