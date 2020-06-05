# Mybatis

## 第一部分 自定义持久层框架

思路： 原生JDBC访问数据库的步骤

​			分析JDBC操作数据库的问题

​			问题的解决思路

​			自定义框架设计（功能层面设计）

​			自定义框架实现（代码层面实现）

​			自定义框架优化  

### 1.1 原生JDBC访问数据库的步骤

~~~java
public static void main(String[] args) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        try {
            // 加载数据库驱动
            Class.forName("com.mysql.jdbc.Driver");
            // 通过DriverManager获取数据库连接
            connection =
                    DriverManager.getConnection("jdbc:mysql://localhost:3306/mybatis?characterEncoding = utf - 8", " root", " root");
            // 定义sql语句，“？”表示占位符
            String sql = "select * from user where username = ?";
            // 获取预处理PreparedStatement
            preparedStatement = connection.prepareStatement(sql);
            // 设置参数，sql语句占位符号?，序号从1开始
            preparedStatement.setString(1, "tom");
            // 执行sql语句，获取结果集。
            resultSet = preparedStatement.executeQuery();
            // 遍历结果集
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String username = resultSet.getString("username");
                // 封装结果集到实体对象User
                User user = new User();
                user.setId(id);
                user.setUsername(username);
                System.out.println(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 释放资源
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
~~~

###  1.2 原生JDBC方式访问数据库问题

* 数据连接配置信息硬编码。

* 频繁创建/关闭数据库连接，影响数据库和应用的性能

* sql语句写在代码中硬编码，不易维护。实际应用中，业务经常改，造成sql脚本经常变，维护成本高。

* sql语s句设置参数麻烦，因为sql语句的where条件不一定，可能多也可能少，占位符需要和参数一一对应

* 结果集解析硬编码，sql变化会导致解析代码变化。

### 1.3 问题解决思路

* 数据库配置信息、sql语句：使用配置文件

* 频繁的创建/关闭数据库连接：使用数据库连接池
* sql语句设置参数、结果解析：使用反射、内省

### 1.4 自定义持久层框架设计、实现及优化

* 应用程序（框架的使用端）

  使用配置文件来提供两部分配置信息： 数据库配置信息、sql配置信息

  （1）核心配置文件SqlMapConfig.xml：存放数据库配置信息、存放xxxMapper.xml文件路径

  （2）sql语句配置信息xxxMapper.xml：存放sql语句相关信息(sql语句、参数类型、返回结果类型)

* 自定义持久层框架思路

  （1）加载配置文件：根据配置文件的路径，加载配置文件成输入字节流，存储在内存中

  ​			创建Resources类 ，方法 InputStream getResourceAsStream(String path);

  （2）创建两个JavaBean：容器对象，用来存放从配置文件中解析出来的配置信息

  ​		    Configuration：核心配置类，存放从sqlMapConsfig.xml解析出来的配置信息

  ​            MappedStatment：sql映射配置类，存放从xxxMapper.xml配置出来的内容

  （3）解析配置文件：使用dom4j

  ​		  创建类SqlSessionFactoryBuilder 和方法SqlSessionFactory Build(InputStream inputStream)

  ​		  方法build()内部逻辑：

  ​		  Ⅰ、使用dom4J解析配置文件，将解析出来的的内容存放到容器对象中。

  ​		  Ⅱ、创建SqlSessionFactory对象用来生产SqlSession会话对象（工厂模式）

  （4）创建SqlSessionFactory接口以及实现类DefaultSqlSessionFactory

  ​		  定义抽象方法openSession()，并在实现类中重写方法，生产SqlSession会话对象

  （5）创建SqlSession接口以及实现类DefaultSqlSession

  ​			定义数据库的操作: selectList(String statementid,Object... params)

  ​										     selectOne(String statementid,Object... params)

  ​									         update(...)

  ​										     insert(...)

  （6）创建Executor接口及实现类SimpleExecutor实现类

  ​			query(Configuration configuration,MappedStatement mappedStatement,Object... params) 

  ​             执行具体的JDBC代码（本质是对JDBC代码的封装）

   （7）涉及到的设计模式，建造者模式、工厂模式、动态代理模式

  

* 自定义框架的代码实现及优化

  见 github 工程 IPersitence、IPersistence_Test

## 第二部分 框架是什么

#### 2.1 框架是什么（背景描述）

* 现在软件开发环境和软件规模非常大，不可能所有系统代码都从0开始敲。（背景）
* 软件行业中有很多优秀的解决方案可以重复利用

* 类比，演唱会的舞台是框架，具体节目是需求
* （一堆）可重复使用的、解决特定问题代码       （本质）

 #### 2.2 框架要解决的问题（解决背景描述的问题）

* 基础技术整合
* 提高性能、安全、易维护、易扩展
* 提高开发效率（代码不用从零开始写）

#### 2.3 框架的使用

* 场景（用在哪里）：在企业级项目中使用（适合就好，避免大炮打蚊子，步枪打航母）
* 步骤（怎么用）：工程中引入一jar包、通过配置xml定制框架运行细节、在java程序中调用框架API

## 第三部分 软件分层

#### 3.1 分层是什么

* 可以把代码放到一个文件中，但是难以维护、扩展、阅读
* 将一个文件中的代码按照某种要求（功能）拆分成多个文件，使得代码结构清晰，易于维护，易于扩展
* 分层的本质就是代码的拆分

* 例如

  * Model1模式：jsp + javabean（jsp处理请求）

  * Model2模式（MVC）：jsp + servlet + javabean（servlet处理请求）

    M：模型（service + dao），V：视图 ，C：control

  * 经典三层

  ​          web表现层（视图 + controller）、service层、dao层

#### 3.2 分层要解决的问题

* 代码清晰
* 解耦
* 易于维护
* 出现问题易于定位

#### 3.3 分层开发下常见的框架

* dao层：hibernate、mybatis
* service层：spring（对象容器）
* web表现层：springmvc

## 第四部分 MyBatis相关概念



#### 4.1 对象/关系映射（ORM）

​        ORM：Object/Relation Mapping 对象/关系映射。

​        将数据库中的关系数据表映射为JAVA中的对象，把对数据表的操作转换为对对象的操作，实现面向对象编程。因此ORM的目的是使得开发人员以面向对象的思想来操作数据库。

​        比如：原来insert使用的是insert into…，如果使用实现了ORM思想的持久层框架，就可以在Java程序中直接调用api，比如insert("namespace.id",User)，达到操作对象即操作数据库的效果。

#### 4.2 Mybatis是什么

* Mybatis原本是Apache软件基金会的一个开源项目叫做iBatis
* 是一个对JDBC封装的优秀持久层框架
* 开发者只需要关注Sql语句（业务）本身即可，无需处理加载驱动、获取连接、创建Statement等繁琐的过程
* 最大的特点是把Sql语句写在XML配置文件当中，执行完Sql语句之后可以以对象形式返回（POJO/POJO集合等）
* 是一个半自动的ORM持久层框架，是需要开发者编写Sql语句。
* Hibernate是一个全自动的ORM持久层框架，只需要编写POJO，在xml中定义好Pojo属性和数据表字段的映射/对应关系，就可以在java中实现类似 insert(User)的操作，Sql语句都不用写。（性能差）

分析图如下：

![image-20200604142941181](..\img-folder\image-20200604142941181.png)

## 第五部分 MyBatis基本应用

### 5.1 Mybatis两种开发方式

#### 5.1.1 原始开发方式

* 定义接口UserDao：定义crud方法

~~~java
package com.mybatis.dao;

import com.mybatis.pojo.User;

/**
 * 原始Dao开发方式接口定义
 */
public interface UserDao {
    User queryUserById(Integer id) throws Exception;
}
~~~

* 编写实现类UserDaoImpl，在实现类中实现crud逻辑

~~~java
package com.mybatis.dao;

import com.mybatis.pojo.User;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

public class UserDaoImpl implements UserDao {

    /**
     * 声明一个SqlSessionFactory变量，用于接收service层调用dao层时传入的工厂对象
     * 因为工厂对象全局唯一，对于全局唯一的对象，在分层的架构中，dao层使用时候应该由
     * 外部传入
     */
    private SqlSessionFactory sqlSessionFactory;
    public UserDaoImpl(SqlSessionFactory sqlSessionFactory) {
        this.sqlSessionFactory = sqlSessionFactory;
    }

    @Override
    public User queryUserById(Integer id) throws Exception {
        SqlSession sqlSession = sqlSessionFactory.openSession();
        User user = sqlSession.selectOne("test.queryUserById", id);
        sqlSession.close();
        return user;
    }
}
~~~

* 思考

  一个项目当中会有很多表，都对应dao接口和实现类，实现类就是做增删改查这些东西

  能否不写实现类只定义接口，让框架帮我们完成实现类的逻辑，那么就是Mapper动态代理的开发方式

#### 5.1.2 Mapper动态代理开发方式

* 定义IUserMapper接口（这个接口和UserDao接口是一样的，接口一般为IxxxMapper.java）

  ~~~java
  package com.mybatis.mapper;
  
  import com.mybatis.pojo.User;
  
  /**
   * Mapper动态代理开放方式，接口定义
   */
  public interface IUserMapper {
      User queryUserById(Integer id) throws Exception;
  }
  
  ~~~

* Mapper动态代理开发方式，SQL语句配置文件（UserMapper.xml ）遵循的规范

  1）Mapper.xml映射文件的namespace必须和mapper接口的全限定类名一致

  2）Mapper接口方法名必须和Mapper.xml中的sql语句id一致

  3）Mapper接口方法输入参数类型必须和sql语句的输入参数类型parameterType一致

  4）mapper接口方法返回类型必须和sql语句的resultType类型一致

  6）UserMapper.xml和UserMapper.class两个文件名称相同	

  ​	说明：下图中UserDao应该时UserMapper

![](..\img-folder\image-20200604150858654.png)

* 测试Mapper动态代理方式

  ~~~java
  @Test
  public void testProxyDao() throws IOException {
      InputStream resourceAsStream =
      					Resources.getResourceAsStream("sqlMapConfig.xml");
      SqlSessionFactory sqlSessionFactory = new
      					SqlSessionFactoryBuilder().build(resourceAsStream);
      SqlSession sqlSession = sqlSessionFactory.openSession();
      //឴获得MyBatis框架生成UserMapper接口的代理对象
      UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
      User user = userMapper.findById(1);
      System.out.println(user);
      sqlSession.close();
  }
  ~~~

  

* 小结

​        从Mybatis框架中拿到一个代理对象（代理的是这个Mapper接口），通过代理对象调用接口当中的方法完成业务，传统dao开发方式中的实现类其实起了一个连接、承上启下的作用，连接了接口和xml映射文件，效果就是调用接口方法时能够找到xml映射文件。Mapper动态代理开发方式在遵循sql语句配置文件规范后，能够通过调用的接口方法找到xml映射文件。

​		原始Dao开放方式和Mapper动态代理开发方式在企业中都很常见，**推荐使用Mapper动态代理开发模式**。



### 5.2 MyBatis配置文件

#### 5.2.1 sqlMapConfig.xml

 1）配置文件的层级关系

* configuration 配置根标签
  * properties属性
  * setting属性
  * typeAliases类型别名
  * typeHandlers类型处理器
  * objectFactory对象工厂
  * enviroments环境
    * enviroments环境变量
      * transactionManager 事务管理器
      * dataSource 数据源
  * databaseIdProvider数据库厂商标识
  * mappers映射器
    * mapper 映射
      * resource属性
    * package 
      * name属性

2） MyBatis常用配置解析

* **enviroments**标签

  数据库环境的配置，支持多环境配置

  ![image-20200604155949153](..\img-folder\imageenviroments标签.png)

  其中，事务管理器（transactionManager）类型有两种

  * JDBC：这个配置就是直接使用JDBC提交和回滚设置，它依赖于从数据源得到的连接来管理事务的作用域
  * MANAGED：这个配置几乎没做什么，它从来不提交或回滚一个连接，而让容器来管理事务的整个生命周期（比如JEE应用服务的上下文）。默认情况下它会关闭连接，然而一些容器并不希望这样，因此需要将closeConnection属性设置为false来阻止它默认的关闭行为。

  其中，数据源（dataSource）类型有三种

  * UNPOOLED：这个数据源类型的实现，是每次请求时创建和关闭连接（就是不用数据库连接池）。
  * POOLED：这种类型数据源的实现，利用“数据库连接池”将JDBC连接对象组织起来，从连接池中获取连接。
  * JNDI：这种数据源的实现是为了能在EJB或应用服务器这类容器中使用，容器可以集中或者在外部配置数据源，然后放置一个JNDI上下文引用。

* **mapper** 标签

  该标签的作用是加载映射的，加载方式有如下几种

  * 使用相对于类路径的资源引用，例如：
  * 使用完全限定资源定位符（URL）,例如：
  * 使用映射器接口实现类的完全限定名，例如：
  * 将包内的映射器接口实现完全注册为映射器，例如

* **package**标签

  package标签，通过name属性指定mapper接口所在的包名，但是**对应的映射文件必须与接口位于同一路径下，并且名称相同**（mapper标签引入单个没有这个要求）

  比如接口： com.daonian.practice.mybatis.mapper.IUserMapper

  对应配置文件所在包必须是：com/daonian/practice/mybatis/mapper

* **properties** 标签

  习惯将数据源的配置信息单独抽取成一个properties文件，该标签可以加载一个properties文件。

  ![image-20200604162304575](..\img-folder\image-properties标签.png)

* **typeAliases** 标签

  定义单个别名，主要给pojo定义别名     

  ~~~xml
  <typeAliases>    
  	<-- type：给哪个类定义别名   alias：别名名称      -->
  	<typeAlias type="com.mybatis.pojo.User" alias="user"/>
  </typeAliases>  
  ~~~

  批量定义别名：package指定要扫描的包路径  注意：package会扫描包及其子包下的所有类，不要有类名重复的情况，否则异常    

  ~~~xml
   <typeAliases> 
       <!-- 批量定义别名，指定包名，此时pojo类的别名是pojo类的类名首字母大写或小写都行 -->
  	<package name="com.mybatis.pojo"/>
  </typeAliases>
  ~~~

  

  例如：为一个java类全限定名设置一个别名，原来配置如下

  ![image-20200604162720731](..\img-folder\image-20200604162720731.png)

  配置typeAliases，为com.daonian.domain.User定义别名user

  ![image-20200604162905991](..\img-folder\image-typeAliaes标签.png)

  上面是我们自定义别名，MyBatis框架已经设置好了一些常用的的类型别名。

  **MyBatis默认支持的别名如下**：

  | 别名       | 映射的类型 |
  | ---------- | ---------- |
  | _byte      | byte       |
  | _long      | long       |
  | _short     | short      |
  | _int       | int        |
  | _integer   | int        |
  | _double    | double     |
  | _float     | float      |
  | _boolean   | boolean    |
  | string     | String     |
  | byte       | Byte       |
  | long       | Long       |
  | short      | Short      |
  | int        | Integer    |
  | integer    | Integer    |
  | double     | Double     |
  | float      | Float      |
  | boolean    | Boolean    |
  | date       | Date       |
  | decimal    | BigDecimal |
  | bigdecimal | BigDecimal |
  | map        | Map        |

  注意：更多默认别名参见mybatis源码中的**TypeAliasRegistry**

#### 5.2.2 xxxMapper.xml

##### 5.2.2.1 **配置文件分析**

![image-20200604154332276](..\img-folder\image-sqlMapConfig配置文件分析.png)

##### 5.2.2.2 **动态sql语句**

​		前面我们的SQL语句都是比较简单的，业务逻辑较复杂的时候，SQL是动态变化的，此时简单的SQL语句就不能满足业务需求。MyBatis官方文件对动态sql的描述如下：

![image-20200604163658833](..\img-folder\image-20200604163658833.png)

* 动态SQL之**多条件组合查询** -  <if>标签、<where>标签	

  **<where>标签**：where标签会自动自动添加where关键字，并且去掉紧跟其后的第一个 and 或者 or。如果不使用where标签，sql语句中where后面第一个条件应该是where 1=1。

  **<if>标签**：分支判断，根据test="逻辑判断"的值，来拼接sql语句。

  根据参数的不同，使用不同的SQL语句来进行查询。比如在id不为空时可以根据id查询，如果username不为空还要加入用户名作为条件

  

  ~~~xml
  <select id="findByCondition" parameterType="user" resultType="user">
      select * from User
      <where>
          <if test="id!=0">
          	and id=#{id}
          </if>
          <if test="username!=null">
          	and username=#{username}
          </if>
      </where>
  </select>
  ~~~

* 动态SQL之 **多值条件查询** - <foreach>

  参考资料：[mybatis之foreach用法](https://www.cnblogs.com/fnlingnzb-learner/p/10566452.html)

  循环执行sql的拼接操作，例如：select * from user where id in (1, 2, 3)

  ~~~xml
  <select id="findByIds" parameterType="list" resultType="user">
      select * from User
      <where>
          <foreach collection="list" open="id in(" close=")" item="id" separator=",">
              #{id}
          </foreach>
      </where>
  </select>
  ~~~

  foreach元素的属性主要有item，index，collection，open，separator，close。

  * **collection:** 要做foreach的对象，作为入参时，List对象默认用"list"代替作为键，数组对象有"array"代替作为键，Map对象没有默认的键。当然在作为入参时可以使用@Param("keyName")来设置键，设置keyName后，list,array将会失效。 除了入参这种情况外，还有一种作为参数对象的某个字段的时候。举个例子：如果User有属性List ids。入参是User对象，那么这个collection = "ids".***如果User有属性Ids ids;其中Ids是个对象，Ids有个属性List id;入参是User对象，那么collection = "ids.id"***

  - **open** ：foreach代码的开始符号，一般是(和close=")"合用。常用在in(),values()时。该参数可选
  - **close** ：foreach代码的关闭符号，一般是)和open="("合用。常用在in(),values()时。该参数可选。
  - **item**： 集合中元素迭代时的别名，该参数为必选。
  - **separator**：元素之间的分隔符，例如在in()的时候，separator=","会自动在元素中间用“,“隔开，避免手动输入逗号导致sql错误，如in(1,2,)这样。该参数可选。
  - **index**：在list和数组中,index是元素的序号，在map中，index是元素的key，该参数可选

  在使用foreach的时候最关键的也是最容易出错的就是collection属性，该属性是必须指定的，但是在不同情况下，该属性的值是不一样的，主要有一下3种情况： 

  - 如果传入的是单参数且参数类型是一个List的时候，collection属性值为list .
  - 如果传入的是单参数且参数类型是一个array数组的时候，collection的属性值为array .
  - 如果传入的参数是多个的时候，我们就需要把它们封装成一个Map了，当然单参数也可以封装成map，实际上如果你在传入参数的时候，在MyBatis里面也是会把它封装成一个Map的，map的key就是参数名，所以这个时候collection属性值就是传入的List或array对象在自己封装的map里面的key.

  针对最后一条，我们来看一下官方说法：

  > 注意 你可以将一个 List 实例或者数组作为参数对象传给 MyBatis，当你这么做的时候，MyBatis 会自动将它包装在一个 Map 中并以名称为键。List 实例将会以“list”作为键，而数组实例的键将是“array”。

  所以，不管是多参数还是单参数的list,array类型，都可以封装为map进行传递。如果传递的是一个List，则mybatis会封装为一个list为key，list值为object的map，如果是array，则封装成一个array为key，array的值为object的map，如果自己封装呢，则colloection里放的是自己封装的map里的key值。

  

  **源码分析**

  由于官方文档对这块的使用，描述的比较简短，细节上也被忽略掉了(可能是开源项目文档一贯的问题吧)，也使用不少同学在使用中遇到了问题。特别是foreach这个函数中，collection属性做什么用，有什么注意事项。由于文档不全，这块只能通过源代码剖析的方式来分析一下各个属性的相关要求。

  collection属性的用途是接收输入的数组或是List接口实现。但对于其名称的要求，Mybatis在实现中还是有点不好理解的，所以需要特别注意这一点。

  下面开始分析源代码(笔记使用的是Mybatis 3.0.5版本)

  先找到Mybatis执行SQL配置解析的入口，MapperMethod.java类中 public Object execute(Object[] args) 该方法是执行的入口。针对in集合查询，对应用就是 selectForList或SelctForMap方法。

  ![img](..\img-folder\1000464-20190320173657220-1615038745.png)

  但不管调用哪个方法，都会对原来传入Object[]类型的参数args 进行处理，通过 getParam方法转换成一个Object,那这个方法是做什么的呢？分析源码如下：

![img](..\img-folder\1000464-20190320173731188-273615511.png)

上图中标红的两处，很惊讶的发现，一个参数与多个参数的处理方式是不同的(后续很多同学遇到的问题，就有一大部分出自这个地方)。如果参数个数大于一个，则会被封装成Map, key值如果使用了Mybatis的 Param注解，则会使用该key值，否则默认统一使用数据序号,从1开始（新版本从param1,param2,..依次）。这个问题先记下，继续分析代码，接下来如果是selectForList操作(其它操作就对应用相应方法),会调用DefaultSqlSession的public List selectList(String statement, Object parameter, RowBounds rowBounds) 方法

又一个发现，见源代码如下：

![img](..\img-folder\1000464-20190320173752320-237995715.png)

上图标红部分，对参数又做了一次封装，我们看一下代码

![img](..\img-folder\1000464-20190320173803697-949044115.png)

现在有点清楚了，如果参数类型是List,则必须在collecion中指定为list, 如果是数据组，则必须在collection属性中指定为 array.

现在就问题就比较清楚了，如果是一个参数的话，collection的值取决于你的参数类型。

如果是多个值的话，除非使用注解Param指定，否则都是数字开头，所以在collection中指定什么值都是无用的。下图是debug显示结果。

![img](..\img-folder\1000464-20190320173836786-932705696.png)

##### 5.2.2.3 输入参数类型

**0）输入参数标签<parameterType>**

* parameterType有基本数据类型和复杂的数据类型。
  * 基本数据类型：int、string、long、Date;
  * 复杂数据类型：类（JavaBean）、数组、集合、Map

* 获取方式
  * 基本数据类型：#{value}或${value} 获取参数中的值
  * 复杂数据类型：#{属性名}或${属性名} ，map中则是#{key}或${key}

* #{}与${}的区别
  * #{value}：输入参数的占位符，相当于jdbc的 ？ 防sql注入  自动添加了 ''引号
  * ${value}:  不防注入，就是字符串拼接 ，不自动添加 '' 引号

**1）基本类型的单个参数传递**

~~~java
// 单个传参 mapper接口
void deleteById(Integer id);
~~~

```xml
<!--mapper.xml，当用#{}获取参数值时，中括号里的值可以任意字符串，但是一般建议和表中的字段一致，容易阅读-->
<delete id="deleteById" parameterType="int">
    delete from user where id = #{id}
</delete>
```

```java
// 测试单个参数传参
@Test
public void testDeleteById(){
    userMapper.deleteById(3);
    sqlSession.commit();
}
```

**2）顺序传递参数（没有使用@Param）**

~~~java
//顺序传参 mapper接口
List<MybatisUser> findByIdAndUsername(int id, String username);
~~~

```xml
<!--顺序传参mapper.xml-->
<select id="findByIdAndUsername"  resultType="mybatisUser">
    select * from user
    <where>
        <if test="id != 0">
            and id = #{id}
        </if>
        <if test="username != null">
            and username = #{username}
        </if>
    </where>
</select>
```

**注意**，这里按参数名去引用的话会报如下错误，mybatis错误提示很细致，这里明确给我们提示，参数只能使用arg1, arg0, param1, param2 类似的参数名获取。这种传参方式的缺点是不够灵活，必须严格按照参数顺序来引用。

![image-20200605152938352](..\img-folder\image-20200605152938352.png)

所以正确的的获取参数的方式如下

```xml
<!--顺序传参mapper.xml-->
<select id="findByIdAndUsername"  resultType="mybatisUser">
    select * from user
    <where>
        <if test="id != 0">
            and id = #{param1}
        </if>
        <if test="username != null">
            and username = #{param2}
        </if>
    </where>
</select>
```

```java
// 测试使用顺序传参
@Test
public void testFindByIdAndUsername(){
    List<MybatisUser> mybatisUsers = userMapper.findByIdAndUsername(1, "张三");
    for (MybatisUser mybatisUser : mybatisUsers) {
        System.out.println(mybatisUser);
    }
}
```

**3）使用@param注解方式**

```java
//使用@Param注解方式传参
List<MybatisUser> findByIdAndUsernameUserParam(@Param("id") int id, @Param("username") String username);
```

```xml
<!--使用@Param注解传参-->
<select id="findByIdAndUsernameUserParam"  resultType="mybatisUser">
    select * from user
    <where>
        <if test="id != 0">
            and id = #{id}
        </if>
        <if test="username != null">
            and username = #{username}
        </if>
    </where>
</select>
```

```java
// 测试使用@param的方式传递参数
@Test
    public void testFindByIdAndUsername2(){
        List<MybatisUser> mybatisUsers = userMapper.findByIdAndUsernameUserParam(1, "张三");
        for (MybatisUser mybatisUser : mybatisUsers) {
            System.out.println(mybatisUser);
        }
    }
```

使用@Param注解，就是告诉mybatis参数的名字，在xml中就可以按照参数名去引用了

**4）使用Map传递参数**

```java
// 使用map方式传递参数
List<MybatisUser> findByIdAndUsernameUseMap(Map paramMap);
```

```xml
<!--使用map方式传递参数-->
<select id="findByIdAndUsernameUseMap"  resultType="mybatisUser">
    select * from user  where id = #{id} and username = #{username}
</select>
```

```java
// 测试使用map的方式传参
@Test
public void findByIdAndUsernameUseMap(){
    Map<String,Object> map = new HashMap<>();
    map.put("id",1);
    map.put("username","张三");
    List<MybatisUser> mybatisUsers = userMapper.findByIdAndUsernameUseMap(map);
    for (MybatisUser mybatisUser : mybatisUsers) {
        System.out.println(mybatisUser);
    }
}
```

实际开发中使用map来传递多个参数是一种推荐的方式,使用map中的key获取参数的值，

例如：#{id}用来获取id的值，#{username}用来获取用户名的值



**5）使用JSON对象方式传递参数**

```java
// 使用JSON对象方式传递参数
List<MybatisUser> findByIdAndUsernameUseJsonObject(JSONObject jsonObject);
```

```xml
<!--使用JSON方式传递参数-->
<select id="findByIdAndUsernameUseJsonObject"  resultType="mybatisUser">
    select * from user  where id = #{id} and username = #{username}
</select>
```

```java
// 测试使用JSON对象的方式传递参数
@Test
public void findByIdAndUsernameUseJsonObject(){
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("id",1);
    jsonObject.put("username","张三");
    List<MybatisUser> mybatisUsers = userMapper.findByIdAndUsernameUseJsonObject(jsonObject);
    for (MybatisUser mybatisUser : mybatisUsers) {
        System.out.println(mybatisUser);
    }
}
```

**6）传递集合类型参数List、Set，数组类型参数Array**

在一些复杂的查询中（如 sql中的 in操作），传统的参数传递已无法满足需求，这时候就要用到List、Set、Array类型的参数传递

* **使用List集合的方式传递参数**

  ~~~java
  //使用List集合的方式传递参数
  // <foreach>多值查询
  List<MybatisUser> findByIdsUseList(List<Integer> list);
  ~~~

  ~~~xml
  <!--使用集合的方式传递参数-->
  <!--open = "and id in", where标签会把where后第一个and优化掉 -->
  <select id="findByIdsUseList" parameterType="list" resultType="mybatisUser">
      select * from user
      <where>
          <foreach collection="list" open=" and id in (" close=")" item="id" separator=",">
              #{id}
          </foreach>
      </where>
  </select>
  ~~~

  ~~~java
  // 测试使用集合的方式传递参数
  @Test
  public void testFindByIdsUseList(){
      List<Integer> list = new ArrayList<>();
      list.add(1);
      list.add(2);
      List<MybatisUser> users = userMapper.findByIdsUseList(list);
      for (MybatisUser user : users) {
          System.out.println(user);
      }
  }
  ~~~

  

* **使用Set集合的方式传递参数**

  ~~~java
  //使用Set集合的方式传递参数,mapper接口
  List<MybatisUser> findByIdsUseSet(Set<Integer> set);
  ~~~

  ~~~xml
  <!--使用Set集合的方式传递参数-->
  <select id="findByIdsUseSet" parameterType="collection" resultType="mybatisUser">
      select * from user
      <where>
          <foreach collection="collection" open=" and id in (" close=")" item="id" separator=",">
              #{id}
          </foreach>
      </where>
  </select>
  ~~~

  ```java
  //测试使用Set集合方式传递参数
  @Test
  public void testFindByIdsUseSet(){
      Set<Integer> set = new HashSet<>();
      set.add(1);
      set.add(2);
      List<MybatisUser> users = userMapper.findByIdsUseSet(set);
      for (MybatisUser user : users) {
          System.out.println(user);
      }
  }
  ```

  ​	使用Set集合方式的，paramterType可以为“collection”或者“java.util.Set”

* **使用Array数组方式传递参数**

  ~~~java
  // 使用Array数组的方式传递参数
  List<MybatisUser> findByIdsUseArray(Integer[] intArr);
  
  //使用Array数组的方式传递参数,String[]
  List<MybatisUser> findByIdsUseArrayString(String[] strArr);
  ~~~

  ```xml
  <!--使用Array数组的方式传递参数-->
  <select id="findByIdsUseArray" parameterType="int[]" resultType="mybatisUser">
      select * from user
      <where>
          <foreach collection="array" open=" and id in (" close=")" item="id" separator=",">
              #{id}
          </foreach>
      </where>
  </select>
  
  <!--使用Array集合的方式传递参数,String[]-->
  <select id="findByIdsUseArrayString" parameterType="object[]" resultType="mybatisUser">
          select * from user
          <where>
              <foreach collection="array" open=" and username in (" close=")" item="id" separator=",">
                  #{id}
              </foreach>
          </where>
      </select>
  ```

  ```java
  // 测试使用Array数组的方式传递参数
  @Test
  public void testFindByIdsUseArray(){
      Integer[] intarra = new Integer[2];
      intarra[0] = 1;
      intarra[1] = 2;
      List<MybatisUser> users = userMapper.findByIdsUseArray(intarra);
      for (MybatisUser user : users) {
          System.out.println(user);
      }
  }
  
  @Test
      public void testFindByIdsUseArrayString(){
          String[] strArr = new String[2];
          strArr[0] = "张三";
          strArr[1] = "tom";
          List<MybatisUser> users = userMapper.findByIdsUseArrayString(strArr);
          for (MybatisUser user : users) {
              System.out.println(user);
          }
      }
  ```

* 小结

  实际使用发现，有些方式paramterType参数可不需要填写（实际使用确实不需要，但是未经源码代码证实，为啥不需要）

  从下图MyBatis源码可以看出：

  * 当传入时List集合时，mybatis会将list集合对象，以“list”为key，存放到map中。在获取list的引用时，通过collection="list"来获取list对象。parameterType="list"

  * 当传入时Set集合时，mybatis会将Sett集合对象，以“collection”为key，存放到map中。在获取list的引用时，通过collection="collection"来获取Set集合对象。

    传递的是Integer数组对象时，parameterType="int[]"或者parameterType="Integer[]"

    同理String数组对象，parameterType="string[]"

  * 当传入时Array数组时，mybatis会将Array数组，以“array"为key，存放到map中，在获取Array数组的引用时，通过collection="array”来获取Array数组对象。

![image-20200605170859506](..\img-folder\image-20200605170859506.png)





**7) 使用java bean传递参数**

​        也可以使用bean的方式来传递多个参数，使用时parameterType指定为对应的bean类型即可，这种传参方式的优点是比较方便，controller层使用@RequestBody接收到实体类参数后，直接传递给mapper层调用即可，不需要在进行参数的转换。

~~~java
    //使用JavaBean传参
    void updatePasswordById(MybatisUser user);
~~~

~~~xml
    <!-- 使用JavaBean传参 update user -->
    <update id="updatePasswordById" parameterType="MybatisUser">
        update user set password = #{password} where id = #{id}
    </update>
~~~

~~~java
    //测试使用JavaBean传参
    @Test
    public void testUpdatePasswordById(){
        MybatisUser user = new MybatisUser();
        user.setId(3);
        user.setPassword("321");
        userMapper.updatePasswordById(user);
        sqlSession.commit();
    }
~~~



**8）参数类型为JavaBean中含有JaveBean、集合、数组等方式传参）**

~~~java
    // 用JaveBean中含有JavaBean、List等的方式传参
    List<MybatisUser> findByPasswordsUseJavaBeanObject(ParamBeanObject paramBeanObject);
~~~

~~~xml
    <!-- 使用JaveBean中含有JavaBean、List等的方式传参 -->
    <select id="findByPasswordsUseJavaBeanObject" parameterType="com.daonian.practice.mybatis.pojo.ParamBeanObject" resultType="mybatisUser">
        select * from user 
        <where>
            <foreach collection="passwords" open=" password in (" close=")" separator="," item="password">
                #{password}
            </foreach>

            and id = #{mybatisUser.id}
        </where>
    </select>
~~~

~~~java
    // 测试使用JaveBean含有List的方式传参
    @Test
    public void testFindByPasswordsUseJavaBeanObject(){
        ParamBeanObject paramBeanObject = new ParamBeanObject();

        List<String> list = new ArrayList<>(Arrays.asList("123","321","12"));
        paramBeanObject.setPasswords(list);

        MybatisUser mybatisUser = new MybatisUser();
        mybatisUser.setId(1);
        paramBeanObject.setMybatisUser(mybatisUser);

        List<MybatisUser> mybatisUsers = userMapper.findByPasswordsUseJavaBeanObject(paramBeanObject);
        for (MybatisUser user : mybatisUsers) {
            System.out.println(user);
        }
    }
~~~



##### 5.2.2.4 返回结果类型

MyBatis的返回参数类型分两种:<resultType>、<resultMap>

对应的返回值类型

1）resultMap：自定义结果集

2）resultType：int、string、long、对象实体、java.util.Map、...

​	resultMap是Mybatis一个强大的标签，它可以将查询到的复杂数据（比如查询到几个表中数据）映射到一个结果集当中。(具体使用见一对一、一对多、多对多查询)

在MyBatis进行查询映射时，其实查询出来的每一个属性都是放在一个对应的Map里面的，其中键是属性名，值则是其对应的值。
（1）当提供的返回类型属性是resultType时，MyBatis会将Map里面的键值对取出赋给resultType所指定的对象对应的属性。所以其实MyBatis的每一个查询映射的返回类型都是Map，只是当提供的返回类型属性是resultType的时候，MyBatis自动地把对应的值赋给resultType所指定对象的属性。
（2） 当提供的返回类型是resultMap时，因为Map不能很好表示领域模型，就需要自己再进一步的把它转化为对应的对象，这常常在复杂查询中很有作用。

​	resultMap包含的元素

```xml
<!--column不做限制，可以为任意表的字段，而property须为type 定义的pojo属性-->
<resultMap id="唯一的标识" type="映射的pojo对象">
  <id column="表的主键字段" jdbcType="字段类型" property="映射pojo对象的主键属性" />
  <result column="表的一个字段" jdbcType="字段类型" property="映射到pojo对象的一个属性"/>
  <association property="pojo的一个对象属性" javaType="pojo关联的pojo对象">
    <id column="关联pojo对象对应表的主键字段" jdbcType="字段类型" property="关联pojo对象的属性"/>
    <result column="表的一个字段" jdbcType="字段类型" property="关联pojo对象的属性"/>
  </association>
  <!-- 集合中的property须为oftype定义的pojo对象的属性-->
  <collection property="pojo的集合属性" ofType="集合中的pojo对象">
    <id column="集合中pojo对象对应的表的主键字段" jdbcType="字段类型" property="集合中pojo对象的主键属性" />
    <result column="表的一个字段" jdbcType="字段类型" property="集合中的pojo对象的属性" />  
  </collection>
</resultMap>
```

**如果collection标签是使用嵌套查询，格式如下：**

```xml
 <collection column="传递给嵌套查询语句的字段参数" property="pojo对象中集合属性" ofType="集合属性中的pojo对象" select="嵌套的查询语句" > 
 </collection>
```

注意：<collection>标签中的column：要传递给select查询语句的参数，如果传递多个参数，格式为column= ” {参数名1=表字段1,参数名2=表字段2}"



##### 5.2.2.5 **SQL片段抽取**

可以使用<sql> 标签，将重复的sql提取出来，使用时用include引用即可，最终达到复用sql的目的。

~~~xml
    <!--提取可复用的sql片段-->
    <sql id="selectUser">select * from user</sql>

    <!-- 使用JaveBean中含有JavaBean、List等的方式传参 -->
    <select id="findByPasswordsUseJavaBeanObject" parameterType="com.daonian.practice.mybatis.pojo.ParamBeanObject" resultType="mybatisUser">
        <!--引用sql片段-->
        <include refid="selectUser"/>
        <where>
            <foreach collection="passwords" open=" password in (" close=")" separator="," item="password">
                #{password}
            </foreach>

            and id = #{mybatisUser.id}
        </where>
    </select>
~~~









## 第六部分 Mybatis复杂映射开发

### 6.1 一对一查询

### 6.2 一对多查询

### 6.3 多对多查询











#### 7、Mybatis输入参数类型和结果类型

#### 8、Mybatis连接池和事务控制

#### 9、Mybatis入门级CRUD操作

#### 10、Mybatis动态SQL

#### 11、Mybatis多表关联查询

#### 12、Mybatis的注解开发

#### 13、Mybatis延迟加载策略

#### 14、Mybatis缓存

#### 15、Tomcat配置JNDI数据源

## 四、扩展知识

#### 1、元数据

####  2、Mybatis源码中的设计模式







