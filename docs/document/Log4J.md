# Log4J使用教程

# 一、Log4J是什么

​		日志是应用必不可少的东西，在系统的故障定位、排错方面有着举足轻重的作用。Log4J是Apache的一个开源项目，是一个功能强大的日志组件，可在程序中方便的记录日志。[apache官网](jakarta.apache.org/log4j )下载最近的版本。

# 二、快速入门

## 2.1、引入jar包

```xml
<dependency>  
    <groupId>log4j</groupId>  
    <artifactId>log4j</artifactId>  
    <version>1.2.17</version>  
</dependency>
```

## 2.2、在classpath目录下创建log4j.properties文件

![image-20200527174549617](E:\lagou\高级工程师训练营\学习笔记\img-folder\image-20200527174549617.png)

```
###log4j.properties文件中的内容###

### 设置###
log4j.rootLogger = debug,stdout,D,E

### 输出信息到控制台 ###
log4j.appender.stdout = org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target = System.out
log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n

### 输出DEBUG 级别以上的日志到=./logs/log.log ###
log4j.appender.D = org.apache.log4j.DailyRollingFileAppender
log4j.appender.D.File = E://lagou/workspace/mybatis/logs/log.log
log4j.appender.D.Append = true
log4j.appender.D.Threshold = DEBUG 
log4j.appender.D.layout = org.apache.log4j.PatternLayout
log4j.appender.D.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n

### 输出ERROR 级别以上的日志到=./logs//error.log ###
log4j.appender.E = org.apache.log4j.DailyRollingFileAppender
log4j.appender.E.File = E://lagou/workspace/mybatis/logs/error.log 
log4j.appender.E.Append = true
log4j.appender.E.Threshold = ERROR 
log4j.appender.E.layout = org.apache.log4j.PatternLayout
log4j.appender.E.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n
```

## 2.3、编写测试用例

```
package com.log4j;


import org.apache.log4j.Logger;

public class Log4jTest {
    private static final Logger logger = Logger.getLogger(Log4jTest.class);

    public static void main(String[] args) {
        // 记录debug级别的信息
        logger.debug("This is debug message.");
        // 记录info级别的信息
        logger.info("This is info message.");
        // 记录error级别的信息
        logger.error("This is error message.");
    }
}
```

## 2.4、输出结果

* 控制台

![image-20200527174900171](..\img-folder\image-20200527174900171.png)

* ERROR级别日志文件结果

![image-20200527175001788](..\img-folder\image-20200527175001788.png)

* DEBUG级别日志文件结果

![image-20200527175038492](..\img-folder\image-20200527175038492.png)

## 三、Log4J基本使用方法

### 3.1、Log4J组件的构成

​		Log4j有三个主要的组件：Loggers(记录器)，Appenders (输出源)和Layouts(布局)。这里可简单理解为日志类别，日志要输出的地方和日志以何种形式输出。综合使用这三个组件可以轻松地记录信息的类型和级别，并可以在运行时控制日志输出的样式和位置

* Loggers

  每个Logger都被分了一个日志级别（log level），用来控制日志信息的输出。日志级别从高到低分为：
  A：off 最高等级，用于关闭所有日志记录。
  B：fatal 指出每个严重的错误事件将会导致应用程序的退出。
  C：error 指出虽然发生错误事件，但仍然不影响系统的继续运行。
  D：warm 表明会出现潜在的错误情形。
  E：info 一般和在粗粒度级别上，强调应用程序的运行全程。
  F：debug 一般用于细粒度级别上，对调试应用程序非常有帮助。
  G：all 最低等级，用于打开所有日志记录。

  上面这些级别是定义在org.apache.log4j.Level类中。通过使用日志级别，可以控制应用程序中相应级别日志信息的输出。

* Appenders

  Log4j日志系统还提供许多强大的功能，比如允许把日志输出到不同的地方，如控制台（Console）、文件（File）等，可以根据天数或者文件大小产生新的文件，可以以流的形式发送到其它地方等等。

  常使用的类如下：

  org.apache.log4j.ConsoleAppender（控制台）
  org.apache.log4j.FileAppender（文件）
  org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件）
  org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件）
  org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）

* Layouts

  有时用户希望根据自己的喜好格式化自己的日志输出，Log4j可以在Appenders的后面附加Layouts来完成这个功能。Layouts提供四种日志输出样式，如根据HTML样式、自由指定样式、包含日志级别与信息的样式和包含日志时间、线程、类别等信息的样式。

  常使用的类如下：

  org.apache.log4j.HTMLLayout（以HTML表格形式布局）
  org.apache.log4j.PatternLayout（可以灵活地指定布局模式）
  org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串）
  org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等信息）

### 3.2、 定义配置文件

​		Log4J有两种配置环境的方式：一种程序配置，一种文件配置。其文件配置方式，Log4j支持两种文件格式，一种是XML格式的文件，一种是Java特性文件（键=值）。XML格式配置方式见本文2.2，下面介绍使用Java特性文件做为配置文件的方式：

* 配置根Logger，其语法为：

```
log4j.rootLogger = [ level ] , appenderName, appenderName, …
```

其中，level 是日志记录的级别，分为OFF、FATAL、ERROR、WARN、INFO、DEBUG、ALL或者定义的级别。Log4j建议只使用四个级别，优先级从高到低分别是ERROR、WARN、INFO、DEBUG。通过在这里定义的级别，可以控制应用程序中相应级别的日志信息的开关。比如在这里定 义了INFO级别，则应用程序中所有DEBUG级别的日志信息将不被打印出来，所以生产上一般配置INFO。

appenderName就是指日志信息输出到哪个地方。可以同时指定多个输出目的地。

* 配置日志信息输出目的地Appender，其语法为：

```
log4j.appender.appenderName = fully.qualified.name.of.appender.class  
log4j.appender.appenderName.option1 = value1  
 …  
log4j.appender.appenderName.option = valueN
```

其中，Log4j提供的appender有以下几种：

```
org.apache.log4j.ConsoleAppender（控制台），  
org.apache.log4j.FileAppender（文件），  
org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件），  
org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件），  
org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）
```

* 配置日志信息的格式（布局），其语法为：

```
log4j.appender.appenderName.layout = fully.qualified.name.of.layout.class  
log4j.appender.appenderName.layout.option1 = value1
 …  
log4j.appender.appenderName.layout.optionN = valueN
```

其中，Log4j提供的layout有以几种：

```
org.apache.log4j.HTMLLayout（以HTML表格形式布局），  
org.apache.log4j.PatternLayout（可以灵活地指定布局模式），  
org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串），  
org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等等信息）
```

Log4J采用类似C语言中的printf函数的打印格式格式化日志信息，打印参数如下： %m 输出代码中指定的消息

```
%p 输出优先级，即DEBUG，INFO，WARN，ERROR，FATAL  
%r 输出自应用启动到输出该log信息耗费的毫秒数  
%c 输出所属的类目，通常就是所在类的全名  
%t 输出产生该日志事件的线程名  
%n 输出一个回车换行符，Windows平台为“rn”，Unix平台为“n”  
%d 输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，比如：%d{yyy MMM dd HH:mm:ss,SSS}，输出类似：2002年10月18日 22：10：28，921  
%l 输出日志事件的发生位置，包括类目名、发生的线程，以及在代码中的行数。举例：com.log4j.Log4jTest.main(Log4jTest.java:13)
```

