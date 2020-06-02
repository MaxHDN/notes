# 一、Markdown简介

> Markdown是一种轻量级标记语言，可以在文本编辑器编写文档。

> 编写的文档可以导出HTML、Word、图像、PDF、等多种格式的文档。

> Markdown编写后的文档后缀为.md、.markdown。

### markdown的应用

> 当前很多文档使用markdown来编写帮助文档，例如：GitHub

### 书籍推荐

> 《了不起的Markdown》

### 测试实例

markdown编写HelloWorld语法

\#Helloworld

# 二、标题

Markdown标题有两种格式。

### 1、使用 = 和 - 标记一级和二级标题

在一级标题下面打一行等于号

在二级标题下面大一行减号

### 2、使用 # 标记

使用 # 可表示1-6级标题，一级标题对应一个#号，二级对应2个，依次类推

# 三、段落

Markdown段落没有特殊的格式，段落换行是使用两个以上的空格加回车

当然也可以在段落后面使用一个空行来表示重新开始一个段落

### 1、字体

> Markdown可以使用以下几种字体：

> *斜体文本* ： 斜体文本在两个 * 号中间 。

> *斜体文本* ：在斜体文本在两个 _ 下划线中间

> **粗体文本** ：粗体文本在两个“**”中间

> **粗体文本**: 粗体文本在两个“__”中间

> ***粗斜体文本*** ： 粗体文本在三个“***”中间

> ***粗斜体文本*** : 粗体文本在三个 “___”中间

### 2、分隔线

可以在一行中用三个以上的 * 星号 或 - 减号 或 _下划线建立一个分割线,行内不能有其他东西。也可以在星号或者减号中插入空格。

### 3、删除线

段落中的文字如果要添加删除线，只要在文字的两端分别加上两个~~波浪线

例如：~~删除线~~

### 4、下划线

下划线可以通过HTML的标签来实现

例如：下划线

### 5、脚注

脚注对文本的补充说明。脚注的格式：

[^要注明的脚注]

创建类似这样的脚注[^Markdown](https://github.com/MaxHDN/learningNotes/blob/master/docs/markdown/一种轻量级标记语言)

# 四、列表

Markdown支持无序列表和有序列表。

### 1、无序列表

无序列表使用星号（*）、加号（+）、或者是减号（-）作为列表标记：

如：

- 第一项
- 第二项
- 第三项

- 第1项
- 第2项
- 第3项

- 第一项
- 第二项
- 第三项

### 2、有序列表

有序列表使用数字并加上点号“.”来表示，如：

1. 第一项
2. 第二项
3. 第三项

### 3、列表嵌套

列表嵌套只需要在子列表中的选项添加四个空格即可：

1. 第一项
   - 第一项嵌套的第一个元素
   - 第一项嵌套的第二个元素
2. 第二项
   - 第二项嵌套的第一个元素
   - 第二项嵌套的第二个元素

# 五、区块

### 1、普通嵌套的区块

markdown区块引用是在段落开头使用>符号，然后后面紧跟着一个空格

> markdown
>
> 是一种
>
> 轻量级标记语言

### 2、嵌套的区块

> 第一层
>
> > 第二层嵌套
> >
> > > 第三层嵌套

### 3、区块中使用列表

> 1. 第一列
> 2. 第二列
>
> - 第一项
> - 第二项
>   - 第二项第一个元素

### 4、列表中使用区块

- 第一项

  > markdown
  >
  > 是一种
  >
  > 轻量级的标记语言

- 第二项

# 六、代码

### 1、函数或一行代码

段落中的一个函数或代码段可以用反引号（`）包括起来

`pringln("markdown")`输出函数

### 2、代码区块

- 你也可以用 **```** 包裹一段代码，并指定一种语言（也可以不指定）

例如：输入“```”后按回车键。

```
int i = 0;
for(i;i<10;i++){
    System.out.println(i++);
}
```

- 也可以在代码区块每一行开始使用 **4 个空格**或者一个制表符（Tab 键）,这个是github上编辑有效。

# 七、链接

### 1、链接名称加地址

```
使用方法：[链接名称](链接地址 "描述")
```

例如：

```
这是一个百度首页链接[百度一下](https://www.baidu.com “百度一下”)
```

效果如下：

这是一个百度首页链接[百度一下](https://www.baidu.com/)

### 2、直接使用链接地址

```
使用方法：<链接地址>
```

例如：

```
<https://www.baidu.com>
```

效果如下

[https://www.baidu.com](https://www.baidu.com/)

### 3、高级链接

我们可以通过变量来设置一个链接，变量设置下面

```
这个链接用1作为网址变量[Google][1]
这个链接用runoob作为网址变量[baidu][baidu]

然后在文档的结尾为变量赋值
[1]:http://www.google.com
[baidu]:https://www.baidu.com
```

效果如下：

这个链接用1作为网址变量[Google](http://www.google.com/) 这个链接用runoob作为网址变量[baidu](https://www.baidu.com/)

为变量赋值

# 八、图片

Markdown图片语法格式

```
![alt 属性文本](图片地址)
![alt 属性文本](图片地址 "可选标题")

开头一个感叹号 !
接着一个方括号，里面放上图片的替代文字
接着一个普通括号，里面放上图片的网址，最后还可以用引号包住并加上选择性的 'title' 属性的文字。
```

使用实例

```
![菜鸟](http://static.runoob.com/images/runoob-logo.png)
![菜鸟](http://static.runoob.com/images/runoob-logo.png “菜鸟”)
```

效果如下：

[![菜鸟](https://camo.githubusercontent.com/aef978dee72ebf0bc0e86e2d2baf2779403d6077/687474703a2f2f7374617469632e72756e6f6f622e636f6d2f696d616765732f72756e6f6f622d6c6f676f2e706e67)](https://camo.githubusercontent.com/aef978dee72ebf0bc0e86e2d2baf2779403d6077/687474703a2f2f7374617469632e72756e6f6f622e636f6d2f696d616765732f72756e6f6f622d6c6f676f2e706e67) [![菜鸟](https://camo.githubusercontent.com/aef978dee72ebf0bc0e86e2d2baf2779403d6077/687474703a2f2f7374617469632e72756e6f6f622e636f6d2f696d616765732f72756e6f6f622d6c6f676f2e706e67)](https://camo.githubusercontent.com/aef978dee72ebf0bc0e86e2d2baf2779403d6077/687474703a2f2f7374617469632e72756e6f6f622e636f6d2f696d616765732f72756e6f6f622d6c6f676f2e706e67)

# 九、表格

markdown制作表格使用 | 来分隔不同的单元格，使用 - 来分隔表头和其他行。

```
语法格式如下：
|表头   |表头 |
|----  |---- |
|单元格 |单元格|
|单元格 |单元格|
```

显示效果如下：

| 表头   | 表头   |
| ------ | ------ |
| 单元格 | 单元格 |
| 单元格 | 单元格 |

**对其方式**，我可以设置表格的对其方式

- `-:`设置内容和标题栏居右对齐
- `:-`设置内容和标题栏居左对齐
- `:-:`设置内容和标题兰居中对齐

实例如下：

```
|左对其|居中对齐|右对齐|
|:-   | :-:  |  -:  |
|单元格|单元格|单元格|
```

效果如下：

| 左对其 | 居中对齐 | 右对齐 |
| ------ | -------- | ------ |
| 单元格 | 单元格   | 单元格 |

# 十、高级技巧

### 1、支持部分HTML元素

目前支持的HTML元素有：***\*
等，如：\****

***\*实例如下：`<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Del</kbd>重启电脑 `效果如下：Ctrl+Alt+Del重启电脑2、转义Markdown使用了很多特殊符号来表示特定的意义，如果需要显示特定的符号则需要使用转义字符，Markdown使用反斜杠转移特殊的字符。`\**文本加粗\** \*\*正常显示星号 \*\* `效果如下：\**文本加粗\** \**正常显示星号 \**markdown支持以下这些符号前面加上反斜杠来帮助插入普通的符号：`\   反斜线 `   反引号 \*   星号 _   下划线 {}  花括号 []  方括号 ()  小括号 #   井字号 +   加号 -   减号 .   英文句点 !   感叹号 `3、公式当你需要在编辑器中插入数学公式时，可以使用两个美元符 $$ 包裹 TeX 或 LaTeX 格式的数学公式来实现。提交后，问答和文章页会根据需要加载 Mathjax 对数学公式进行渲染。如：`$$ \mathbf{V}_1 \times \mathbf{V}_2 =  \begin{vmatrix}  \mathbf{i} & \mathbf{j} & \mathbf{k} \\ \frac{\partial X}{\partial u} &  \frac{\partial Y}{\partial u} & 0 \\ \frac{\partial X}{\partial v} &  \frac{\partial Y}{\partial v} & 0 \\ \end{vmatrix} ${$tep1}{\style{visibility:hidden}{(x+1)(x+1)}} $$ `效果如下： $$ \mathbf{V}_1 \times \mathbf{V}_2 = \begin{vmatrix} \mathbf{i} & \mathbf{j} & \mathbf{k} \ \frac{\partial X}{\partial u} & \frac{\partial Y}{\partial u} & 0 \ \frac{\partial X}{\partial v} & \frac{\partial Y}{\partial v} & 0 \ \end{vmatrix} ${$tep1}{\style{visibility:hidden}{(x+1)(x+1)}} $$4、Typora画流程图、时序图（顺序图）、甘特图以下几个实例：横向流程图源码格式：````mermaid graph LR A[方形] -->B(圆角)    B --> C{条件a}    C -->|a=1| D[结果1]    C -->|a=2| E[结果2]    F[横向流程图] ``` `效果如下：`graph LR A[方形] -->B(圆角)    B --> C{条件a}    C -->|a=1| D[结果1]    C -->|a=2| E[结果2]    F[横向流程图] `竖向流程图源码格式````mermaid graph TD A[方形] --> B(圆角)    B --> C{条件a}    C --> |a=1| D[结果1]    C --> |a=2| E[结果2]    F[竖向流程图] ``` `效果如下：`graph TD A[方形] --> B(圆角)    B --> C{条件a}    C --> |a=1| D[结果1]    C --> |a=2| E[结果2]    F[竖向流程图] `标准流程图源码格式````flow st=>start: 开始框 op=>operation: 处理框 cond=>condition: 判断框(是或否?) sub1=>subroutine: 子流程 io=>inputoutput: 输入输出框 e=>end: 结束框 st->op->cond cond(yes)->io->e cond(no)->sub1(right)->op ``` `效果如下：`st=>start: 开始框 op=>operation: 处理框 cond=>condition: 判断框(是或否?) sub1=>subroutine: 子流程 io=>inputoutput: 输入输出框 e=>end: 结束框 st->op->cond cond(yes)->io->e cond(no)->sub1(right)->op `标准流程图源码格式（横向）````flow st=>start: 开始框 op=>operation: 处理框 cond=>condition: 判断框(是或否?) sub1=>subroutine: 子流程 io=>inputoutput: 输入输出框 e=>end: 结束框 st(right)->op(right)->cond cond(yes)->io(bottom)->e cond(no)->sub1(right)->op ``` `效果如下：`st=>start: 开始框 op=>operation: 处理框 cond=>condition: 判断框(是或否?) sub1=>subroutine: 子流程 io=>inputoutput: 输入输出框 e=>end: 结束框 st(right)->op(right)->cond cond(yes)->io(bottom)->e cond(no)->sub1(right)->op `UML时序图源码样例````sequence 对象A->对象B: 对象B你好吗?（请求） Note right of 对象B: 对象B的描述 Note left of 对象A: 对象A的描述(提示) 对象B-->对象A: 我很好(响应) 对象A->对象B: 你真的好吗？ ``` `效果如下:`对象A->对象B: 对象B你好吗?（请求） Note right of 对象B: 对象B的描述 Note left of 对象A: 对象A的描述(提示) 对象B-->对象A: 我很好(响应) 对象A->对象B: 你真的好吗？ `UML时序图源码复杂样例````sequence Title: 标题：复杂使用 对象A->对象B: 对象B你好吗?（请求） Note right of 对象B: 对象B的描述 Note left of 对象A: 对象A的描述(提示) 对象B-->对象A: 我很好(响应) 对象B->小三: 你好吗 小三-->>对象A: 对象B找我了 对象A->对象B: 你真的好吗？ Note over 小三,对象B: 我们是朋友 participant C Note right of C: 没人陪我玩 ``` `效果如下：`Title: 标题：复杂使用 对象A->对象B: 对象B你好吗?（请求） Note right of 对象B: 对象B的描述 Note left of 对象A: 对象A的描述(提示) 对象B-->对象A: 我很好(响应) 对象B->小三: 你好吗 小三-->>对象A: 对象B找我了 对象A->对象B: 你真的好吗？ Note over 小三,对象B: 我们是朋友 participant C Note right of C: 没人陪我玩 `UML标准时序图样例````mermaid %% 时序图例子,-> 直线，-->虚线，->>实线箭头  sequenceDiagram    participant 张三    participant 李四    张三->王五: 王五你好吗？    loop 健康检查        王五->王五: 与疾病战斗    end    Note right of 王五: 合理 食物 <br/>看医生...    李四-->>张三: 很好!    王五->李四: 你怎么样?    李四-->王五: 很好! ``` `效果如下：`%% 时序图例子,-> 直线，-->虚线，->>实线箭头  sequenceDiagram    participant 张三    participant 李四    张三->王五: 王五你好吗？    loop 健康检查        王五->王五: 与疾病战斗    end    Note right of 王五: 合理 食物 <br/>看医生...    李四-->>张三: 很好!    王五->李四: 你怎么样?    李四-->王五: 很好! `甘特图样例````mermaid %% 语法示例        gantt        dateFormat  YYYY-MM-DD        title 软件开发甘特图        section 设计        需求                      :done,    des1, 2014-01-06,2014-01-08        原型                      :active,  des2, 2014-01-09, 3d        UI设计                     :         des3, after des2, 5d    未来任务                     :         des4, after des3, 5d        section 开发        学习准备理解需求                      :crit, done, 2014-01-06,24h        设计框架                             :crit, done, after des2, 2d        开发                                 :crit, active, 3d        未来任务                              :crit, 5d        耍                                   :2d        section 测试        功能测试                              :active, a1, after des3, 3d        压力测试                               :after a1  , 20h        测试报告                               : 48h ``` `效果如下：`%% 语法示例        gantt        dateFormat  YYYY-MM-DD        title 软件开发甘特图        section 设计        需求                      :done,    des1, 2014-01-06,2014-01-08        原型                      :active,  des2, 2014-01-09, 3d        UI设计                     :         des3, after des2, 5d    未来任务                     :         des4, after des3, 5d        section 开发        学习准备理解需求                      :crit, done, 2014-01-06,24h        设计框架                             :crit, done, after des2, 2d        开发                                 :crit, active, 3d        未来任务                              :crit, 5d        耍                                   :2d        section 测试        功能测试                              :active, a1, after des3, 3d        压力测试                               :after a1  , 20h        测试报告                               : 48h`\****