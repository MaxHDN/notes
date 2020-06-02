# getResourceAsStream的用法

## 一、Java中的getResourceAsStream有以下几种
1. **Class.getResourceAsStream(String path) **： path 不以’/'开头时默认是从此类所在的包下取资源，以’/'开头则是从ClassPath根下获取。其只是通过path构造一个绝对路径，最终还是由ClassLoader获取资源。

2. **Class.getClassLoader.getResourceAsStream(String path) **：默认则是从ClassPath根下获取，path不能以’/'开头，最终是由ClassLoader获取资源。

3. **ServletContext. getResourceAsStream(String path)**：默认从WebAPP根目录下取资源，Tomcat下path是否以’/'开头无所谓，当然这和具体的容器实现有关。
4.  Jsp下的application内置对象就是上面的ServletContext的一种实现。



## 二、getResourceAsStream 用法大致有以下几种

1. 要加载的文件和.class文件在同一目录下，例如：com.x.y 下有类me.class ,同时有资源文件myfile.xml

   那么，应该有如下代码：

   me.class.getResourceAsStream("myfile.xml");

2. 在me.class目录的子目录下，例如：com.x.y 下有类me.class ,同时在 com.x.y.file 目录下有资源文件myfile.xml

   那么，应该有如下代码：

   me.class.getResourceAsStream("file/myfile.xml");

3. 不在me.class目录下，也不在子目录下，例如：com.x.y 下有类me.class ,同时在 com.x.file 目录下有资源文件myfile.xml

   那么，应该有如下代码：

   me.class.getResourceAsStream("/com/x/file/myfile.xml");

## 三、总结，可能只是两种写法

1. 前面有 “  / ”

   “ / ”代表了工程的classpath路径，例如工程名叫做myproject，“ / ”代表了myproject的classpath路径

   me.class.getResourceAsStream("/com/x/file/myfile.xml");

   说明，再maven项目中，编译后的工程目录是不包括src/java,下图编译后classes就是classpath路径

   ![image-20200602154419200](..\img-folder\image-20200602154419200.png)

2. 前面没有 “  / ”

   代表当前类的目录

   me.class.getResourceAsStream("myfile.xml");

   me.class.getResourceAsStream("file/myfile.xml");

   

# 四、其他

1. 这个方法的内部实现主要是依赖于类加载器，一般的自己实现的类是用AppClassLoader的getResourceAsStream()方法，如果是java.lang.Object这种类就是bootstrap类加载器的getSystemResourceAsStream(java.lang.String)方法。Tomcat实现的则是通过自己在java.lang.ClassLoader基础上扩展的webAppLoader实现类加器，再调用getResourceAsStream().
2. 可能这样总结更好，<font color=red> **路径前不带'/'，则是相对路径(相对当前类所在的包)；若带，则是绝对路径。（这个绝对只是在工程内的绝对，并不绝对于磁盘）**</font>