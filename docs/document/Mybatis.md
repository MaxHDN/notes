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

### 6.1 多表关系分析技巧

**从一条记录出发**，比如分析A表和B表的关系，就看A表的一条记录可以对应B表中几条记录，如果对应一条，从A到B表就是**一对一**的关系，如果对应多条就是**一对多**的关系。**多对多**其实是双向的一对多。

* 一对一

  从订单表出发到用户表，一条订单记录只会对应用户表的一条记录，一对一

* 一对多

  从用户表出发到订单表，一个用户记录可以对应订单表的多条记录，一对多

  （通过**主外键**，一的一方是主表，多的一方是从表，外键在从表多的那一方）

* 多对多

  用户和角色，一个用户可以有多个角色，一个角色也可以对应多个用户

  通过中间表(用户角色关系表)表达两个表之间的关系

  a表         b表

  id field..    id field..

  中间表（往往两个字段即可）

  aid  bid

### 6.2 准备环境

**核心配置文件，sqlMapperConfig.xml**

~~~xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <properties resource="com/daonian/practice/mybatis/mybatisJdbc.properties"/>

    <typeAliases>
        <!-- type：给类定义别名，alias：别名名称-->
        <typeAlias type="com.daonian.practice.mybatis.pojo.MybatisUser" alias="MybatisUser"/>
        <typeAlias type="com.daonian.practice.mybatis.pojo.Order" alias="order"/>
    </typeAliases>

    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"></transactionManager>
            <dataSource type="POOLED">
                <property name="driver" value="${jdbc.driver}"/>
                <property name="url" value="${jdbc.url}"/>
                <property name="username" value="${jdbc.username}"/>
                <property name="password" value="${jdbc.password}"/>
            </dataSource>
        </environment>
    </environments>

    <!-- 引入mapper.xml -->
    <mappers>
        <!-- mapper标签引入单个sql语句配置文件-->
        <mapper resource = "com/daonian/practice/mybatis/dao/quickStartMapper.xml"/>
        <mapper resource = "com/daonian/practice/mybatis/dao/TraditionIUserMapper.xml"/>
        <!--<mapper resource = "practice/mybatis/mapper/IUserMapper.xml"/>-->
        <!--package标签通过name属性指定mapper接口所在的包名，一次引入整个包的sql语句标签-->
        <package name="com/daonian/practice/mybatis/mapper"/>
    </mappers>

</configuration>
~~~



**用户实体类MybatisUser**

~~~java
package com.daonian.practice.mybatis.pojo;

import java.util.Date;
import java.util.List;

public class MybatisUser {
    private int id;
    private String username;
    private String password;
    private Date birthday;

    private List<Order> orderList;

    private List<Role> roleList;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public List<Order> getOrderList() {
        return orderList;
    }

    public void setOrderList(List<Order> orderList) {
        this.orderList = orderList;
    }

    public List<Role> getRoleList() {
        return roleList;
    }

    public void setRoleList(List<Role> roleList) {
        this.roleList = roleList;
    }

    @Override
    public String toString() {
        return "MybatisUser{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", birthday=" + birthday +
                ", orderList=" + orderList +
                ", roleList=" + roleList +
                '}';
    }
}
~~~

**订单实体类，Order**

~~~java
package com.daonian.practice.mybatis.pojo;

import java.util.Date;

public class Order {
    private int id;
    private Date ordertime;
    private Double total;
    private int uid;

    private MybatisUser user;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getOrdertime() {
        return ordertime;
    }

    public void setOrdertime(Date ordertime) {
        this.ordertime = ordertime;
    }

    public Double getTotal() {
        return total;
    }

    public void setTotal(Double total) {
        this.total = total;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public MybatisUser getUser() {
        return user;
    }

    public void setUser(MybatisUser user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", ordertime=" + ordertime +
                ", total=" + total +
                ", uid=" + uid +
                ", user=" + user +
                '}';
    }
}
~~~

角色实体类

~~~java
package com.daonian.practice.mybatis.pojo;

public class Role {
    private int id;
    private String rolename;
    private String roleDesc;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRolename() {
        return rolename;
    }

    public void setRolename(String rolename) {
        this.rolename = rolename;
    }

    public String getRoleDesc() {
        return roleDesc;
    }

    public void setRoleDesc(String roleDesc) {
        this.roleDesc = roleDesc;
    }

    @Override
    public String toString() {
        return "Role{" +
                "id=" + id +
                ", rolename='" + rolename + '\'' +
                ", roleDesc='" + roleDesc + '\'' +
                '}';
    }
}
~~~

**sql脚本**

~~~mysql
-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `birthday` date NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, '张三', '123', '2020-12-11');
INSERT INTO `user` VALUES (2, 'tom', '123', '2020-11-12');

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordertime` date NULL DEFAULT NULL,
  `total` double NULL DEFAULT NULL,
  `uid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, '2019-12-12', 3000, 1);
INSERT INTO `orders` VALUES (2, '2019-12-12', 4000, 1);
INSERT INTO `orders` VALUES (3, '2019-12-12', 5000, 2);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rolename` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `roleDesc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, 'CTO', 'CTO');
INSERT INTO `sys_role` VALUES (2, 'CEO', 'CEO');


-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `userid` int(11) NOT NULL,
  `roleid` int(11) NOT NULL,
  PRIMARY KEY (`userid`, `roleid`) USING BTREE,
  INDEX `roleid`(`roleid`) USING BTREE,
  CONSTRAINT `sys_user_role_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `sys_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `sys_user_role_ibfk_2` FOREIGN KEY (`roleid`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 1);
INSERT INTO `sys_user_role` VALUES (1, 2);
INSERT INTO `sys_user_role` VALUES (2, 2);
~~~



### 6.3 一对一查询

一对一查询模型：用户表和订单表的关系为，一个用户有多个订单，一个订单只从属于一个用户

一对一查询需求：查询订单，同时查询订单所属的用户信息

~~~java
    // mapper接口
	// 一对一查询，一个订单只从属于一个用户
    // 需求：查询订单，同时查询订单所属的用户信息
    // 跟下面的区别是，sql语句配置文件中使用的resltMap不同
    List<Order> findOrderAndUser2();

    // 一对一查询，一个订单只从属于一个用户。
    // 需求：查询订单，同时查询订单所属的用户信息
    List<Order> findOrderAndUser();
~~~

~~~xml
    <!--sql语句配置文件,xxxMapper.xml-->
	
    <!-- id="orderMap" 和 id="orderMap2"两个效果是一样的-->
    <resultMap id="orderMap2" type="order">
        <result column="id" property="id"></result>
        <result column="ordertime" property="ordertime"></result>
        <result column="total" property="total"></result>
        <result column="uid" property="id"></result>
        <association property="user" javaType="MybatisUser">
            <result column="uid" property="id"></result>
            <result column="username" property="username"></result>
            <result column="password" property="password"></result>
            <result column="birthday" property="birthday"></result>
        </association>
    </resultMap>

    <resultMap id="orderMap2" type="order">
        <result column="id" property="id"></result>
        <result column="ordertime" property="ordertime"></result>
        <result column="total" property="total"></result>
        <result column="uid" property="id"></result>
        <association property="user" javaType="MybatisUser">
            <result column="uid" property="id"></result>
            <result column="username" property="username"></result>
            <result column="password" property="password"></result>
            <result column="birthday" property="birthday"></result>
        </association>
    </resultMap>
	
	<!--select id="findOrderAndUser" 和 id="findOrderAndUser2" resultMap不同-->
    <select id="findOrderAndUser2" resultMap="orderMap2">
        select
             o.id,
             o.ordertime,
             o.total,
             o.uid,
             u.username,
             u.password,
             u.birthday
        from
            orders o, user u
        where
            o.uid = u.id
    </select>

    <select id="findOrderAndUser" resultMap="orderMap">
        select
             o.id,
             o.ordertime,
             o.total,
             o.uid,
             u.username,
             u.password,
             u.birthday
        from
            orders o, user u
        where
            o.uid = u.id
    </select>
~~~

~~~java
	// 测试代码    
	@Test
    public void testFindOrderAndUser2() {
        List<Order> allOrders = orderMapper.findOrderAndUser2();
        for (Order order : allOrders) {
            System.out.println(order);
        }
    }

    @Test
    public void testFindOrderAndUser() {
        List<Order> allOrders = orderMapper.findOrderAndUser();
        for (Order order : allOrders) {
            System.out.println(order);
        }
    }
~~~

### 6.4 一对多查询

一对多查询模型：用户表和订单表的关系为，一个用户有多个订单，一个订单只从属一个用户

一对多查询需求：查询用户，于此同时查询用户所有的订单

~~~java
	//mapper接口    
	//一对多查询，一个用户对应多个订单。
	//需求：查询用户，于此同时查询用户所有的订单
    List<MybatisUser> findAllUserAndOrders();
~~~

~~~xml
	<!--sql语句配置文件，xxxMapper.xml-->
	<resultMap id="userMap" type="MybatisUser">
        <result column="id" property="id"></result>
        <result column="username" property="username"></result>
        <result column="password" property="password"></result>
        <result column="birthday" property="birthday"></result>
        <collection property="orderList" ofType="order">
            <result column="oid" property="id"></result>
            <result column="ordertime" property="ordertime"></result>
            <result column="total" property="total"></result>
        </collection>
    </resultMap>    

	<select id="findAllUserAndOrders" resultMap="userMap">
        select
            u.id,
            u.username,
            u.password,
            u.birthday,
            o.id oid,
            o.ordertime,
            o.total
        from
            user u
            left join orders o on u.id = o.uid;
    </select>
~~~

~~~java
    // 测试代码
	@Test
    public void testFindAllUserAndOrders() {
        List<MybatisUser> allUsers = orderMapper.findAllUserAndOrders();
        for (MybatisUser allUser : allUsers) {
            System.out.println(allUser);
        }
    }
~~~



### 6.5 多对多查询

多对多查询模型：用户表和角色表的关系为，一个用户有多个角色，一个角色有多个用户

多对多查询需求：查询用户，同时查询用户所有的角色。

~~~java
	//mapper接口
    //多对多查询，一个用户对应多个角色，一个角色对应多个用户，需求查询用户的同时查询出该用户的所有角色
    List<MybatisUser> findAlluserAndRole();
~~~

~~~xml
    <!--sql语句配置文件，xxxMapper.xml-->
    <resultMap id="userRole" type="MybatisUser">
        <result column="id" property="id"></result>
        <result column="username" property="username"></result>
        <result column="password" property="password"></result>
        <result column="birthday" property="birthday"></result>
        <collection property="roleList" ofType="com.daonian.practice.mybatis.pojo.Role">
            <result column="rid" property="id"></result>
            <result column="rolename" property="rolename"></result>
            <result column="roleDesc" property="roleDesc"></result>
        </collection>
    </resultMap>
    <select id="findAlluserAndRole" resultMap="userRole">
        SELECT
            u.id,
            u.username,
            u.PASSWORD,
            u.birthday,
            r.id rid,
            r.rolename,
            r.roleDesc
        FROM
            USER u
            LEFT JOIN sys_user_role ur ON u.id = ur.userid
            INNER JOIN sys_role r ON ur.roleid = r.id
    </select>
~~~

~~~java
    // 测试代码
	@Test
    public void testFindAlluserAndRole() {
        List<MybatisUser> allUsers = orderMapper.findAlluserAndRole();
        for (MybatisUser allUser : allUsers) {
            System.out.println(allUser);
        }
    }
~~~





## 第七部分 Mybatis的注解开发

###  7.1 Mybatis常用注解

 MyBatis也可以用注解的方式开发，这样就可以不用写Mapper映射文件了。

**常用的注解**

| 注解     | 描述                                  |
| -------- | ------------------------------------- |
| @Insert  | 向数据库插入记录                      |
| @Update  | 更新数据库中的记录                    |
| @Delete  | 删除数据库中的记录                    |
| @Select  | 向数据库查询记录                      |
| @Result  | 实现结果集的封装                      |
| @Results | 可以与@Result一起使用，封装多个结果集 |
| @One     | 实现一对一结果集的封装                |
| @Many    | 实现一对多结果集的封装                |

### 7.2 Mybatis增删改查

 简单的增删改查

~~~java
    // mapper接口
	@Select("select id,username,password,birthday from user")
    List<MybatisUser> findAllUseAnnotation();

    @Delete("delete from user where id = #{id}")
    int deleteUserByIdUseAnnotaion(int id);

    @Update("update user set password=#{password} where id = #{id} ")
    int updateUserByIdUseAnnotation(MybatisUser mybatisUser);

    @Insert("insert into user (id,username,password,birthday) values (#{id},#{username},#{password},#{birthday})")
    int insertUserUseAnnotation(MybatisUser user);
~~~

~~~java
// 测试代码
    @Test
    public void testFindAllUseAnnotation(){
        List<MybatisUser> allUser = userMapper.findAllUseAnnotation();
        for (MybatisUser mybatisUser : allUser) {
            System.out.println(mybatisUser);
        }
    }

    @Test
    public void testDeleteUserByIdUseAnnotaion(){
        int deleteCount = userMapper.deleteUserByIdUseAnnotaion(3);
        sqlSession.commit();
        System.out.println(deleteCount);
    }

    @Test
    public void testUpdateUserByIdUseAnnotation(){
        MybatisUser mybatisUser = new MybatisUser();
        mybatisUser.setId(3);
        mybatisUser.setPassword("321");
        int updateCount = userMapper.updateUserByIdUseAnnotation(mybatisUser);
        sqlSession.commit();
        System.out.println(updateCount);
    }

    @Test
    public void testInsertUseAnnotation(){
        MybatisUser mybatisUser = new MybatisUser();
        mybatisUser.setId(3);
        mybatisUser.setUsername("lisi");
        mybatisUser.setPassword("123");
        mybatisUser.setBirthday(new Date());
        int insertCount = userMapper.insertUserUseAnnotation(mybatisUser);
        System.out.println(insertCount);
        sqlSession.commit();
    }
~~~

### 7.3 Mybatis注解实现复杂映射开发

参考资料：[@Results用法总结](https://blog.csdn.net/cherlshall/article/details/80950150)

#### 7.3.1 基于注解的一对一查询

IOrderMapper.java

~~~java
    // 使用注解 一对一查询，需求：查询订单，于此同时查询订单所属的用户
    @Select("select id,ordertime,total,uid from orders")
    @Results({
            @Result(column = "id",property = "id"),
            @Result(column = "ordertime",property = "ordertime"),
            @Result(column = "total",property = "total"),
            @Result(column = "uid",property = "uid"),
            @Result(column = "uid",property = "user",
                    javaType = MybatisUser.class,
                    one = @One(select = "com.daonian.practice.mybatis.mapper.IUserMapper.findById"))

    })
    List<Order> findOrderAndUserUseAnnotation();
~~~

IUserMapper.java

~~~java
    @Select("select id,username,password,birthday from user where id = #{id}")
    MybatisUser findById(int id);
~~~

测试代码

~~~java
    // 使用注解 一对一查询，需求：查询订单，于此同时查询订单所属的用户
    @Test
    public void testFindOrderAndUserUseAnnotation(){
        List<Order>  orderList = orderMapper.findOrderAndUserUseAnnotation();
        for (Order order : orderList) {
            System.out.println(order);
        }
    }
~~~



#### 7.3.2 基于注解的一对多查询

##### 7.3.2.1 传递单个参数

IUserMapper.java

~~~java
    // 使用注解 一对多查询，需求：查询用户，于此同时查询用户的所有订单
    @Select("select id,username,password,birthday from user")
    @Results({
            @Result(column = "id",property = "id"),
            @Result(column = "username",property = "username"),
            @Result(column = "password",property = "password"),
            @Result(column = "birthday",property = "birthday"),
            @Result(column = "id",property = "orderList",javaType = List.class,
                    many=@Many(select="com.daonian.practice.mybatis.mapper.IOrderMapper.findOrderById"))
    })
    List<MybatisUser> findUserAndOrdersUseAnnotation();
~~~

IOrderMapper.java

~~~java
    // 根据id查询订单
    @Select("select id,ordertime,total,uid from orders where id = #{id} and total = #{total}" )
    List<Order> findOrderByIdAndTotal(@Param("id") int id,@Param("total") double total);
~~~

测试代码

~~~java
    // 使用注解 一对多查询，需求：查询用户，于此同时查询用户的所有订单
    @Test
    public void testFindUserAndOrdersUseAnnotation(){
        List<MybatisUser> mybatisUsers = userMapper.findUserAndOrdersUseAnnotation();
        for (MybatisUser mybatisUser : mybatisUsers) {
            System.out.println(mybatisUser);
        }
    }

~~~

##### 7.3.2.2 传递多个参数

IUserMapper.java

~~~java
    //使用注解，一对多查询，传递多个参数。需求：查询用户，于此同时查询用户的所有角色。
    // 下面"id=id,total=id"是传递多个值给查询订单的接口，等号左边表示订单接口的@Param里的值，
    // 右边表示数据库里的值（select id,username,password,birthday from user），由于数据库中没有total字段
    // 使用id代替。如果有total的值，应该是"id=id,total=total"
    //订单接口List<Order> findOrderByIdAndTotal(@Param("id") int id,@Param("total") double total);
    @Select("select id,username,password,birthday from user")
    @Results({
            @Result(column = "id",property = "id"),
            @Result(column = "username",property = "username"),
            @Result(column = "password",property = "password"),
            @Result(column = "birthday",property = "birthday"),
            @Result(column = "id=id,total=id",property = "orderList",javaType = List.class,
                   many=@Many(select = "com.daonian.practice.mybatis.mapper.IOrderMapper.findOrderByIdAndTotal"))
    })
    List<MybatisUser> findUserAndOrdersUseAnnotationTTwoParam();
~~~

IOrderMapper.java

~~~java
    // 根据id查询订单
    @Select("select id,ordertime,total,uid from orders where id = #{id} and total = #{total}" )
    List<Order> findOrderByIdAndTotal(@Param("id") int id,@Param("total") double total);
~~~

测试代码

~~~java
    //使用注解，一对多查询，传递多个参数。需求：查询用户，于此同时查询用户的所有角色。
    @Test
    public void testFindUserAndOrdersUseAnnotationTTwoParam(){
        List<MybatisUser> mybatisUsers = userMapper.findUserAndOrdersUseAnnotationTTwoParam();
        for (MybatisUser mybatisUser : mybatisUsers) {
            System.out.println(mybatisUser);
        }
    }
~~~



#### 7.3.3 基于注解的多对多查询

IUserMapper.java

~~~java
    // 使用注解，多对多查询，需求：查询用户，于此同时查询用户的所有角色
    @Select("select id,username,password,birthday from user")
    @Results({
            @Result(column = "id", property = "id"),
            @Result(column = "username", property = "username"),
            @Result(column = "password", property = "password"),
            @Result(column = "birthday", property = "birthday"),
            @Result(column = "id",property = "roleList",javaType = List.class,
                    many=@Many(select="com.daonian.practice.mybatis.mapper.IRoleMapper.findRoleByUserIdUseAnnotaion"))
    })
    List<MybatisUser> findUserAndRoleUseAnnotaion();
~~~

IRoleMapper.java

~~~java
    // 根据用户id，查询用户所有角色
    @Select("select r.id,r.rolename,r.roleDesc from sys_user_role ur inner join sys_role r on ur.roleid = r.id where ur.userid = #{userid}")
    List<Role> findRoleByUserIdUseAnnotaion(int userid);
~~~

测试代码

~~~java
    // 使用注解，多对多查询，需求：查询用户，于此同时查询用户的所有角色
    @Test
    public void testFindUserAndRoleUseAnnotaion(){
        List<MybatisUser> mybatisUsers = userMapper.findUserAndRoleUseAnnotaion();
        for (MybatisUser mybatisUser : mybatisUsers) {
            System.out.println(mybatisUser);
        }
    }
~~~

## 第八部分 Mybatis缓存

### 8.1 Mybatis缓存是什么

​		mybatis缓存就是将从数据库查询返回的数据存放到内存中，一般的ORM 框架都会提供的功能，避免频繁与数据库交互，目的就是提升查询的效率、减少数据库的压力和提高响应速度。跟Hibernate 一样，MyBatis 也有一级缓存和二级缓存，并且预留了集成第三方缓存的接口。**mybatis缓存体系**：

![image-20200607142500225](..\img-folder\image-20200607142500225.png)

​		MyBatis 跟缓存相关的类都在cache 包里面，其中有一个Cache 接口，只有一个默认的实现类 PerpetualCache，它是用HashMap 实现的。我们可以通过以下类找到PerpetualCache缓存。

**DefaultSqlSession**

​					-> **BaseExecutor**

​									-> **PerpetualCache** localCache

​														->	**private Map<Object, Object> cache = new HashMap();**																	

![image-20200607142856540](..\img-folder\image-20200607142856540.png)

![image-20200607142923203](..\img-folder\image-20200607142923203.png)

![image-20200607143031263](..\img-folder\image-20200607143031263.png)

​		除此之外，在decorators包中还有很多的装饰器类，通过这些装饰器类可以额外实现很多的功能：回收策略、日志记录、定时刷新等等。但是无论怎么装饰，经过多少层装饰，最后使用的还是基本的实现类（默认PerpetualCache）。

![img](..\img-folder\1383365-20190628165835198-1731504252.png)

​		所有的缓存实现类总体上可分为三类：基本缓存、淘汰算法缓存、装饰器缓存。![img](..\img-folder\1383365-20190628172253737-1751427739.png)

### 8.2一级缓存

#### 8.2.1 一级缓存是什么

​		　一级缓存也叫本地缓存，MyBatis 的**一级缓存是在会话（SqlSession）层面进行缓存的**。MyBatis 的**一级缓存是默认开启**的，不需要任何的配置。首先我们必须去弄清楚一个问题，在MyBatis 执行的流程里面，涉及到这么多的对象，那么缓存PerpetualCache 应该放在哪个对象里面去维护？如果要在同一个会话里面共享一级缓存，这个对象肯定是在SqlSession 里面创建的，作为SqlSession 的一个属性。

　　DefaultSqlSession 里面只有两个属性，Configuration 是全局的，所以缓存只可能放在Executor 里面维护——SimpleExecutor/ReuseExecutor/BatchExecutor 的父类BaseExecutor 的构造函数中持有了PerpetualCache。**在同一个会话里面，多次执行相同的SQL 语句，会直接从内存取到缓存的结果，不会再发送SQL 到数据库。但是不同的会话里面，即使执行的SQL 一模一样（通过一个Mapper 的同一个方法的相同参数调用），也不能使用到一级缓存**。

　　每当我们使用MyBatis开启一次和数据库的会话，MyBatis会创建出一个SqlSession对象表示一次数据库会话。在对数据库的一次会话中，我们有可能会反复地执行完全相同的查询语句，如果不采取一些措施的话，每一次查询都会查询一次数据库,而我们在极短的时间内做了完全相同的查询，那么它们的结果极有可能完全相同，由于查询一次数据库的代价很大，这有可能造成很大的资源浪费。

　　为了解决这一问题，减少资源的浪费，MyBatis会在表示会话的SqlSession对象中建立一个简单的缓存，将每次查询到的结果结果缓存起来，当下次查询的时候，如果判断先前有个完全一样的查询，会直接从缓存中直接将结果取出，返回给用户，不需要再进行一次数据库查询了。

　　如下图所示，MyBatis会在一次会话的表示----一个SqlSession对象中创建一个本地缓存(local cache)，对于每一次查询，都会尝试根据查询的条件去本地缓存中查找是否在缓存中，如果在缓存中，就直接从缓存中取出，然后返回给用户；否则，从数据库读取数据，将查询结果存入缓存并返回给用户。

![image-20200607144244158](..\img-folder\image-20200607144244158.png)

#### 8.2.2 一级缓存的生命周期

一级缓存的生命周期有多长？

* MyBatis在开启一个数据库会话时，会创建一个新的SqlSession对象，SqlSession对象中会有一个新的Executor对象，Executor对象中持有一个新的PerpetualCache对象；当会话结束时，SqlSession对象及其内部的Executor对象还有PerpetualCache对象也一并释放掉。

* 如果SqlSession调用了close()方法，会释放掉一级缓存PerpetualCache对象，一级缓存将不可用；

* 如果SqlSession调用了clearCache()，会清空PerpetualCache对象中的数据，但是该对象仍可使用；

* SqlSession中执行了任何一个update操作(update()、delete()、insert()) ，都会清空PerpetualCache对象的数据，但是该对象可以继续使用；

SqlSession 一级缓存的工作流程：

​	1）对于某个查询，根据statementId,params,rowBounds来构建一个key值，根据这个key值去缓存Cache中取出对应的key值存储的缓存结果

​	2）判断从Cache中根据特定的key值取的数据数据是否为空，即是否命中；

​		①如果命中，则直接将缓存结果返回；

​		②如果没命中：

​			Ⅰ. 去数据库中查询数据，得到查询结果；

​			Ⅱ. 将key和查询到的结果分别作为key,value对存储到Cache中；

​			Ⅲ. 将查询结果返回；

　　**接下来我们来验证一下**，MyBatis 的一级缓存到底是不是只能在一个会话里面共享，以及跨会话（不同session）相同的操作会产生什么问题，判断是否命中缓存方法是，第二次查询如果发送SQL 到数据库执行，说明没有命中缓存；如果直接打印对象，说明是从内存缓存中取到了结果。

~~~xml
    <!--sql语句配置文件-->
	<!--find all-->
    <select id="findAll" resultType="MybatisUser">
        select id,username,password from user
    </select>
~~~

```java
	// 查询所有
	List<MybatisUser> findAll();
```

```java
    // 测试代码，同一个sqlSession对象，发送两次请求。不同sqlSession会话对象，相同请求。
    @Test
    public void testFirstLevelCache() {
        List<MybatisUser> first = userMapper.findAll();
        for (MybatisUser user : first) {
            System.out.println("打印第一次返回结果：" + user);
        }

        // 第二次查询，同一个sqlSession对象执行与第一次相同的查询，观察是否走缓存
        List<MybatisUser> second = userMapper.findAll();
        for (MybatisUser user : second) {
            System.out.println("打印第二次查询结果：" + user);
        }

        // 新创建一个sqlSession会话对象查询，发送相同的请求
        SqlSession newSqlSession = sqlSessionFactory.openSession();
        IUserMapper mapper = newSqlSession.getMapper(IUserMapper.class);
        List<MybatisUser> all = mapper.findAll();
        for (MybatisUser mybatisUser : all) {
            System.out.println("不同sqlSession会话对象打印结果：" + mybatisUser);
        }

        sqlSession.close();
        newSqlSession.close();

    }
```

测试结果

![image-20200607150925023](..\img-folder\image-20200607150925023.png)![image-20200607152745487](..\img-folder\image-20200607152745487.png)



从测试结果可以看出：

​		① 同一个sqlSession对象，第二次查询，直接将结果打印出来，没有发送sql到数据库执行返回结果，说明第二次查询直接到缓存中取数据了，使用了一级缓存。

​		② 新的会话对象newsqlSession，执行与sqlSession会话对象相同的查询，发送了sql到数据库查询结果返回打印，没有走缓存。说明不同的SqlSession会话对象一级换不是共享的。

​		③ newSqlSession会话对象更新数据后，sqlSession会话对象第三次查询时，获取的数据仍是第一次查询结果的缓存数据，并不是最新的数据。说明一级缓存有脏数据的问题，其他会话更新了数据，导致读取到脏数据。

#### 8.2.3 一级缓存的不足

　　使用一级缓存的时候，因为缓存不能跨会话共享，不同的会话之间对于相同的查询可能有不一样的缓存。在有多个会话或者分布式环境下，会存在脏数据的问题。MyBatis 一级缓存（MyBaits 称其为 Local Cache）默认开启，无法关闭，但是有两种级别可选：

​	① session 级别的缓存，在同一个 sqlSession 内，对同样的查询将不再查询数据库，直接从缓存中。

​	② statement 级别的缓存，避坑： 为了避免这个问题，可以将一级缓存的级别设为 statement 级别的，这样每次查询结束都会清掉一级缓存。

### 8.3 二级缓存

#### 8.3.1 二级缓存是什么

​		二级缓存是用来解决一级缓存不能**跨会话共享**的问题的，范围是namespace 级别的，**可以被多个SqlSession 共享**（只要是**同一个接口里面的相同方法**，都可以共享），**生命周期和应用同步**。如果你的MyBatis使用了二级缓存，并且你的Mapper和select语句也配置使用了二级缓存，那么在执行select查询的时候，MyBatis会先从二级缓存中取输入，其次才是一级缓存，即MyBatis查询数据的顺序是：二级缓存  —> 一级缓存 —> 数据库。

　　作为一个作用范围更广的缓存，它肯定是在SqlSession 的外层，否则不可能被多个SqlSession 共享。而一级缓存是在SqlSession 内部的，所以第一个问题，肯定是工作在一级缓存之前，也就是只有取不到二级缓存的情况下才到一个会话中去取一级缓存。第二个问题，二级缓存放在哪个对象中维护呢？ 要跨会话共享的话，SqlSession 本身和它里面的BaseExecutor 已经满足不了需求了，那我们应该在BaseExecutor 之外创建一个对象。

　　实际上MyBatis 用了一个装饰器的类来维护，就是CachingExecutor。如果启用了二级缓存，MyBatis 在创建Executor 对象的时候会对Executor 进行装饰。CachingExecutor 对于查询请求，会判断二级缓存是否有缓存结果，如果有就直接返回，如果没有委派交给真正的查询器Executor 实现类，比如SimpleExecutor 来执行查询，再走到一级缓存的流程。最后会把结果缓存起来，并且返回给用户。

![image-20200607154010228](..\img-folder\image-20200607154010228.png)

#### 8.3.2 开启二级缓存

和一级缓存默认开启不一样，二级缓存需要手动开启。

**首先**，在全局配置文件sqlMapConfig.xml文件中增加如下代码：

~~~xml
<!--开启二级缓存-->
<settings>
	<setting name="cacheEnabled" value="true"/>
</settings>
~~~

**其次**，在sql语句配置文件xxxMapper.xml中开启二级缓存

~~~
<!--开启二级缓存-->
<cache></cache>
~~~

xxxMapper.xml文件中的<cache>标签可以进行配置，PerpetualCache这个类是mybatis默认的实现缓存功能的类，不写type属性，就使用默认的缓存。可以定义实现cache接口的类作为缓存。

![image-20200607154947406](..\img-folder\image-20200607154947406.png)

![image-20200607155231691](..\img-folder\image-20200607155231691.png)

可以看到，二级缓存底层还是HashMap结构。

开启二级缓存后，还需要将缓存的pojo类实现Serializable接口，因为二级缓存数据存储介质多种多样，不一定只存在内中，有可能存在硬盘中，如果从硬盘中取话的就需要反序列化。



**具体的一个二级缓存配置**

~~~xml
<!--具体的一个配置-->
<cache type="org.apache.ibatis.cache.impl.PerpetualCache"
    size="1024"
eviction="LRU"
flushInterval="120000"
readOnly="false"/>
~~~

这个简单语句的效果如下:

- 映射语句文件中的所有 select 语句的结果将会被缓存。
- 映射语句文件中的所有 insert、update 和 delete 语句会刷新缓存。
- 缓存会使用最近最少使用算法（LRU, Least Recently Used）算法来清除不需要的缓存。
- 缓存不会定时进行刷新（也就是说，没有刷新间隔）。
- 缓存会保存列表或对象（无论查询方法返回哪种）的 1024 个引用。
- 缓存会被视为读/写缓存，这意味着获取到的对象并不是共享的，可以安全地被调用者修改，而不干扰其他调用者或线程所做的潜在修改。

这个更高级的配置创建了一个 FIFO 缓存，每隔 60 秒刷新，最多可以存储结果对象或列表的 512 个引用，而且返回的对象被认为是只读的，因此对它们进行修改可能会在不同线程中的调用者产生冲突。可用的清除策略有：

- `LRU` – 最近最少使用：移除最长时间不被使用的对象。
- `FIFO` – 先进先出：按对象进入缓存的顺序来移除它们。
- `SOFT` – 软引用：基于垃圾回收器状态和软引用规则移除对象。
- `WEAK` – 弱引用：更积极地基于垃圾收集器状态和弱引用规则移除对象。

默认的清除策略是 LRU。

flushInterval（刷新间隔）属性可以被设置为任意的正整数，设置的值应该是一个以毫秒为单位的合理时间量。 默认情况是不设置，也就是没有刷新间隔，缓存仅仅会在调用语句时刷新。

size（引用数目）属性可以被设置为任意正整数，要注意欲缓存对象的大小和运行环境中可用的内存资源。默认值是 1024。

readOnly（只读）属性可以被设置为 true 或 false。只读的缓存会给所有调用者返回缓存对象的相同实例。 因此这些对象不能被修改。这就提供了可观的性能提升。而可读写的缓存会（通过序列化）返回缓存对象的拷贝。 速度上会慢一些，但是更安全，因此默认值是 false。

　　注：**二级缓存是事务性的**。这意味着，当 SqlSession 完成并提交时，或是完成并回滚，但没有执行 flushCache=true 的 insert/delete/update 语句时，缓存会获得更新。

　　Mapper.xml 配置了<cache>之后，select()会被缓存。update()、delete()、insert()会刷新缓存。：如果cacheEnabled=true，Mapper.xml 没有配置标签，还有二级缓存吗？（没有），还会出现CachingExecutor 包装对象吗？（会）

　　只要cacheEnabled=true 基本执行器就会被装饰。有没有配置<cache>，决定了在启动的时候会不会创建这个mapper 的Cache 对象，只是最终会影响到CachingExecutorquery 方法里面的判断。**如果某些查询方法对数据的实时性要求很高**，不需要二级缓存，怎么办？我们**可以在单个Statement ID 上显式关闭二级缓存**（默认是true）：

~~~xml
<select id="findAll" resultMap="MybatisUser" useCache="false">
~~~



**useCache和flushCache**  

mybatis中还可以配置userCache和flushCache等配置项，userCache是用来设置是否禁用二级缓存的，在statement中设置**useCache=false**可以禁用当前select语句的二级缓存，即每次查询都会发出sq|去数据库查询，默认情况是true,即该sq|使用二级缓存

~~~xml
<select id= "selectUserByUserId" useCache= "false"
        resultType= "MybatisUser" parameterType="int">
    select * from user where id = #{id}
~~~

这种情况是针对每次查询都需要最新的数据sql,要设置成useCache=false,禁用二级缓存，直接从数据库中获取。

在mapper的同一个namespace中， 如果有其它insert、 update、 delete操作 数据后需要刷新缓存，如果不执行刷新缓存会出现脏读。

设置statement配置中的**flushCache="true"**属性，默认情况下为true,即刷新缓存，如果改成false则不会刷新。使用缓存时如果手动修改数据库表中的查询数据会出现脏读。

**二级缓存验证（验证二级缓存需要先开启二级缓存）**

~~~xml
    <!--开启二级缓存-->
    <settings>
        <setting name="cacheEnabled" value="true"/>
    </settings>
~~~

**① 验证跨SqlSession会话对象时，可以使用二级缓存**

~~~java
    List<MybatisUser> findAllTestTwoLevelCache();
~~~

~~~xml
    <!--开启二级缓存-->
    <cache></cache>

    <!--验证二级缓存-->
    <select id="findAllTestTwoLevelCache" resultType="MybatisUser">
        select id,username,password from user
    </select>
~~~

~~~java
    // 测试使用二级缓存的代码
    @Test
    public void testTowLevelCashe(){
        SqlSession newSqlSession = sqlSessionFactory.openSession();
        IUserMapper userMapper1 = newSqlSession.getMapper(IUserMapper.class);

        List<MybatisUser> first = userMapper.findAllTestTwoLevelCache();
        for (MybatisUser user : first) {
            System.out.println("打印sqlSession查询结果：" + user);
        }
        // 注意事务不提交的情况下，并没有将数据写入到二级缓存中，二级缓存时不存在的
        sqlSession.commit();

        List<MybatisUser> second = userMapper1.findAllTestTwoLevelCache();
        for (MybatisUser user : second) {
            System.out.println("打印newSqlSession查询结果：" + user);
        }

        // 关闭第一个sqlSession会话对象
        sqlSession.close();
        newSqlSession.close();

    }
~~~

测试结果

![image-20200607163336108](..\img-folder\image-20200607163336108.png)

从测试结果可以看出，第二次查询没有发送sql到数据执行取数据，直接打印出来，说明使用到了二级缓存。



**② 事务不提交二级缓存不存在**

​		二级缓存是事务性的。这意味着，当 SqlSession 完成并提交时，或是完成并回滚，但没有执行 flushCache=true 的 insert/delete/update 语句时，缓存会获得更新。否则数据不能会写入到二级缓存。

~~~java
    List<MybatisUser> findAllTestTwoLevelCache();
~~~

~~~xml
    <!--开启二级缓存-->
    <cache></cache>

    <!--验证二级缓存-->
    <select id="findAllTestTwoLevelCache" resultType="MybatisUser">
        select id,username,password from user
    </select>
~~~

~~~java
    // 测试使用二级缓存的代码
    @Test
    public void testTowLevelCashe(){
        SqlSession newSqlSession = sqlSessionFactory.openSession();
        IUserMapper userMapper1 = newSqlSession.getMapper(IUserMapper.class);

        List<MybatisUser> first = userMapper.findAllTestTwoLevelCache();
        for (MybatisUser user : first) {
            System.out.println("打印sqlSession查询结果：" + user);
        }
        // 注意事务不提交的情况下，并没有将数据写入到二级缓存中，二级缓存时不存在的
        //sqlSession.commit();

        List<MybatisUser> second = userMapper1.findAllTestTwoLevelCache();
        for (MybatisUser user : second) {
            System.out.println("打印newSqlSession查询结果：" + user);
        }

        // 关闭SqlSession会话对象
        sqlSession.close();
        newSqlSession.close();
    }
~~~

测试结果

![image-20200607164432801](..\img-folder\image-20200607164432801.png)

​		从测试结果可以看出，如果不提交的话，数据没有写入二级缓存中，其他的SqlSession对象相同的查询并没有从缓存中查询到数据。

​		为什么事务不提交，二级缓存不生效？因为二级缓存使用TransactionalCacheManager（TCM）来管理，最后又调用了TransactionalCache 的getObject()、putObject 和commit()方法，TransactionalCache里面又持有了真正的Cache 对象，比如是经过层层装饰的PerpetualCache。在putObject 的时候，只是添加到了entriesToAddOnCommit 里面，只有它的commit()方法被调用的时候才会调用flushPendingEntries()真正写入缓存。它就是在DefaultSqlSession 调用commit()的时候被调用的。

③ 验证在其他的SqlSession会话对象中执行增删改操作，缓存会被刷新

```java
List<MybatisUser> findAllTestTwoLevelCache();
```

```xml
<!--验证二级缓存-->
<select id="findAllTestTwoLevelCache" resultType="MybatisUser">
    select id,username,password from user
</select>
```

```java
@Test
public void testTowLevelCashe(){
    SqlSession newSqlSession = sqlSessionFactory.openSession();
    IUserMapper userMapper1 = newSqlSession.getMapper(IUserMapper.class);

    List<MybatisUser> first = userMapper.findAllTestTwoLevelCache();
    for (MybatisUser user : first) {
        System.out.println("打印sqlSession查询结果：" + user);
    }
    // 注意事务不提交的情况下，并没有将数据写入到二级缓存中，二级缓存时不存在的
    sqlSession.commit();

    // 验证在sqlSession会话对象，执行update、insert、delete操作会清空缓存
    MybatisUser mybatisUser = new MybatisUser();
    mybatisUser.setId(3);
    mybatisUser.setUsername("list");
    mybatisUser.setPassword("123");
    mybatisUser.setBirthday(new Date());
    userMapper.insertMybatisUser(mybatisUser);
    sqlSession.commit();

    // 由于缓存被清空，会发送sql到数据库去查询数据
    List<MybatisUser> second = userMapper1.findAllTestTwoLevelCache();
    for (MybatisUser user : second) {
        System.out.println("打印newSqlSession查询结果：" + user);
    }
    
    // 关闭第一个sqlSession会话对象
    sqlSession.close();
    newSqlSession.close();
}
```

测试结果

![image-20200607170804975](..\img-folder\image-20200607170804975.png)

​		从测试结果可以看出，当执行insert操作后，二级级换被清空了，后面的查询，需要到数据库查询数据。

​		为什么增删改操作会清空缓存？在CachingExecutor 的update()方法里面会调用flushCacheIfRequired(ms)，isFlushCacheRequired 就是从标签里面渠道的flushCache 的值。而增删改操作的flushCache 属性默认为true。

**什么时候开启二级缓存？**

​		一级缓存默认是打开的，二级缓存需要配置才可以开启。那么我们必须思考一个问题，在什么情况下才有必要去开启二级缓存？因为所有的增删改都会刷新二级缓存，导致二级缓存失效，所以适合在查询为主的应用中使用，比如历史交易、历史订单的查询。否则缓存就失去了意义。

#### 8.3.3 二级缓存的不足

​		如果多个namespace 中有针对于同一个表的操作，比如user 表，如果在一个namespace 中刷新了缓存，另一个namespace 中没有刷新，就会出现读到脏数据的情况。所以，推荐在一个Mapper 里面只操作单表的情况使用。

如何解决脏读的问题？

① 在sql语句配置文件xxxMapper.xml中，对“可能会操作非该xxxMapper.xml所对应的表”的select语句，设置flushCache="true",即清空缓存，如果改为false则不会清空缓存。insert̵ update̵ delete  这些操作会自动的清空缓存，不用设置。

② 让多个namespace共享一个二级缓存。可以使用cache-ref>来解决。

```xml
<cache-ref namespace="com.daonian.practice.mybatis.mapper.IUserMapper" />
```

cache-ref 代表引用别的命名空间的Cache 配置，两个命名空间的操作使用的是同一个Cache。在关联的表比较少，或者按照业务可以对表进行分组的时候可以使用。**注意：**在这种情况下，多个Mapper 的操作都会引起缓存刷新，缓存的意义已经不大了。

### 8.4 二级缓存整合redis

​		上面介绍的都是Mybatis自带的缓存，但是这个缓存是单服务器工作的，无法实现分布式缓存。那什么是分布式缓存呢，假设现在又两个服务器1、2，用户访问服务器1，查询后的缓存就会放到服务器1上，现在另一个用户访问的是服务器2，那么在服务器2上就获取不到服务1的缓存数据。

![image-20200607175803831](..\img-folder\image-20200607175803831.png)

​		为了解决这个问题就找一个分布式缓存，专门用来存储数据，这样不同的服务器要缓存的数据都往分布式缓存哪里存，取缓存数据也从分布式缓存中取。

![image-20200607180032340](..\img-folder\image-20200607180032340.png)

**mybatis与redis缓存的整合**

​		mybatis提供一个Cache接口，如果使用自定义缓存，实现Cache接口即可。mybatis本身默认实现了一个，但是这个缓存的实现无法实现分布式缓存，所以我们要自己来实现。redis分布式缓存就可以，mybatis提供了-个针对cache接口的redis实现类，该类存在mybatis-redis包中

实现：

① pom.xml文件

~~~xml
<dependency>
    <groupId>org.mybatis.caches</groupId>
    <artifactId>mybatis-redis</artifactId>
    <version>1.0.0-beta2</version>
</dependency>  
~~~

② sql语句配置文件

~~~xml
<cache type="org.mybatis.caches.redis.RedisCache" />
    
<select id="findAll" resultType="MybatisUser" useCache="true">
	select * from user
</select>
~~~

③ redis.propertis

~~~properties
redis.host=localhost
redis.port=6379
redis.connectionTimeout=5000
redis.password=
redis.database=0
~~~

④ 测试

~~~java
@Test
public void SecondLevelCache(){
    SqlSession sqlSession1 = sqlSessionFactory.openSession();
    SqlSession sqlSession2 = sqlSessionFactory.openSession();
    SqlSession sqlSession3 = sqlSessionFactory.openSession();
    
    IUserMapper mapper1 = sqlSession1.getMapper(IUserMapper.class);
    IUserMapper mapper2 = sqlSession2.getMapper(IUserMapper.class);
    IUserMapper mapper3 = sqlSession3.getMapper(IUserMapper.class);
    
    MybatisUser user1 = mapper1.findUserById(1);
    sqlSession1.close(); //清空一级缓存
    
    User user = new User();
    user.setId(1);
    user.setUsername("lisi");
    mapper3.updateUser(user);
    sqlSession3.commit();
    
    MybatisUser user2 = mapper2.findUserById(1);
    System.out.println(user1==user2);
}  
~~~



## 第九部分 Mybatis插件

### 9.1 插件简介

​		一般情况下，开源框架都会提供插件或其他形式扩展点，供开发者自行扩展。这样的好处是显而易见的，一是增加了框架的灵活性。二是开发者可以结合实际需要，对框架进行拓展，使其能够更好适合自己工作。以Mybatis为例，可以基于Mybatis插件机制实现分页、分表、监控等功能。

​		Mybatis作为一个应用广泛的优秀ORM开源框架，这个框架具有强大的灵活性，在四大组件（Executor、StatementHandler、ParameterHandler、ResultSetHandler）处提供了简单易用的插件扩展机制。Mybatis对持久层的操作就是借助于四大核心对象。Mybatis支持用插件对四大核心对象进行拦截，对mybatis来说插件就是拦截器，用来增强核心对象的功能，增强功能本质上是借助于底层的动态代理实现的，换句话说，Mybatis中的四大对象都是代理对象。

![image-20200607192956954](..\img-folder\image-20200607192956954.png)

 Mybatis所允许的拦截的方法如下：

* 执行器Executor（update、query、commit、rollback等方法）
* SQL语法构建器StatementHandler（prepare、parameterize、batch、update、query）等方法
* 参数处理器ParameterHandler（getParameterObject、setParameter方法）
* 结果集处理器ResultSetHandler（handleResultSets、handleOutputParameters等方法）

### 9.2 Mybatis插件原理

在四大对象创建的时候

* 每个创建出来的对象不是直接返回的，而是interceptorChain.pluginAll(parameterHandler);
* 获取到所有的Interceptor (拦截器) (插件 需要实现的接口) ;调用
  interceptor.plugin(target);返回target包装后的对象
* 插件机制，我们可以使用插件为目标对象创建一个代理对象; AOP (面向切面)我们的插件可
  以为四大对象创建出代理对象，代理对象就可以拦截到四大对象的每一一个执行 ;

拦截

插件具体是如何拦截并附加额外的功能的呢?以ParameterHandler 来说

~~~java
public ParameterHandler newParameterHandler(MappedStatement mappedStatement,
    Object object, BoundSql sql, InterceptorChain interceptorChain){
    ParameterHandler parameterHandler =
    mappedStatement.getLang().createParameterHandler(mappedStatement,object,sql);
    parameterHandler = (ParameterHandler)
    interceptorChain.pluginAll(parameterHandler);
    return parameterHandler;
}
public Object pluginAll(Object target) {
    for (Interceptor interceptor : interceptors) {
    	target = interceptor.plugin(target);
    }
	return target;
}
~~~

interceptorChain保存了所有的拦截器(interceptors)，是mybatis初始化的时候创建的。调用拦截器链中的拦截器依次的对目标进行拦截或增强。interceptor.plugin(target)中的target就可以理解为mybatis中的四大对象。返回的target是被重重代理后的对象，如果我们想要拦截Executor的query方法，那么可以这样定义插件:

~~~
@Intercepts({
	@Signature({
		type = Executor.class,
		method = "query",
		args = {MappedStatement.class,Object.class,RowBounds.class,ResultHandler.class}
	})
})
public class ExamplePlugin implements Interceptor{
	//省略逻辑
}
~~~

除此之外，我们还需要将插件配置到sqlMapConfig.xml中

~~~xml
<plugins>
	<plugin interceptor="com.daonian.practice.mybatis.plugin.ExamplePlugin"></plugin>
</plugins>
~~~

这样MyBatis在启动时可以加载插件，并保存插件实例到相关对象(InterceptorChain, 拦截器链)中。待准备工作做完后，MyBatis 处于就绪状态。我们在执行SQL时，需要先通过DefaultSqlSessionFactory创建SqlSession。Executor 实例会在创建SqlSession的过程中被创建，Executor实例创建完毕后，MyBatis 会通过jDK动态代理为实例生成代理类。这样，插件逻辑即可在Executor相关方法被调用前执行。以上就是MyBatis插件机制的基本原理。

### 9.3 Mybatis自定义插件

#### 9.3.1 插件接口

Mybatis插件接口-Interceptor

* Intercept方法，插件的核心方法
* plugin方法，生成target的代理对象
* setProperties方法，传递插件所需参数

#### 9.3.2 自定义插件

设计实现一个自定义插件

~~~java
package com.daonian.practice.mybatis.plugin;

import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.plugin.*;

import java.sql.Connection;
import java.util.Properties;


@Intercepts({//注意看这个大括号，也就是说这里可以定义多个@Signature对多个地方拦截，
        @Signature(type = StatementHandler.class,// 这是指拦截哪个接口
                method = "prepare",// 这个接口内的哪个方法名
                args = { Connection.class, Integer.class})//这是拦截方法的入参，按顺序写到这，不要多不要少，如果方法重载，可是要通过方法名和入参唯一确定
        })
public class MyPlugin implements Interceptor {

    // 拦截方法，只要被拦截的目标对象的目标方法被执行时，每次都会执行interceptor方法
    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        // 增强逻辑
        System.out.println("对方法进行了增强...");
        return invocation.proceed(); // 执行原方法
    }

    /**
     * 主要为了把当前的拦截器生成代理存到拦截器链中
     * @Description 包装目标对象，为目标对象创建代理对象
     * @param target 要拦截的对象
     * @return
     */
    @Override
    public Object plugin(Object target) {
        System.out.println("将要包装的目标对象：" + target);
        return Plugin.wrap(target,this);
    }

    // 获取配置文件的参数
    // 插件初始化的时候调用，也就调用一次，插件配置的属性从这里设置进来
    @Override
    public void setProperties(Properties properties) {
        System.out.println("插件配置的初始化参数：" + properties );
    }

}
~~~

~~~xml
   <!--sqlMapConfig.xml插件-->
	<plugins>
        <plugin interceptor="com.daonian.practice.mybatis.plugin.MyPlugin">
            <!--配置参数-->
            <property name="name" value="Bob"/>
        </plugin>
    </plugins>
~~~

测试代码

~~~java
package com.daonian.practice.mybatis.plugin;

import com.daonian.practice.mybatis.mapper.IUserMapper;
import com.daonian.practice.mybatis.pojo.MybatisUser;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.junit.Test;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class MyPluginTest {
    @Test
    public void testMyPlugin() throws IOException {
        InputStream inputStream = Resources.getResourceAsStream("com/daonian/practice/mybatis/sqlMapConfig.xml");
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        SqlSession sqlSession = sqlSessionFactory.openSession();
        IUserMapper userMapper = sqlSession.getMapper(IUserMapper.class);
        List<MybatisUser> mybatisUsers = userMapper.selectIdAndUser();
        for (MybatisUser mybatisUser : mybatisUsers) {
            System.out.println(mybatisUser);
        }

    }
}

~~~

测试结果

![image-20200607224914277](..\img-folder\image-20200607224914277.png)

![image-20200607225008656](..\img-folder\image-20200607225008656.png)

### 9.4 源码分析

执行插件逻辑

Plugin实现了Invocationhandler接口，因此它的invoke方法会拦截所有的方法调用。invoke方法会对所拦截的方法进行检测，以决定是否执行插件逻辑，该方法的逻辑如下：

![image-20200607225555903](..\img-folder\image-20200607225555903.png)

invoke方法的代码比较少，逻辑不难理解。首先，invoke方法会检测被拦截的方法是否配置在插件的@Signature注解中，若是，则执行插件逻辑，否则执行被拦截的方法。插件逻辑封装在interceptor中，该方法的参数类型为Invocation。Invocation主要用于存储目标类，方法以及方法参数列表。下面简单看一下该类的定义

![image-20200607225948200](..\img-folder\image-20200607225948200.png)

### 9.5 pageHelper分页插件

Mybatis可以使用第三方的插件来对功能进行扩展，分页助手PageHelper是将分页的复杂操作进行封装，使用简单的方式即可获得分页的相关数据

开发步骤:

① 导入通用PageHelper坐标

~~~xml
<!--分页助手-->
<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper</artifactId>
    <version>3.7.5</version>
</dependency>
<dependency>
    <groupId>com.github.jsqlparser</groupId>
    <artifactId>jsqlparser</artifactId>
    <version>0.9.1</version>
</dependency>
~~~



② 在Mybatis核心配置文件中配置PageHelper插件

~~~xml
        <!--注意，分页助手插件，配置在通用mapper之前-->
        <plugin interceptor="com.github.pagehelper.PageHelper">
            <!--指定方言-->
            <property name="dialect" value="mysql"/>
        </plugin>
~~~



③ 测试分页数据获取

~~~java
   @Test
    public void testPageHelper(){
        // 设置分页参数
        PageHelper.startPage(1,2);

        List<MybatisUser> mybatisUsers = userMapper.findAll();
        for (MybatisUser mybatisUser : mybatisUsers) {
            System.out.println(mybatisUser);
        }

        // 获取其他分页相关的参数
        PageInfo<MybatisUser> mybatisUserPageInfo = new PageInfo<>(mybatisUsers);
        System.out.println("总条数: " + mybatisUserPageInfo.getTotal() );
        System.out.println("总页数：" + mybatisUserPageInfo.getPages());
        System.out.println("当前页：" + mybatisUserPageInfo.getPageNum());
        System.out.println("每页显示长度：" + mybatisUserPageInfo.getPageSize());
        System.out.println("是否是第一页：" + mybatisUserPageInfo.isIsFirstPage());
        System.out.println("是否是最后一页：" + mybatisUserPageInfo.isIsLastPage());
    }
~~~



### 9.6 通用mapper

**什么是通用mapper**

通用mapper就是为了解决单表增删改查的问题，基于Mybatis插件机制，开发人员不需要写SQL，不需要在mapper接口中增加方法，只要写好实体类，就能支持相应的增删改查方法。

使用步骤：

① 首先在maven项目中引入mapper的依赖

~~~xml
<dependency>
    <groupId>tk.mybatis</groupId>
    <artifactId>mapper</artifactId>
    <version>3.1.2</version>
</dependency>
~~~

②  Mybatis配置文件sqlMapConfig.xml进行配置

```xml
<plugin interceptor="tk.mybatis.mapper.mapperhelper.MapperInterceptor">
    <!--通用Mapper接口，多个通用接口用逗号隔开-->
    <property name="mappers" value="tk.mybatis.mapper.common.Mapper"/>
</plugin>
```

③ 实体类配置主键

![image-20200608102314258](..\img-folder\image-20200608102314258.png)

④ 定义通用mapper

~~~
package com.daonian.practice.mybatis.mapper;

import tk.mybatis.mapper.common.Mapper;


/**
 * MyBatis动态代理开发方式
 */
public interface IUserMapper extends Mapper<MybatiCommonMapperUser> {
}
~~~

⑤ 测试

```java
// 测试通用mapper
@Test
public void testGeneralMapper(){
    // 实体对象
    MybatiCommonMapperUser mybatiCommonMapperUser = new MybatiCommonMapperUser();
    mybatiCommonMapperUser.setId(1);
    mybatiCommonMapperUser.setPassword("321");

    // 根据主键进行查询
    MybatiCommonMapperUser mybatiCommonMapperUser1 = userMapper.selectByPrimaryKey(1);
    System.out.println(mybatiCommonMapperUser1);

    // 根据实体对象查询，查询语句的where条件是根据实体对象中属性决定的，
    // 如果实体对象只有一个id有值，where id = #{id}
    // 2个就是 where id = #{id} and username = #{username}
    // 依次类推
    MybatiCommonMapperUser mybatiCommonMapperUser2 = userMapper.selectOne(mybatiCommonMapperUser);
    System.out.println(mybatiCommonMapperUser2);

    // 实体对象
    MybatiCommonMapperUser mybatiCommonMapperUser3 = new MybatiCommonMapperUser();
    mybatiCommonMapperUser3.setId(4);
    mybatiCommonMapperUser3.setUsername("lisi");
    mybatiCommonMapperUser3.setPassword("321");

    // 插入实体对象,null值也会保存，不会使用数据库默认值
    userMapper.insert(mybatiCommonMapperUser3);
    sqlSession.commit();

    // 插入实体对象,null值不会保存，使用数据库默认值
    MybatiCommonMapperUser mybatiCommonMapperUser4 = new MybatiCommonMapperUser();
    mybatiCommonMapperUser4.setId(5);
    mybatiCommonMapperUser4.setUsername("lisi");
    mybatiCommonMapperUser4.setPassword("321");
    userMapper.insertSelective(mybatiCommonMapperUser4);
    sqlSession.commit();

    // 更新接口，根据主键更新实体全部字段，null值会被更新
    MybatiCommonMapperUser mybatiCommonMapperUser5 = new MybatiCommonMapperUser();
    mybatiCommonMapperUser5.setId(4);
    mybatiCommonMapperUser5.setUsername("lisi");
    mybatiCommonMapperUser5.setPassword("123");
    userMapper.updateByPrimaryKey(mybatiCommonMapperUser5);
    sqlSession.commit();

    // 根据主键进行删除
    userMapper.deleteByPrimaryKey(5);
    sqlSession.commit();

    // 根据实体对象进行删除
    userMapper.delete(mybatiCommonMapperUser5);
    sqlSession.commit();


    // example方法
    Example example = new Example(MybatiCommonMapperUser.class);
    example.createCriteria().andEqualTo("id",1);
    example.createCriteria().andLike("password", "123");
    // 自定义查询
    List<MybatiCommonMapperUser> users1 = userMapper.selectByExample(example);
    for (MybatiCommonMapperUser commonMapperUser : users1) {
        System.out.println(commonMapperUser);
    }
}
```

## 第十部分 其它

### 10.1 连接池

**POOLED使用连接池**

 连接池示意

![1576430643964](..\img-folder\1576430643964.png)

 

**Mybatis连接池初始化时机**

![1576430656070](..\img-folder\1576430656070.png)

在构建工厂的时候创建Mybatis的数据库连接池

![img](..\img-folder\wps130.jpg) 

**什么时候从连接池获取连接**

getMapper的时候还是真正调用api操作数据库的时候？

从连接池获取连接的时机：真正操作数据库调用api的时候，不是getMapper的时候

![img](E:\lagou\高级工程师训练营\学习笔记\docs\img-folder\wps131.jpg) 

 其他

 UNPOOLED：不使用数据库连接池（一般不使用）

 JNDI:(前提你的Mybatis环境必须是Web应用)（了解）

**什么是JNDI**

JNDI:java naming directory interface(java命名目录接口)，它是一种该服务发布技术，可以通过JNDI技术把数据源发布成一个服务，那么客户端可以调用这个服务

 为什么必须是web应用

因为支持JNDI技术的往往是tomcat/weblogic/websphere这些中间件才支持JNDI技术

如果在Mybatis当中用，怎么用？

### 10.2 Mybatis延迟加载策略

关联对象：数据库层次用户和订单是关联表，在对象层次订单对象和用户对象就叫做关联对象

#### 10.2.1 什么是延迟加载？

在使用关联对象的过程中

比如使用了Orders对象，但是我只是获取Orders的订单数据尚未获取user的数据，但是依然查询了user表（这不是延迟）

我orders.getNumber()你不要查user表的数据，当我orders.getUser()你再去查user表

关联查询的关联对象，在较多的场合中并不需要的时候，只在少部分场合需要关联的那个对象数据，可以考虑使用延迟加载

#### 10.2.2 Mybatis中怎么实现延迟加载？

步骤1：原来关联sql语句要拆分

1） 第一条sql查询基础表

2） 第二条sql根据基础表的条件查询关联表

步骤2：让两条sql自动产生联系，通过

~~~xml
<association column="" select=""/> 
<!--或者-->
<collection column="" select =""/>
~~~

 **全局延迟加载开关配置（一对一和一对多都需要开启）**

~~~xml
 <!-- 开启延迟加载 -->
<setting name="lazyLoadingEnabled" value="true" />
<!-- 关闭立即加载 -->
<setting name="aggressiveLazyLoading" value="false" />
<!-- 设定tostring等方法延迟加载 -->
<setting name="lazyLoadTriggerMethods" value="true" />
~~~

**一对一关联查询的延迟加载**

```xml
<select id="queryOrdersWithUser" resultMap="ordersUserResultMap">
      SELECT
      o.`id`,
      o.`user_id`,
      o.`number`,
      o.`createtime`,
      o.`note`
      FROM
      orders o
</select>

<!--
      延迟加载分析
      1、原来关联查询的sql语句必然要拆分，如果不拆分，那肯定要执行关联查询，两个表用不用都要查
      2、sql=sql1+sql2拆分之后，要让这两个sql自动产生联系
      sql1:select id,user_id,number,createtime,note from orders
      sql2:select * from user u where id=user_id
      -->

<resultMap id="ordersUserResultMap" type="orders">
<id column="id" property="id"/>
<result column="user_id" property="userId"/>
<result column="number" property="number"/>
<result column="createtime" property="createtime"/>
<result column="note" property="note"/>
<association property="user" javaType="user" column="user_id" select="com.mybatis.mapper.UserMapper.queryUserByUserId">
</association>
</resultMap>

<select id="queryUserByUserId"  parameterType="int" resultType="user">
      select id,username,sex,birthday,address from user where id=#{user_id}
</select> 
```

**一对多关联查询的延迟加载**

```xml
<select id="queryUserWithOrders" resultMap="userOrdersResultMap">
      SELECT
      u.`id`,
      u.`username`,
      u.`sex`,
      u.`birthday`,
      u.`address`
      FROM
      USER u
</select>

<resultMap id="userOrdersResultMap" type="user">
<id column="id" property="id"/>
<result column="username" property="username"/>
<result column="sex" property="sex"/>
<result column="birthday" property="birthday"/>
<result column="address" property="address"/>

<collection property="ordersList" ofType="orders" column="id" select="com.mybatis.mapper.OrdersMapper.queryOrdersByUserId">
</collection>
</resultMap>

<!--拆分的第二条sql语句-->
<select id="queryOrdersByUserId" parameterType="int" resultType="orders">
      select o.id,o.user_id,o.number,o.createtime,o.note  from orders o  where o.user_id=#{id}
</select> 
```

### 10.3 Tomcat配置JNDI数据源



## 第十一部分 Mybatis源码剖析

### 11.1 Mybatis架构原理

#### 11.1.1 架构设计

![image-20200608193636583](..\img-folder\image-20200608193636583.png)

我们把Mybatis的功能架构分为三层:

（1）**API接口层**：提供给外部使用的接口API，开发人员通过这些API来操纵数据库。接口层一接收到
调用请求就会调用数据处理层来完成具体的数据处理。

MyBatis和数据库的交互有两种方式：

a.使用传统的MyBatis提供的API;

b.使用Mapper代理的方式

（2）**数据处理层**：负责具体的SQL查找、SQL解析、SQL执行和执行结果映射处理等。它主要的目的是根
据调用的请求完成一次数据库操作。

（3）**基础支撑层**：负责最基础的功能支撑，包括连接管理、事务管理、配置加载和缓存处理，这些都是共
用的东西，将他们抽取出来作为最基础的组件。为上层的数据处理层提供最基础的支撑。



#### 11.1.2 主要构件及其相互关系

![image-20200608194326636](..\img-folder\image-20200608194326636.png)

![image-20200608194550169](..\img-folder\image-20200608194550169.png)

![image-20200608194707699](..\img-folder\image-20200608194707699.png)

不同组件做的事情

* SqlSession

  ```java
  	<T> T selectOne(String statement, Object parameter);
      <E> List<E> selectList(String statement, Object parameter, RowBounds rowBounds);
      <K, V> Map<K, V> selectMap(String statement, String mapKey);
      <T> Cursor<T> selectCursor(String statement, Object parameter, RowBounds rowBounds);
      void select(String statement, Object parameter, RowBounds rowBounds, ResultHandler handler)
  	int insert(String statement);
      int update(String statement, Object parameter);
      int delete(String statement, Object parameter);
  ```

从SqlSession接口中方法的参数可知，都必须要传一个statement参数，statement=namespace.id。而statement参数用来获取封装sql语句的MappedStatement。

SqlSesson的功能：

​	① 获取mappedStatement对象，交给Executor执行器处理

​	② 对输入参数进行处理，处理逻辑见源码

​	③ 创建分页对象，交给Executor执行器处理

​	④ 对于selectMap方法，使用DefaultMapResultHandler处理返回结果List

Executor的功能：

​	① 根据传入的参数动态获得SQL语句，最后返回用BoundSql对象表示。（区别与对占位符赋值）

​	② 实现一级缓存

​    ③ 实现延迟加载

​    ④ 获取connection连接

​	④ 创建StatementHandler

CachedExecutor：

​	① 实现了二级缓存

**StatementHandler**

​	①  负责处理JDBC,包括对statement设置参数，对结果集转换成List

**Parameterhandler**

​	① 设置 SQL 上的参数，例如 PrepareStatement 对象上的占位符

**ResultSetHandler**

​	① 处理结果集ResultSet转换成List

#### 11.1.3 总体流程

（1）**加载配置并初始化**

**触发条件**：加载配置文件

配置来源于两个地方，一个是配置文件(主配置文件conf.xml,mapper文件* .xm)，一个是java代码中的注解，将主配置文件内容解析封装到Configuration,将sql的配置信息加载成为一个mappedstatement对象，存储在内存之中。

Mybatis初始化过程
解析配置信息：sqlMapConfig.xml、mapper.xml文件、mapper接口中的注解

初始过程中涉及的对象：Resources、configuration、xmlConfigBuilder、xmlMapperBuilder、mappedstatment、sqlSource

注解的解析过程在MapperAnnotationBuilder.parse()

**触发条件**：调用Mybatis提供的API

传入参数：为SQL的ID和传入参数对象

处理过程：将请求传递给下层的请求处理层进行处理。

（3）处理操作请求

**触发条件**：API接口层传递请求过来

**传入参数**：为SQL的ID和传入参数对象

处理过程:

(A) 根据SQL的ID查找对应的MappedStatement对象。

(B) 根据传入参数对象解析MappedStatement对象，得到最终要执行的SQL和执行传入参数。

(C) 获取数据库连接，根据得到的最终SQL语句和执行传入参数到数据库执行，并得到执行结果。

(D) 根据MappedStatement对象中的结果映射配置对得到的执行结果进行转换处理，并得到最终的处理结果。

(E) 释放连接资源。

(4) 返回处理结果

将最终的处理结果返回。

​	

### 11.2 Mybatis源码剖析

#### 11.2.1 Mybatis初始化源码剖析

​		Mybatis的配置信息配置在主配置文件sqlMapConfig.xml、mapper.xml和mapper接口注解中。mybatis和数据库交互之前需要将这些配置信息解析到Configuration对象中，并加载到内存。

（1）应用端提供配置文件，使用Resources类读取配置文件生成字节输入流。

~~~java
    // 1. 读取配置文件成字节输入流，注意：现在还没解析
    InputStream inputStream = Resources.getResourceAsStream("sqlMapConfig.xml");
~~~

（2）使用SqlSessionFactoryBuilder解析配置文件，封装Configuration对象，并返回SqlSessionFactory对象。

~~~java
	// 2. 解析配置文件，封装Configuration对象   创建DefaultSqlSessionFactory对象
	SqlSessionFactory sqlSessionFactory = new                                                              sqlSessionFactoryBuilder().build(inputStream);
~~~

​		进入sqlSessionFactoryBuilder().build(inputStream)源码

~~~java
	// 2.1 最初调用的build重载方法
    public SqlSessionFactory build(InputStream inputStream) {
        // 然后继续调用重载方法
        return build(inputStream, null, null);
    }
~~~

~~~java
	// 2.2 重载方法
    public SqlSessionFactory build(InputStream inputStream, String environment, Properties properties) {
        try {
            // 创建 XMLConfigBuilder, XMLConfigBuilder是专门解析mybatis的主配置文件的类
            XMLConfigBuilder parser = new XMLConfigBuilder(inputStream, environment, properties);
            // 执行 XML 解析：parser.parse()中才真正解析配置文件，生成Configuration对象，并返回。
            // 创建 DefaultSqlSessionFactory 对象
            return build(parser.parse());
        } catch (Exception e) {
            throw ExceptionFactory.wrapException("Error building SqlSession.", e);
        } finally {
            ErrorContext.instance().reset();
            try {
                inputStream.close();
            } catch (IOException e) {
                // Intentionally ignore. Prefer previous error.
            }
        }
    }
~~~

​		进入XmlConfigBuilder.parse()方法

~~~java
   /**
     * 解析 XML 成 Configuration 对象。
     * @return Configuration 对象
     */
    public Configuration parse() {
        // 若已解析，抛出 BuilderException 异常
        if (parsed) {
            throw new BuilderException("Each XMLConfigBuilder can only be used once.");
        }
        // 标记已解析
        parsed = true;
        // 2.2.1 解析 XML <configuration>标签，<configuration>是MyBatis配置文件中的顶层标签
        // parser是XPathParser解析器对象，用来解析xml文件,parser.evalNode()返回XNode对象
        parseConfiguration(parser.evalNode("/configuration"));
        return configuration;
    }
~~~

​		进入XMLConfigBuilder.parseConfiguration(XNode root)方法

~~~java
	/**
     * 解析 XML
     *
     * 具体 MyBatis 有哪些 XML 标签，
     * 参见 《XML 映射配置文件》http://www.mybatis.org/mybatis-3/zh/configuration.html
     *
     * @param root 根节点
     */
    private void parseConfiguration(XNode root) {
        try {
            //issue #117 read properties first
            // 解析 <properties /> 标签
            propertiesElement(root.evalNode("properties"));
            // 解析 <settings /> 标签
            Properties settings = settingsAsProperties(root.evalNode("settings"));
            // 加载自定义的 VFS 实现类
            loadCustomVfs(settings);
            // 解析 <typeAliases /> 标签
            typeAliasesElement(root.evalNode("typeAliases"));
            // 解析 <plugins /> 标签
            pluginElement(root.evalNode("plugins"));
            // 解析 <objectFactory /> 标签
            objectFactoryElement(root.evalNode("objectFactory"));
            // 解析 <objectWrapperFactory /> 标签
            objectWrapperFactoryElement(root.evalNode("objectWrapperFactory"));
            // 解析 <reflectorFactory /> 标签
            reflectorFactoryElement(root.evalNode("reflectorFactory"));
            // 赋值 <settings /> 到 Configuration 属性
            settingsElement(settings);
            // read it after objectFactory and objectWrapperFactory issue #631
            // 解析 <environments /> 标签
            environmentsElement(root.evalNode("environments"));
            // 解析 <databaseIdProvider /> 标签
            databaseIdProviderElement(root.evalNode("databaseIdProvider"));
            // 解析 <typeHandlers /> 标签
            typeHandlerElement(root.evalNode("typeHandlers"));
            // 2.2.1.1 解析 <mappers /> 标签
            mapperElement(root.evalNode("mappers"));
        } catch (Exception e) {
            throw new BuilderException("Error parsing SQL Mapper Configuration. Cause: " + e, e);
        }
    }
~~~

解析标签的顺序，和mybatis主配置文件中标签的顺序是一致的。这里重点看下解析<mappers>标签的方法。

进入XmlConfigBuilder.mapperElement(XNode parent)

~~~java
    private void mapperElement(XNode parent) throws Exception {
        if (parent != null) {
            // 遍历子节点
            for (XNode child : parent.getChildren()) {
                // 如果是 package 标签，则扫描该包
                if ("package".equals(child.getName())) {
                    // 获得包名
                    String mapperPackage = child.getStringAttribute("name");
                    // 添加到 configuration 中
                    configuration.addMappers(mapperPackage);
                // 如果是 mapper 标签，
                } else {
                    // 获得 resource、url、class 属性
                    String resource = child.getStringAttribute("resource");
                    String url = child.getStringAttribute("url");
                    String mapperClass = child.getStringAttribute("class");
                    // 使用相对于类路径的资源引用
                    if (resource != null && url == null && mapperClass == null) {
                        ErrorContext.instance().resource(resource);
                        // 获得 resource 的 InputStream 对象
                        InputStream inputStream = Resources.getResourceAsStream(resource);
                        // 创建 XMLMapperBuilder 对象
                        XMLMapperBuilder mapperParser = new XMLMapperBuilder(inputStream, configuration, resource, configuration.getSqlFragments());
                        // 执行解析
                        mapperParser.parse();
                    // 使用完全限定资源定位符（URL）
                    } else if (resource == null && url != null && mapperClass == null) {
                        ErrorContext.instance().resource(url);
                        // 获得 url 的 InputStream 对象
                        InputStream inputStream = Resources.getUrlAsStream(url);
                        // 创建 XMLMapperBuilder 对象
                        XMLMapperBuilder mapperParser = new XMLMapperBuilder(inputStream, configuration, url, configuration.getSqlFragments());
                        // 执行解析
                        mapperParser.parse();
                    // 使用映射器接口实现类的完全限定类名
                    } else if (resource == null && url == null && mapperClass != null) {
                        // 获得 Mapper 接口
                        Class<?> mapperInterface = Resources.classForName(mapperClass);
                        // 添加到 configuration 中
                        configuration.addMapper(mapperInterface);
                    } else {
                        throw new BuilderException("A mapper element may only specify a url, resource or class, but not more than one.");
                    }
                }
            }
        }
    }
~~~

<mappers>子标签标签有两种：

~~~xml
   <!-- 引入mapper.xml -->
    <mappers>
        <!-- mapper标签引入单个sql语句配置文件-->
        <mapper resource = "com/daonian/practice/mybatis/dao/quickStartMapper.xml"/>

        <!-- package标签通过name属性指定mapper接口所在的包名 -->
        <!-- mapper接口对应的sql映射文件路径和文件名必须和mapper接口一样-->
        <package name="com/daonian/practice/mybatis/mapper"/>
    </mappers>
~~~

① 当解析<package>标签时，调用Configuration.addMappers(mapperPackage)

* 进入Configuration.addMappers(String packageName)

  ~~~java
  	public void addMappers(String packageName) {
          // 扫描该包下所有的 Mapper 接口，并添加到 mapperRegistry 中
          mapperRegistry.addMappers(packageName);
      }
  ~~~

  

* 进入MapperRegistry.addmappers(String packageName)

  ~~~java
  	public void addMappers(String packageName) {
         //1 进入MapperRegistry.addMappers(String packageName, Class<?> superType)重载方法
          addMappers(packageName, Object.class);
      }
  
      /**
       * 扫描指定包，并将符合的类，添加到 {@link #knownMappers} 中
       */
      public void addMappers(String packageName, Class<?> superType) {
          // 扫描指定包下的指定类
          ResolverUtil<Class<?>> resolverUtil = new ResolverUtil<>();
          resolverUtil.find(new ResolverUtil.IsA(superType), packageName);
          Set<Class<? extends Class<?>>> mapperSet = resolverUtil.getClasses();
          // 遍历，添加到 knownMappers 中
          for (Class<?> mapperClass : mapperSet) {
              // 2 处理mapper接口
              addMapper(mapperClass);
          }
      }
  
      public <T> void addMapper(Class<T> type) {
          // 判断，必须是接口。
          if (type.isInterface()) {
              // 已经添加过，则抛出 BindingException 异常
              if (hasMapper(type)) {
                  throw new BindingException("Type " + type + " is already known to the MapperRegistry.");
              }
              boolean loadCompleted = false;
              try {
                  // 3 添加到 knownMappers 中
                  knownMappers.put(type, new MapperProxyFactory<>(type));
                  // It's important that the type is added before the parser is run
                  // otherwise the binding may automatically be attempted by the
                  // mapper parser. If the type is already known, it won't try.
                  // 4 解析 Mapper 的注解配置
                  MapperAnnotationBuilder parser = new MapperAnnotationBuilder(config, type);
                  // 5 解析接口注解中配置的信息 和 加载对应的 XML Mapper
                  parser.parse();
                  // 标记加载完成
                  loadCompleted = true;
              } finally {
                  // 若加载未完成，从 knownMappers 中移除
                  if (!loadCompleted) {
                      knownMappers.remove(type);
                  }
              }
          }
      }
  ~~~

* 进入MapperAnnotationBuilder.parse()

  ~~~java
  	/**
       * 解析注解
       */
      public void parse() {
          // 判断当前 Mapper 接口是否应加载过。
          String resource = type.toString();
          if (!configuration.isResourceLoaded(resource)) {
              // 加载对应的 XML Mapper
              loadXmlResource();
              // 标记该 Mapper 接口已经加载过
              configuration.addLoadedResource(resource);
              // 设置 namespace 属性
              assistant.setCurrentNamespace(type.getName());
              // 解析 @CacheNamespace 注解
              parseCache();
              // 解析 @CacheNamespaceRef 注解
              parseCacheRef();
              // 遍历每个方法，解析其上的注解
              Method[] methods = type.getMethods();
              for (Method method : methods) {
                  try {
                      // issue #237
                      if (!method.isBridge()) {
                          // 执行解析方法上的注解
                          parseStatement(method);
                      }
                  } catch (IncompleteElementException e) {
                      // 解析失败，添加到 configuration 中
                      configuration.addIncompleteMethod(new MethodResolver(this, method));
                  }
              }
          }
          // 解析待定的方法
          parsePendingMethods();
      }
  ~~~

  解析注解的过程中，调用MapperAnnotationBuilder.loadXmlResource()方法，解析mapper接口对应的mapper.xml文件，loadXmlResource()内部也是通过XMLMapperBuilder.parse()解析mapper.xml文件的。具体见 - ② 解析<mapper>标签。

  具体如何解析注解，不在这里叙述。如有需要，可翻看源码。

② 当解析<mapper>标签时，直接调用XMLMapperBuilder.parse()

​     再次回到XmlConfigBuilder.mapperElement(XNode parent)方法中，分析解析<mapper>标签。

* 进入XMLMapperBuilder.parse()方法

  ~~~java
      public void parse() {
          // 判断当前 Mapper 是否已经加载过
          if (!configuration.isResourceLoaded(resource)) {
              // 解析 `<mapper />` 节点
              configurationElement(parser.evalNode("/mapper"));
              // 标记该 Mapper 已经加载过
              configuration.addLoadedResource(resource);
              // 绑定 Mapper
              bindMapperForNamespace();
          }
  
          // 解析待定的 <resultMap /> 节点
          parsePendingResultMaps();
          // 解析待定的 <cache-ref /> 节点
          parsePendingCacheRefs();
          // 解析待定的 SQL 语句的节点
          parsePendingStatements();
      }
  ~~~

* 进入XMLMapperBuilder.configurationElement(XNode context)

  ~~~java
      // 解析 <mapper/> 节点
      private void configurationElement(XNode context) {
          try {
              // 获得 namespace 属性
              String namespace = context.getStringAttribute("namespace");
              if (namespace == null || namespace.equals("")) {
                  throw new BuilderException("Mapper's namespace cannot be empty");
              }
              // 设置 namespace 属性
              builderAssistant.setCurrentNamespace(namespace);
              // 解析 <cache-ref /> 节点
              cacheRefElement(context.evalNode("cache-ref"));
              // 解析 <cache /> 节点
              cacheElement(context.evalNode("cache"));
              // 已废弃！老式风格的参数映射。内联参数是首选,这个元素可能在将来被移除，这里不会记录。
              parameterMapElement(context.evalNodes("/mapper/parameterMap"));
              // 解析 <resultMap /> 节点们
              resultMapElements(context.evalNodes("/mapper/resultMap"));
              // 解析 <sql /> 节点们
              sqlElement(context.evalNodes("/mapper/sql"));
              // 解析 <select /> <insert /> <update /> <delete /> 节点们
            buildStatementFromContext(context.evalNodes("select|insert|update|delete"));
          } catch (Exception e) {
              throw new BuilderException("Error parsing Mapper XML. The XML location is '" + resource + "'. Cause: " + e, e);
          }
      }
  ~~~

* 解析<select><insert><update><delete>节点

  进入XMLMapperBuilder.buildStatementFromContext()

  ~~~java
      // 解析 <select /> <insert /> <update /> <delete /> 节点们
      private void buildStatementFromContext(List<XNode> list) {
          if (configuration.getDatabaseId() != null) {
              buildStatementFromContext(list, configuration.getDatabaseId());
          }
          buildStatementFromContext(list, null);
      }
  	
  	// 进入重载方法
      private void buildStatementFromContext(List<XNode> list, String requiredDatabaseId) {
          //遍历 <select /> <insert /> <update /> <delete /> 节点们
          for (XNode context : list) {
              // 创建 XMLStatementBuilder 对象，执行解析
              final XMLStatementBuilder statementParser = new XMLStatementBuilder(configuration, builderAssistant, context, requiredDatabaseId);
              try {
                  statementParser.parseStatementNode();
              } catch (IncompleteElementException e) {
                  // 解析失败，添加到 configuration 中
                  configuration.addIncompleteStatement(statementParser);
              }
          }
      }
  ~~~

  使用XMLStatementBuilder解析sql语句，这里叙述到这里，不在深入。如有需要，可翻看源码。

  解析完成以后，返回一个Configuration对象。然后将对象传给SqlSessionFactoryBuilder，创建SqlSessionFactory对象。

#### 11.2.2 传统方式使用Mybatis的源码剖析

##### 11.2.2.1 sql执行流程

**SqlSesion**是一个接口，它有两个实现类。一个是DefaultSqlSession（默认）和SqlSessionManager（已弃用）

SqlSession是Mybatis中用于和数据库交互的顶层接口，通常将它与ThreadLocal绑定，一个会话使用一个SqlSession，并且在使用完毕后需要close。

~~~java
    public class DefaultSqlSession implements SqlSession {
        private final Configuration configuration;
        private final Executor executor;
        ...
    }
~~~

**SqlSession**中的两个重要的属性：

* configuration就是初始化的后对象，

* Executor执行器

**Executor**也是一个接口，他有三个常用的实现类：

* BatchExecutor   重用语句并执行批量更新
* ReuseExecutor  重用预处理prepared statements
* SimpleExecutor  简单执行器（默认）



初始化完毕后，就要执行SQL了。分析sql执行流程

~~~java
    // 生产了DefaultSqlsession实例对象   设置了事务不自动提交  完成了executor对象的创建
    SqlSession sqlSession = sqlSessionFactory.openSession();
~~~

* 分析获取SqlSession对象的源码

  进入DefalutSqlSessionFactory.openSession()

  ~~~java
      // 进入openSession方法
      @Override
      public SqlSession openSession() {
          //getDefaultExecutorType()返回的就是SimpleExecutor
          return openSessionFromDataSource(configuration.getDefaultExecutorType(), null, false);
      }
  ~~~

  进入DefalutSqlSessionFactory.openSessionFromDataSource()

  ~~~java
      //ExecutorType 为Executor的类型，TransactionIsolationLevel为事务隔离级别，autoCommit是否开启事务
      //openSession的多个重载方法可以指定获得的SeqSession的Executor类型和事务的处理
      private SqlSession openSessionFromDataSource(ExecutorType execType, TransactionIsolationLevel level, boolean autoCommit) {
          Transaction tx = null;
          try {
              // 获得 Environment 对象
              final Environment environment = configuration.getEnvironment();
              // 创建 Transaction 对象
              final TransactionFactory transactionFactory = getTransactionFactoryFromEnvironment(environment);
              tx = transactionFactory.newTransaction(environment.getDataSource(), level, autoCommit);
              // 创建 Executor 对象
              final Executor executor = configuration.newExecutor(tx, execType);
              // 创建 DefaultSqlSession 对象
              return new DefaultSqlSession(configuration, executor, autoCommit);
          } catch (Exception e) {
              // 如果发生异常，则关闭 Transaction 对象
              closeTransaction(tx); // may have fetched a connection so lets call close()
              throw ExceptionFactory.wrapException("Error opening session.  Cause: " + e, e);
          } finally {
              ErrorContext.instance().reset();
          }
      }
  ~~~

* 这里我们关注创建Executor对象的创建过程

  进入configuration.newExecutor(Transaction transaction, ExecutorType executorType)

  ~~~java
  /**
       * 创建 Executor 对象
       *
       * @param transaction 事务对象
       * @param executorType 执行器类型
       * @return Executor 对象
       */
      public Executor newExecutor(Transaction transaction, ExecutorType executorType) {
          // 获得执行器类型，使用默认ExecutorType.SIMPLE
          executorType = executorType == null ? defaultExecutorType : executorType; 
          executorType = executorType == null ? ExecutorType.SIMPLE : executorType; 
          // 创建对应实现的 Executor 对象
          Executor executor;
          if (ExecutorType.BATCH == executorType) {
              executor = new BatchExecutor(this, transaction);
          } else if (ExecutorType.REUSE == executorType) {
              executor = new ReuseExecutor(this, transaction);
          } else {
              executor = new SimpleExecutor(this, transaction);
          }
          // 如果开启缓存，创建 CachingExecutor 对象，进行包装
          if (cacheEnabled) {
              executor = new CachingExecutor(executor);
          }
          // 应用插件
          executor = (Executor) interceptorChain.pluginAll(executor);
          return executor;
      }
  ~~~

  这有几个很重要的点，

  二级缓存：当开启二级缓存的时候，会用CachingExecutor进一步包装executor，具体为什么要进一步包装，可查阅资料二级缓存是如何实现的？CachingExecutor属性、方法翻看源码。

  插件：这里会调用拦截器链的pluginAll方法，对mybatis应用插件。其实pluginAll()方法实际上对Executor对象进行了动态代理，返回了一个代理对象。对Excutor中的方法进行了增强。

* 应用插件，创建Excutor对象的代理对象

  进入方法interceptorChain.pluginAll(Executor executor)

  ~~~java
      /**
       * 应用所有插件
       *
       * @param target 目标对象
       * @return 应用结果
       */
      public Object pluginAll(Object target) {
          for (Interceptor interceptor : interceptors) {
              // 这里是动态代理，生成target（这里是Excutor）的代理对象
              target = interceptor.plugin(target);
          }
          return target;
      }
  ~~~

  进入（具体一个插件ExamplePlugin）interceptor.plugin(target)方法

  ~~~java
    @Override
    public Object plugin(Object target) {
      return Plugin.wrap(target, this);
    }
  ~~~

  进入Plugin.wrap(target, this)

  ~~~java
      /**
       * 创建目标类的代理对象
       *
       * @param target 目标类
       * @param interceptor 拦截器对象
       * @return 代理对象
       */
      public static Object wrap(Object target, Interceptor interceptor) {
          // 获得拦截的方法映射
          Map<Class<?>, Set<Method>> signatureMap = getSignatureMap(interceptor);
          // 获得目标类的类型
          Class<?> type = target.getClass();
          // 获得目标类的接口集合
          Class<?>[] interfaces = getAllInterfaces(type, signatureMap);
          // 若有接口，则创建目标对象的 JDK Proxy 对象
          if (interfaces.length > 0) {
              return Proxy.newProxyInstance(
                      type.getClassLoader(),
                      interfaces,
                      new Plugin(target, interceptor, signatureMap)); // 因为 Plugin 实现了 InvocationHandler 接口，所以可以作为 JDK 动态代理的调用处理器
          }
          // 如果没有，则返回原始的目标对象
          return target;
      }
  ~~~

  这里处理具体某个插件，结合下面的自定义的插件，理解上面的代码

  ~~~java
  @Intercepts({//注意看这个大括号，也就是说这里可以定义多个@Signature对多个地方拦截，
          @Signature(type = StatementHandler.class,// 这是指拦截哪个接口,这里也可以是Executor
                  method = "prepare",// 这个接口内的哪个方法名
                  args = { Connection.class, Integer.class})//这是拦截方法的入参，按顺序写到这，不要多不要少，如果方法重载，可是要通过方法名和入参唯一确定
          })
  public class MyPlugin implements Interceptor {
  
      // 拦截方法，只要被拦截的目标对象的目标方法被执行时，每次都会执行interceptor方法
      @Override
      public Object intercept(Invocation invocation) throws Throwable {
          // 增强逻辑
          System.out.println("对方法进行了增强...");
          return invocation.proceed(); // 执行原方法
      }
  	...
      ...
      ...
  }
  ~~~

  接看下Plugin类的源码

  ~~~java
  /**
   * 插件类，一方面提供创建动态代理对象的方法，另一方面实现对指定类的指定方法的拦截处理。
   *
   * @author Clinton Begin
   */
  public class Plugin implements InvocationHandler {
  
      /**
       * 目标对象
       */
      private final Object target;
      /**
       * 拦截器
       */
      private final Interceptor interceptor;
      /**
       * 拦截的方法映射
       *
       * KEY：类
       * VALUE：方法集合
       */
      private final Map<Class<?>, Set<Method>> signatureMap;
  
      private Plugin(Object target, Interceptor interceptor, Map<Class<?>, Set<Method>> signatureMap) {
          this.target = target;
          this.interceptor = interceptor;
          this.signatureMap = signatureMap;
      }
  
      /**
       * 创建目标类的代理对象
       *
       * @param target 目标类
       * @param interceptor 拦截器对象
       * @return 代理对象
       */
      public static Object wrap(Object target, Interceptor interceptor) {
  		// 省略，见上面
      }
  
      @Override
      public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
          try {
              // 获得目标方法是否被拦截
              Set<Method> methods = signatureMap.get(method.getDeclaringClass());
              if (methods != null && methods.contains(method)) {
                  // 如果是，则拦截处理该方法
                  return interceptor.intercept(new Invocation(target, method, args));
              }
              // 如果不是，则调用原方法
              return method.invoke(target, args);
          } catch (Exception e) {
              throw ExceptionUtil.unwrapThrowable(e);
          }
      }
      ...
      ...
      ...
  }
  ~~~

  代理对象每次调用方法时都会进入invoke方法，然后判断被调用的方法是否拦截，如果拦截，则调用插件中的增强方法。这里说到了，插件的实现原理。在回到创建 Executor 对象的步骤。

* 创建完Executor对象后，将configuration、executor传入new DefaultSqlSession(configuration, executor, autoCommit)，创建SqlSession对象返回。

调用SqlSession中的方法，执行Sql语句

~~~java
    // (1) 根据statementid来从Configuration中map集合中获取到了指定的MappedStatement对象
    // (2) 将查询任务委派了executor执行器
    List<Object> objects = sqlSession.selectList("namespace.id");

    // 释放资源
    sqlSession.close();
~~~

**调用selectList(),查询数据**

* 进入sqlSession.selectList("namespace.id")方法

  ~~~java
      //进入selectList方法，多个重载方法
      @Override
      public <E> List<E> selectList(String statement) {
          return this.selectList(statement, null);
      }
  
  	@Override
      public <E> List<E> selectList(String statement, Object parameter) {
          // 传一个默认的RowBounds(分页记录对象)
          return this.selectList(statement, parameter, RowBounds.DEFAULT);
      }
  
  	@Override
      public <E> List<E> selectList(String statement, 
                                    Object parameter, 
                                    RowBounds rowBounds) {
          try {
              // 获得 MappedStatement 对象
              MappedStatement ms = configuration.getMappedStatement(statement);
              // 执行查询
              return executor.query(ms, wrapCollection(parameter), 
                                    rowBounds, Executor.NO_RESULT_HANDLER);
          } catch (Exception e) {
              throw ExceptionFactory.wrapException("Error querying database.  Cause: " + e, e);
          } finally {
              ErrorContext.instance().reset();
          }
      }
  ~~~

  SqlSession的selectList方法的逻辑是，从Configuration中mappedStatements字段获取MappedStatement对象，然后传给Executor执行器，executor执行器在去执行查询任务。

* 进入SimpleExecutor.query()，这里如果开启二级缓存，会先进入CachedExecutor.query()

  ~~~java
      //此方法在SimpleExecutor的父类BaseExecutor中实现
      @Override
      public <E> List<E> query(MappedStatement ms, Object parameter, RowBounds rowBounds, ResultHandler resultHandler) throws SQLException {
          //根据传入的参数动态获得SQL语句，最后返回用BoundSql对象表示
          BoundSql boundSql = ms.getBoundSql(parameter);
          //为本次查询创建一级缓存的Key
          CacheKey key = createCacheKey(ms, parameter, rowBounds, boundSql);
          // 查询
          return query(ms, parameter, rowBounds, resultHandler, key, boundSql);
      }
  ~~~

  ~~~java
      // 进入重载方法
  	@Override
      public <E> List<E> query(MappedStatement ms, Object parameter, RowBounds rowBounds, ResultHandler resultHandler, CacheKey key, BoundSql boundSql) throws SQLException {
          ErrorContext.instance().resource(ms.getResource()).activity("executing a query").object(ms.getId());
          // 已经关闭，则抛出 ExecutorException 异常
          if (closed) {
              throw new ExecutorException("Executor was closed.");
          }
          // 清空本地缓存，如果 queryStack 为零，并且要求清空本地缓存。
          // sql语句属性设置 flushCache=true的时候，每一次都清空缓存
          if (queryStack == 0 && ms.isFlushCacheRequired()) {
              clearLocalCache();
          }
          List<E> list;
          try {
              // queryStack + 1
              queryStack++;
              // 从一级缓存中，获取查询结果
              list = resultHandler == null ? (List<E>) localCache.getObject(key) : null;
              // 获取到，则进行处理
              if (list != null) {
                  handleLocallyCachedOutputParameters(ms, key, parameter, boundSql);
              // 获得不到，则从数据库中查询
              } else {
                  list = queryFromDatabase(ms, parameter, rowBounds, resultHandler, key, boundSql);
              }
          } finally {
              // queryStack - 1
              queryStack--;
          }
          if (queryStack == 0) {
              // 执行延迟加载
              for (DeferredLoad deferredLoad : deferredLoads) {
                  deferredLoad.load();
              }
              // issue #601
              // 清空 deferredLoads
              deferredLoads.clear();
              // 如果缓存级别是 LocalCacheScope.STATEMENT ，则进行清理
              if (configuration.getLocalCacheScope() == LocalCacheScope.STATEMENT) {
                  // issue #482
                  clearLocalCache();
              }
          }
          return list;
      }
  ~~~

  可以对单个sql语句进行设置fluashCache="true",设置后，该语句进行查询的时候每次都要清除一级缓存，然后从数据库中查询数据。如果没有设置，不清除一级缓存。查询时先去一级缓存中查，查到则返回，没有查到则需要到数据库查询。

* 进入从数据库读取操作 queryFromDatabase()

  ~~~java
      // 从数据库中读取操作
      private <E> List<E> queryFromDatabase(MappedStatement ms, Object parameter, RowBounds rowBounds, ResultHandler resultHandler, CacheKey key, BoundSql boundSql) throws SQLException {
          List<E> list;
          // 在缓存中，添加占位对象。此处的占位符，和延迟加载有关，可见 `DeferredLoad#canLoad()` 方法
          localCache.putObject(key, EXECUTION_PLACEHOLDER);
          try {
              // 执行读操作
              list = doQuery(ms, parameter, rowBounds, resultHandler, boundSql);
          } finally {
              // 从缓存中，移除占位对象
              localCache.removeObject(key);
          }
          // 添加到缓存中
          localCache.putObject(key, list);
          // 暂时忽略，存储过程相关
          if (ms.getStatementType() == StatementType.CALLABLE) {
              localOutputParameterCache.putObject(key, parameter);
          }
          return list;
      }
  ~~~

  ~~~java
  	// 进入doQuery()    
  	@Override
      public <E> List<E> doQuery(MappedStatement ms, Object parameter, RowBounds rowBounds, ResultHandler resultHandler, BoundSql boundSql) throws SQLException {
          Statement stmt = null;
          try {
              Configuration configuration = ms.getConfiguration();
              // 传入参数创建StatementHanlder对象来执行查询
              StatementHandler handler = configuration.newStatementHandler(wrapper, ms, parameter, rowBounds, resultHandler, boundSql);
              // 创建jdbc中的statement对象
              stmt = prepareStatement(handler, ms.getStatementLog());
              // 执行 StatementHandler  ，进行读操作
              return handler.query(stmt, resultHandler);
          } finally {
              // 关闭 StatementHandler 对象
              closeStatement(stmt);
          }
      }
  ~~~

  这里创建StatementHandler，并查询任务交给了StatementHandler

* 进入 StatementHandler.qurey()

  ~~~java
      @Override
      public <E> List<E> query(Statement statement, ResultHandler resultHandler) throws SQLException {
          String sql = boundSql.getSql();
          // 执行查询,发送sql到数据库进行查询
          statement.execute(sql);
          // 处理返回结果
          return resultSetHandler.handleResultSets(statement);
      }
  ~~~

* 然后resultSetHandler处理返回的结果集

  进入resultSetHandler.handleResultSets(statement)

  ~~~java
      //
      // HANDLE RESULT SETS
      //
      // 处理 {@link java.sql.ResultSet} 结果集
      @Override
      public List<Object> handleResultSets(Statement stmt) throws SQLException {
          ErrorContext.instance().activity("handling results").object(mappedStatement.getId());
  
          // 多 ResultSet 的结果集合，每个 ResultSet 对应一个 Object 对象。而实际上，每个 Object 是 List<Object> 对象。
          // 在不考虑存储过程的多 ResultSet 的情况，普通的查询，实际就一个 ResultSet ，也就是说，multipleResults 最多就一个元素。
          final List<Object> multipleResults = new ArrayList<>();
  
          int resultSetCount = 0;
          // 获得首个 ResultSet 对象，并封装成 ResultSetWrapper 对象
          ResultSetWrapper rsw = getFirstResultSet(stmt);
  
          // 获得 ResultMap 数组
          // 在不考虑存储过程的多 ResultSet 的情况，普通的查询，实际就一个 ResultSet ，也就是说，resultMaps 就一个元素。
          List<ResultMap> resultMaps = mappedStatement.getResultMaps();
          int resultMapCount = resultMaps.size();
          validateResultMapsCount(rsw, resultMapCount); // 校验
          while (rsw != null && resultMapCount > resultSetCount) {
              // 获得 ResultMap 对象
              ResultMap resultMap = resultMaps.get(resultSetCount);
              // 处理 ResultSet ，将结果添加到 multipleResults 中
              handleResultSet(rsw, resultMap, multipleResults, null);
              // 获得下一个 ResultSet 对象，并封装成 ResultSetWrapper 对象
              rsw = getNextResultSet(stmt);
              // 清理
              cleanUpAfterHandlingResultSet();
              // resultSetCount ++
              resultSetCount++;
          }
  
          // 因为 `mappedStatement.resultSets` 只在存储过程中使用，本系列暂时不考虑，忽略即可
          String[] resultSets = mappedStatement.getResultSets();
          if (resultSets != null) {
              while (rsw != null && resultSetCount < resultSets.length) {
                  ResultMapping parentMapping = nextResultMaps.get(resultSets[resultSetCount]);
                  if (parentMapping != null) {
                      String nestedResultMapId = parentMapping.getNestedResultMapId();
                      ResultMap resultMap = configuration.getResultMap(nestedResultMapId);
                      handleResultSet(rsw, resultMap, null, parentMapping);
                  }
                  rsw = getNextResultSet(stmt);
                  cleanUpAfterHandlingResultSet();
                  resultSetCount++;
              }
          }
  
          // 如果是 multipleResults 单元素，则取首元素返回
          return collapseSingleResultList(multipleResults);
      }
  ~~~

  到这里就直接把结果集一层一层返回

  

#### 11.2.3 Mapper代理方式使用Mybatis源码剖析

获取代理对象

~~~java
    // 前三步和传统的方式一样
    InputStream inputStream = Resources.getResourceAsStream("sqlMapConfig.xml");
    SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(inputStream);
    SqlSession sqlSession = factory.openSession();

    // 这里不在直接调用selectList()这类接口获取
    UserMapper mapper = sqlSession.getMapper(IUserMapper.class);
    //代理对象调用接口中的任意方法，执行的都是动态代理中的invoke方法
    List<Object> allUser = mapper.findAllUser();
~~~

* 获取代理对象，进入sqlSession.getMapper()方法

  ~~~java
      @Override
      public <T> T getMapper(Class<T> type) {
          return configuration.getMapper(type, this);
      }
  ~~~

* 进入configuration.getMapper(type, this)

  ~~~java
      public <T> T getMapper(Class<T> type, SqlSession sqlSession) {
          return mapperRegistry.getMapper(type, sqlSession);
      }
  ~~~

* 进入mapperRegistry.getMapper()

~~~java
    public <T> T getMapper(Class<T> type, SqlSession sqlSession) {
        // 获得 MapperProxyFactory 对象
        final MapperProxyFactory<T> mapperProxyFactory = (MapperProxyFactory<T>) knownMappers.get(type);
        // 不存在，则抛出 BindingException 异常
        if (mapperProxyFactory == null) {
            throw new BindingException("Type " + type + " is not known to the MapperRegistry.");
        }
        // 通过动态代理工厂生成实例。
        try {
            return mapperProxyFactory.newInstance(sqlSession);
        } catch (Exception e) {
            throw new BindingException("Error getting mapper instance. Cause: " + e, e);
        }
    }
~~~

其中动态代理工厂在mybatis初始的时候，就添加到knownMappers数据结构中了。

* 进入MapperProxyFactory类中的newInstance方法

  ~~~java
     //MapperProxyFactory类中的newInstance方法
      public T newInstance(SqlSession sqlSession) {
          // 创建了JDK动态代理的invocationHandler接口的实现类mapperProxy
          final MapperProxy<T> mapperProxy = new MapperProxy<>(sqlSession, mapperInterface, methodCache);
          // 调用了重载方法
          return newInstance(mapperProxy);
      }
  ~~~

* MapperProxy类源码

~~~java
/**
 * Mapper Proxy
 *
 * @author Clinton Begin
 * @author Eduardo Macarron
 */
public class MapperProxy<T> implements InvocationHandler, Serializable {

    private static final long serialVersionUID = -6424540398559729838L;
    private final SqlSession sqlSession;
    private final Class<T> mapperInterface;
    private final Map<Method, MapperMethod> methodCache;

    // 构造，传入了SqlSession，说明每个session中的代理对象的不同的！
    public MapperProxy(SqlSession sqlSession, Class<T> mapperInterface, Map<Method, MapperMethod> methodCache) {
        this.sqlSession = sqlSession;
        this.mapperInterface = mapperInterface;
        this.methodCache = methodCache;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        try {
            // 如果是 Object 定义的方法，直接调用
            if (Object.class.equals(method.getDeclaringClass())) {
                return method.invoke(this, args);

            } else if (isDefaultMethod(method)) {
                return invokeDefaultMethod(proxy, method, args);
            }
        } catch (Throwable t) {
            throw ExceptionUtil.unwrapThrowable(t);
        }
        // 获得 MapperMethod 对象
        final MapperMethod mapperMethod = cachedMapperMethod(method);
        // 重点在这：MapperMethod最终调用了执行的方法
        return mapperMethod.execute(sqlSession, args);
    }
~~~

代理对象调用的每一个方法都会到动态代理中的invoke方法中。MapperProxy实现了InvocationHandler接口，所以代理对象调用方法时会进入MapperProxy.invoke()方法中。

* 进入MapperMethod.execute(sqlSession, args)

  ~~~java
      public Object execute(SqlSession sqlSession, Object[] args) {
          Object result;
          //判断mapper中的方法类型，最终调用的还是SqlSession中的方法
          switch (command.getType()) {
              case INSERT: {
                  // 转换参数
                  Object param = method.convertArgsToSqlCommandParam(args);
                  // 执行 INSERT 操作
                  // 转换 rowCount
                  result = rowCountResult(sqlSession.insert(command.getName(), param));
                  break;
              }
              case UPDATE: {
                  // 转换参数
                  Object param = method.convertArgsToSqlCommandParam(args);
                  // 转换 rowCount
                  result = rowCountResult(sqlSession.update(command.getName(), param));
                  break;
              }
              case DELETE: {
                  // 转换参数
                  Object param = method.convertArgsToSqlCommandParam(args);
                  // 转换 rowCount
                  result = rowCountResult(sqlSession.delete(command.getName(), param));
                  break;
              }
              case SELECT:
                  // 无返回，并且有 ResultHandler 方法参数，则将查询的结果，提交给 ResultHandler 进行处理
                  if (method.returnsVoid() && method.hasResultHandler()) {
                      executeWithResultHandler(sqlSession, args);
                      result = null;
                  // 执行查询，返回列表
                  } else if (method.returnsMany()) {
                      result = executeForMany(sqlSession, args);
                  // 执行查询，返回 Map
                  } else if (method.returnsMap()) {
                      result = executeForMap(sqlSession, args);
                  // 执行查询，返回 Cursor
                  } else if (method.returnsCursor()) {
                      result = executeForCursor(sqlSession, args);
                  // 执行查询，返回单个对象
                  } else {
                      // 转换参数
                      Object param = method.convertArgsToSqlCommandParam(args);
                      // 查询单条
                      result = sqlSession.selectOne(command.getName(), param);
                      if (method.returnsOptional() &&
                              (result == null || !method.getReturnType().equals(result.getClass()))) {
                          result = Optional.ofNullable(result);
                      }
                  }
                  break;
              case FLUSH:
                  result = sqlSession.flushStatements();
                  break;
              default:
                  throw new BindingException("Unknown execution method for: " + command.getName());
          }
          // 返回结果为 null ，并且返回类型为基本类型，则抛出 BindingException 异常
          if (result == null && method.getReturnType().isPrimitive() && !method.returnsVoid()) {
              throw new BindingException("Mapper method '" + command.getName()
                      + " attempted to return null from a method with a primitive return type (" + method.getReturnType() + ").");
          }
          // 返回结果
          return result;
      }
  ~~~

  可以看出，代理对象最终还是调用了SqlSession中的方法了。

  这里还有一个点，参数转换

  进入 method.convertArgsToSqlCommandParam(args)

  ~~~java
          public Object convertArgsToSqlCommandParam(Object[] args) {
              return paramNameResolver.getNamedParams(args);
          }
  ~~~

  再进入paramNameResolver.getNamedParams(args)

  ~~~java
      public Object getNamedParams(Object[] args) {
          final int paramCount = names.size();
          // 无参数，则返回 null
          if (args == null || paramCount == 0) {
              return null;
          // 只有一个非注解的参数，直接返回首元素
          } else if (!hasParamAnnotation && paramCount == 1) {
              return args[names.firstKey()];
          } else {
              // 集合。
              // 组合 1 ：KEY：参数名，VALUE：参数值
              // 组合 2 ：KEY：GENERIC_NAME_PREFIX + 参数顺序，VALUE ：参数值
              final Map<String, Object> param = new ParamMap<>();
              int i = 0;
              // 遍历 names 集合
              for (Map.Entry<Integer, String> entry : names.entrySet()) {
                  // 组合 1 ：添加到 param 中
                  param.put(entry.getValue(), args[entry.getKey()]);
                  // add generic param names (param1, param2, ...)
                  // 组合 2 ：添加到 param 中
                  final String genericParamName = GENERIC_NAME_PREFIX + String.valueOf(i + 1);
                  // ensure not to overwrite parameter named with @Param
                  if (!names.containsValue(genericParamName)) {
                      param.put(genericParamName, args[entry.getKey()]);
                  }
                  i++;
              }
              return param;
          }
      }
  ~~~

  源码分析完了

## 第十二部分、扩展知识

#### 12.1、元数据

数据表是用来存储我们业务数据的，而元数据是用来描述数据表的，比如这个表的表结构，有哪些字段等信息。本节课我们要知道查询结果集中有哪些数据项就可以通过元数据技术获取。

**MetaData：元数据的意思**

![img](..\img-folder\wps123.jpg)

####  12.2、Mybatis源码中的设计模式

#### 12.2.1 构建者模式

Builder模式的定义是“将一个复杂对象的构建与它的表示分离，使得同样的构建过程可以创建不同的表示。”，它属于创建类模式，一般来说，如果一个对象的构建比较复杂，超出了构造函数所能包含的范围，就可以使用工厂模式和Builder模式，相对于工厂模式会产出一个完整的产品，Builder应用于 更加复杂的对象的构建，甚至只会构建产品的一个部分，直白来说，就是使用多个简单的对象-步-步构建成一个复杂的对象

例子：使用构建者设计模式来生产computer

主要步骤:

① 将需要构建的目标类分成多个部件(电脑可以分为主机、显示器、键盘、音箱等部件) ;

② 创建构建类

③ 依次创建部件

④ 将部件组装成目标对象

定义一个computer

~~~java
public class Computer {
    private String displayer;
    private String mainUnit;
    private String mouse;
    private String keyboard;
    
    public String getDisplayer() {
    	return displayer;
    }
    
    public void setDisplayer(String displayer) {
    	this.displayer = displayer;
    }
    
    public String getMainUnit() {
    	return mainUnit;
    }
    
    public void setMainUnit(String mainUnit) {
    	this.mainUnit = mainUnit;
    }
    
    public String getMouse() {
    	return mouse;
    }
    
    public void setMouse(String mouse) {
    	this.mouse = mouse;
    }
    
    public String getKeyboard() {
    	return keyboard;
    }
    
    public void setKeyboard(String keyboard) {
    	this.keyboard = keyboard;
    }
    
    @Override
    public String toString() {
        return "Computer{" +
                "displayer='" + displayer + '\'' +
                ", mainUnit='" + mainUnit + '\'' +
                ", mouse='" + mouse + '\'' +
                ", keyboard='" + keyboard + '\'' +
                '}';
}
~~~

ComputrerBuilder

~~~java
public static class ComputerBuilder{
    private ComputerBuilder target =new ComputerBuilder();
    
    public Builder installDisplayer(String displayer){
        target.setDisplayer(displayer);
        return this;
    }
    
    public Builder installMainUnit(String mainUnit){
        target.setMainUnit(mainUnit);
        return this;
    }
    
    public Builder installMouse(String mouse){
        target.setMouse(mouse);
        return this;
    }
    
    public Builder installKeybord(String keyboard){
        target.setKeyboard(keyboard);
        return this;
    }
    
    public ComputerBuilder build(){
    	return target;
    }
}
~~~

调用

~~~java
public static void main(String[] args) {
    ComputerBuilder computerBuilder = new ComputerBuilder();
    computerBuilder.installDisplayer("显示器")
    computerBuilder.installMainUnit("主机");
    computerBuilder.installKeybord("键盘");
    computerBuilder.installMouse("鼠标");
    Computer computer = computerBuilder.Builder();
    System.out.println(computer);
}
~~~



Mybatis中的体现

SqlSessionFactory的构建过程:

Mybatis的初始化工作非常复杂，不是只用一个构造函数就能搞定的。所以使用了建造者模式,使用了大量的Builder，进行分层构造，核心对象Configuration使用了XmlConfigBuilder来进行构造。

![image-20200608200654422](..\img-folder\image-20200608200654422.png)

在Mybatis环境的初始化过程中，SqlSessionFactoryBuilder 会调用XMLConfigBuilder读取所有的
MybatisMapConfig.xml和所有的*Mapper.xml文件,构建Mybatis运行的核心对象Configuration对
象，然后将该Configuration对象作为参数构建-个SqISessionFactory对象。

具体过程见源码

#### 12.2.2 工厂模式

在Mybatis中比如SqlSessionFactory使用的是工厂模式，该工厂没有那么复杂的逻辑，是-个简单工厂
模式。

简单工厂模式(Simple Factory Pattern):又称为静态工厂方法(Static Factory Method)模式，它属于创
建型模式。

在简单工厂模式中，可以根据参数的不同返回不同类的实例。简单工厂模式专门定义一个类来负责创建
其他类的实例，被创建的实例通常都具有共同的父类

例子:生产电脑

假设有一个电脑的代工生产商，它目前已经可以代工生产联想电脑了，随着业务的拓展，这个代工生产
商还要生产惠普的电脑，我们就需要用-个单独的类来专门生产电脑，这就用到了简单工厂模式。下面
我们来实现简单工厂模式:

1.创建抽象产品类

我们创建一个电脑的抽象产品类，他有一个抽象方法用于启动电脑:

~~~java
public abstract class Computer {
    /**
    *产品的抽象方法，由具体的产品类去实现
    */
    public abstract void start( ) ;
}
~~~

2.创建具体产品类

接着我们创建各个品牌的电脑，他们都继承了他们的父类Computer，并实现了父类的start方法: 

~~~java
public class LenovoComputer extends Computer {
    @Override
    public void start( ) {
    System. out . pr intln("联想电脑启动");
}
~~~

~~~java
public class HpComputer extends Computer {
    @Override 
    public void start() {
    System. out. pr intln("惠普电脑启动");
}
~~~

3.创建工厂类

接下来创建一个工厂类,它提供了一个静态方法createComputer用来生产电脑。你只需要传入你想生产的电脑的品牌，它就会实例化相应品牌的电脑对象

~~~java
public class ComputerFactory {
    public static Computer createComputer(String type){
        Computer mComputer=null;
        switch (type) {
            case "lenovo":
            	mComputer=new LenovoComputer();
            	break;
            case "hp":
            	mComputer=new HpComputer();
            	break;
        }
        return mComputer;
    }
}
~~~

客户端调用工厂类

客户端调用工厂类，传入"hp”生产 出惠普电脑并调用该电脑对象的start方法:

~~~java
public class CreatComputer {
    public static void main(String[]args){
    	ComputerFactory.createComputer("hp").start();
    }
}
~~~

Mybatis中的体现：SqlSessionFactory创建SqlSession对象使用设计模式，见源码

#### 12.2.3 代理模式

代理模式(Proxy Pattern):给某一个对象提供一个代理， 并由代理对象控制对原对象的引用。代理模式
的英文叫做Proxy，它是一种对象结构型模式，代理模式分为静态代理和动态代理，我们来介绍动态代
理。

JDK动态代理

由于java的单继承，动态生成的代理类已经继承了Proxy类的，就不能再继承其他的类，所以只能靠实现被代理类的接口的形式，故JDK的动态代理必须有接口。

另外，为何调用代理类的方法就会自动进入InvocationHandler 的 invoke（）方法呢？

其实是因为在动态代理类的定义中，构造函数是含参的构造，参数就是我们invocationHandler 实例，而每一个被代理的接口方法都会在代理类中生成一个对应的实现方法，并在实现方法中最终调用invocationHandler 的invoke方法，这就解释了为何执行代理类的方法会自动进入到我们自定义的invocationHandler的invoke方法中，然后在我们的invoke方法中再利用jdk反射的方式去调用真正的被代理类的业务方法，而且还可以在方法的前后去加一些我们自定义的逻辑。比如切面编程AOP等

举例:

创建一个抽象类， Person接口， 使其拥有- -个没有返回值的doSomething方法。

~~~java
/**
* 抽象类
*/
public interface Person {
	void doSomething();
}
~~~

创建一个名为Bob的Person接口的实现类，使其实现doSomething方法

~~~java
/**
	创建一-个名为Bob的人的实现类
*/
public class Bob implements Person {
    public void doSomething( ) {
    	System. out. println( "Bob doing something!" );
    }
}
~~~

(3)创建jDK动态代理类，使其实现InvocationHandler接口。拥有一个名为target的变量，并创建getTarget获取代理对象方法。

~~~java
/**
* JDK动态代理
* 需实现InvocationHandler接口
*/
public class JDKDynamicProxy implements InvocationHandler {
    //被代理的对象
    Person target;
    // JDKDynamicProxy构造函数
    public JDKDynamicProxy (Person person) {
    	this. target = person;
	}
	//获取代理对象
    public Person getTarget( ) {
        return (Person)Proxy.newProxyInstance(target.getClass( ).getClassLoader(),
        target.getClass().getInterfaces(),this);
    }
	//动态代理invoke方法
public Person invoke ( object proxy, Method method, Object[ ] args) throws Throwable {
    //被代理方法前执行:
    System . out . pr intln( " JDKDynamicProxy do something before!" ) ;
    //执行被代理的方法
    Person result = (Person) method. invoke(target，args) ;
    // 被代理方法后执行
    System . out . pr intln( " JDKDynamicProxy do something after!") ;
    return
    result ;
    }
}
~~~

创建JDK动态代理测试类JDKDynamicTest

~~~java
/**
* JDK动态代理测试
*/
public class JDKDynamicTest {
	public static void main(String[] args) {
        System.out.print1n( "不使用代理类,调用doSomething方法。");
        //不使用代理类
        Person person = new Bob();
        //调用doSomething方法
        person.doSomething();
        System.out.println("-------分割线------");
        System.out.print1n( "使用代理类,调用doSomething方法。");
        //获取代理类
        Person proxyPerson = new JDKDynamicProxy(new Bob( )).getTarget();
        //调用doSomething方法
        proxyPerson.doSomething();
    }
}
~~~

Mybatis中实现:

代理模式可以认为是Mybatis的核心使用的模式，正是由于这个模式，我们只需要编写Mapper . java接口，不需要实现，由Mybatis后台帮我们完成具体SQL的执行。当我们使用Configuration的getMapper方法时，会调用mapperRegistry.getMapper方法， 而该方法又会调用mapperProxyFactory.newlnstance(sqlSession)来生成一个具 体的代理。具体实现见源码