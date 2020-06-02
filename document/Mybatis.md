 ## Mybatis框架

### 一、框架

#### 1、框架是什么（背景描述）

* 现在软件开发环境和软件规模非常大，不可能所有系统代码都从0开始敲。（背景）
* 软件行业中有很多优秀的解决方案可以重复利用

* 类比，演唱会的舞台是框架，具体节目是需求
* （一堆）可重复使用的、解决特定问题代码       （本质）

 #### 2、框架要解决的问题（解决背景描述的问题）

* 基础技术整合
* 提高性能、安全、易维护、易扩展
* 提高开发效率（代码不用从零开始写）

#### 3、框架的使用

* 场景（用在哪里）：在企业级项目中使用（适合就好，避免大炮打蚊子，步枪打航母）
* 步骤（怎么用）：工程中引入一jar包、通过配置xml定制框架运行细节、在java程序中调用框架API



### 二、软件分层

#### 1、分层是什么

* 可以把代码放到一个文件中，但是难以维护、扩展、阅读
* 将一个文件中的代码按照某种要求（功能）拆分成多个文件，使得代码结构清晰，易于维护，易于扩展
* 分层的本质就是代码的拆分

* 例如

  * Model1模式：jsp + javabean（jsp处理请求）

  * Model2模式（MVC）：jsp + servlet + javabean（servlet处理请求）

    M：模型（service + dao），V：视图 ，C：control

  * 经典三层

  ​          web表现层（视图 + controller）、service层、dao层

#### 2、分层要解决的问题

* 代码清晰
* 解耦
* 易于维护
* 出现问题易于定位

#### 3、分层开发下常见的框架

* dao层：hibernate、mybatis
* service层：spring（对象容器）
* web表现层：springmvc



### 三、Mybatis框架

### 0、自定义持久层框架设计思路

* 使用端（项目）：引入自定义持久层jar包

  提供两部分配置信息：数据库配置信息、sql配置信息（sql语句、参数类型、返回结果类型）

  使用配置文件来提供这两部分配置信息：

  （1）核心配置文件SqlMapConfig.xml：存放数据库配置信息、存放xxxMapper.xml文件路径

  （2）Sql语句配置信息：存放Sql相关信息

* 自定义持久层框架本身：本质是对JDBC代码的封装

  （1）加载配置文件：根据配置文件的路径，加载配置文件成输入字节流，存储在内存中

  ​			创建Resources类 ，方法 InputStream getResourceAsStream(String path);

  （2）创建两个JavaBean：容器对象，用来存放配置文件解析出来的配置信息

  ​		    Configuration：核心配置类，存放SqlMapConfig.xml解析出来的配置信息

  ​            MappedStatment：Sql映射配置类，存放xxxMapper.xml配置出来的内容

  （3）解析配置文件：dom4J

  ​		  创建类SqlSessionFactoryBuilder ，方法SqlSessionFactory Build(InputStream inputStream)

  ​		  第一、使用dom4J解析配置文件，将解析出来的的内容存放到容器对象中。

  ​		  第二、创建SqlSessionFactory对象，生产SqlSession会话对象（工厂模式）

  （4）创建SqlSessionFactory接口以及实现类DefaultSqlSessionFactory

  ​			第一、创建方法openSession()，生产SqlSession

  （5）创建SqlSession接口以及实现类DefaultSqlSession

  ​			定义数据的操作: selectList()

  ​										 selectOne()

  ​									     update()

  ​										 insert()

  （6）创建Executor接口及实现类SimpleExecutor实现类

  ​			query(Configuration configuration,MappedStatement mappedStatement,Object... params) 

  ​             执行具体的JDBC代码



#### 1、原生JDBC访问数据库的步骤

~~~
1、加载数据驱动          Class.forName("com.mysql.jdbc.Driver")
2、获取连接     DriverManager.getConnection(url, user, password)
3、编写sql语句          String sql = "select * from user"
4、创建Statement/PrepareStatement对象 Connection.prepareStatement(sql)
5、设置参数
6、执行sql脚本，获取返回结果          Statement.executeQuery()等
7、处理返回结果           
8、关闭资源
~~~

#### 2、原生JDBC方式访问数据库缺点

* 数据连接配置信息硬编码

* 频繁获取/释放数据库连接，影响数据库和应用性能

  解决方式：使用数据库连接池技术，在SqlMapConfig.xml中配置数据连接池，使用连接池管理数据库连接

* sql语句写在代码中，不易维护。实际应用中，业务经常改，造成sql脚本经常变，维护成本高。

  解决方式：将SQL语句配置在XXXmapper.xml文件中，与java代码分离。

* 向Sql语句传参数麻烦，因为Sql语句的where条件不一定，可能多也可能少，占位符需要和参数一一对应

  解决方案：Mybatis自动将Java对象映射至Sql语句，通过statement中的parameterType定义输入参数的类型。

* 结果集解析麻烦，Sql变化会导致解析代码变化，如果能将数据库记录封装成Pojo对象解析比较方便。

  解决方案：Mybatis自动将Sql执行结果映射至Java对象，通过statement中的resultType定义输出结果的类型

#### 3、ORM思想

​        ORM：Object/Relation Mapping 对象/关系映射。

​        将数据库中的关系数据表映射为JAVA中的对象，把对数据表的操作转换为对对象的操作，实现面向对象编程。因此ORM的目的是使得开发人员以面向对象的思想来操作数据库。

​        比如：原来insert使用的是insert into…，如果使用实现了ORM思想的持久层框架，就可以在Java程序中直接调用api，比如insert(User)，达到操作对象即操作数据库的效果。

#### 4、Mybatis是什么

* Mybatis原本是Apache软件基金会的一个开源项目叫做iBatis
* 是一个对JDBC封装的优秀持久层框架
* 开发者只需要关注Sql语句（业务）本身即可，无需处理加载驱动、获取连接、创建Statement等繁琐的过程
* 最大的特点是把Sql语句写在XML配置文件当中，执行完Sql语句之后可以以对象形式返回（POJO/POJO集合等）
* 是一个半自动的ORM持久层框架，是需要开发者编写Sql语句。
* Hibernate是一个全自动的ORM持久层框架，只需要编写POJO，在xml中定义好Pojo属性和数据表字段的映射/对应关系，就可以在java中实现类似 insert(User)的操作，Sql语句都不用写。（性能差）

#### 5、Mybatis开发方式 

#### 6、全局配置文件SqlMapConfig使用说明

#### 7、Mybatis输入参数类型和结果类型

#### 8、Mybatis连接池和事务控制

#### 9、Mybatis入门级CRUD操作

#### 10、Mybatis动态SQL

#### 11、Mybatis多表关联查询

#### 12、Mybatis的注解开发

#### 13、Mybatis延迟加载策略

#### 14、Mybatis缓存

#### 15、Tomcat配置JNDI数据源

### 四、扩展知识

#### 1、元数据

####  2、Mybatis源码中的设计模式







