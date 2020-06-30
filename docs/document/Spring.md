# Spring框架

## 第一部分 Spring概述



### 1.1 Spring是什么

​		Spring是分层的Java SE/EE 应用一站式的轻量级开源框架，以IoC (Inverse ofControl,控制反转)和AOP (Aspect Oriented Programming，切面编程) 为内核，提供了展现层SpringMVC、持久层SpringJDBC及业务层事务管理等一站式的企业级应用技术。此外，Spring以海纳百川的胸怀整合了开源世界里众多著名的第三方框架和类库,逐渐成为使用最多的轻量级Java EE企业应用开源框架。

### 1.2 Spring历史

​        说起Spring,我们不免要提到**Spring的缔造者Rod Johnson**这位Java奇才。Rod Johnson不仅在悉尼大学获得了计算机学士学位，同时还是一位音乐学博士，也许是音乐的细胞赋予了他程序设计美学的灵感，让他成就了Spring 的简约和优雅。他不但早在1996年就涉足了Java技术，同时也对C/C++有着深厚的造诣。他参与过众多保险、电子商务和金融等行业大型项目的开发，具有丰富的实践经验。同时他还是JCP活跃的成员，是JSR-154 (Servlet2.4) 和JDO 2.0规范的专家。

​		Rod Johnson在2002年编著的**Expert One-to-One J2EE Design and Development**一书中，对Java EE正统框架臃肿、低效、脱离现实的种种学院派做法提出了质疑，并积极寻求探索革新之道。以此书为指导思想，他编写了interface21 框架，这是一个力图冲破Java EE传统开发的困境，从实际需求出发，着眼于轻便、灵巧，易于开发、测试和部署的轻量级开发框架。**Spring 框架即以iterefce2l 框架为基础**，经过重新设计，并不断丰富其内涵，于**2004年3月24日发布了1.0 正式版**。同年他又推出了一部堪称经典的力作**Expert One-to One J2EE Development without EJB**,该书在Java世界掀起了轩然大波，改变了Java开发者程序设计和开发的思考方式。在该书中，他根据自己多年丰富的实践经验，对EJB的各项笨重臃肿的结构进行了逐一的分析和否定，并分别以简洁实用的方式替换之。至此一战功成，Rod Johnson成为一一个改变Java世界的大师级人物。

​		从2004年发布第一个版本以来，Spring 逐渐占据了Java开发人员的视线，获得了开源社区一片赞誉之声， Java 开源社区里“春”色满园关不住。在著名的GitHub开源网站上，Spring 是大家始终关注的热点项目，下载量名列前茅。在国内的开源中国网站(ttp://www.oschina.net)上，Spring 也是大家关注讨论的焦点。

​		2013年，SpringSource 团队发布了Spring Framework 4.0的相关计划，这是Spring框架的下一个升级版本，首个4.0里程碑版本的主要改进包括:首次支持Java SE 8、Java EE 7及WebSocket编程。2013 年12月，发布Spring Framework 4.0正式版本。

### 1.3 Spring好处

Spring给我带来以下好处

* **方便解耦，简化开发**。通过Spring提供的IoC容器，用户可以将对象之间的依赖关系交由Spring进行控制，避免硬编码所造成的过度程序耦合。有了Spring,用户不必再为单实例模式类、属性文件解析等这些底层的需求编写代码，可以更专注于上层的应用。

* **AOP编程的支持**。通过Spring提供的AOP功能，方便进行面向切面的编程,很多不容易用传统OOP实现的功能可以通过AOP轻松应对。

* **声明式事务的支持**。在Spring中，用户可以从单调烦闷的事务管理代码中解脱出来，通过声明的方式灵活地进行事务管理，提高开发效率和质量。
* **方便程序的测试**。可以用非容器依赖的编程方式进行几乎所有的测试工作。在Spring里，测试不再是昂贵的操作，而是随手可做的事情。
* **方便集成各种优秀框架**。Spring 不排斥各种优秀的开源框架，相反，Spring 可以降低各种框架的使用难度。Spring 提供了对各种优秀框架(如Mybatis、Struts、Hibernate、Hessian、Quartz 等)的直接支持。

* **降低Java EE API的使用难度**。Spring 对很多难用的Java EE API (如JDBC、JavaMail、远程调用等)提供了-一个薄层封装，通过Spring 的简易封装，这些Java EE API的使用难度大大降低。

* **Java源码是经典的学习范例**。Spring的源码设计精妙、结构清晰、匠心独运，处处体现着大师对Java设计模式的灵活运用及对Java技术的高深造诣。Spring框架源码无疑是Java技术的最佳实践范例。如果想在短时间内迅速提高自己的Java技术水平和应用开发水平，学习和研究Spring源码将会收到意想不到的效果。

### 1.3 Spring体系结构

​		Spring核心框架由4000多个类组成，整个框架按其所属功能可以划分为5个主要模块，从整体来看，这5个主要模块几乎为企业应用提供了所需的一切，从持久层、业务层到展现层都拥有相应的支持。loC和AOP是Spring所依赖的根本。在此基础上，**Spring 整合了各种企业应用开源框架和许多优秀的第三方类库，成为Java企业应用full-stack 的开发框架**。**Spring 框架的精妙之处在于对于开发者拥有自由的选择权**，Spring不会将自己的意志强加给开发者，因为针对某个领域的问题，**Spring 往往支持多种实现方案**。当希望选用不同的实现方案时，Spring 又能保证过渡的平滑性。

![image-20200629114302424](..\img-folder\image-20200629114302424.png)

#### 1.3.1 loC
​		Spring核心模块实现了IoC的功能，它将类与类之间的依赖从代码中脱离出来，用配置的方式进行依赖关系描述，由IoC容器负责依赖类之间的创建、拼接、管理、获取等工作。BeanFactory 接口是Spring框架的核心接口，它实现了容器许多核心的功能。

​		Context模块构建于核心模块之上，扩展了BeanFactory的功能，添加了i18n国际化、Bean 生命周期控制、框架事件体系、资源加载透明化等多项功能。此外，该模块还提供了许多企业级服务的支持，如邮件服务、任务调度、JNDI获取、EJB集成、远程访问等。ApplicationContext 是Context模块的核心接口。

​		表达式语言模块是统一表达式语言(Unified EL)的一个扩展，该表达式语言用于查询和管理运行期的对象，支持设置/获取对象属性，调用对象方法，操作数组、集合等。此外，该模块还提供了逻辑表达式运算、变量定义等功能，可以方便地通过表达式串和Spring IoC容器进行交互。

#### 1.3.1 AOP
​		AOP是继OOP之后，对编程设计思想影响极大的技术之一。AOP是进行横切逻辑编程的思想，它开拓了考虑问题的思路。在AOP模块里，Spring提供了满足AOP Alliance规范的实现，还整合了AspectJ 这种AOP语言级的框架。在Spring里实现AOP编程有众多选择。Java 5.0引入java.lang.instrument，允许在JVM启动时启用一一个代理类，通过该代理类在运行期修改类的字节码，改变一个类的功能，从而实现AOP的功能。

#### 1.3.3 数据访问和集成
​		任何应用程序的核心问题是对数据的访问和操作。数据有多种表现形式，如数据表、XML、消息等，而每种数据形式又拥有不同的数据访问技术(如数据表的访问既可以直接通过JDBC，也可以通过Hibermate或MyBatis)。
​		首先，Spring 站在DAO的抽象层面，建立了一套面向DAO层的统一 的异常体系，同时将各种访问数据的检查型异常转换为非检查型异常，为整合各种持久层框架提供基础。其次，Spring通过模板化技术对各种数据访问技术进行了薄层封装，将模式化的代码隐藏起来，使数据访问的程序得到大幅简化。这样，Spring 就建立起了和数据形式及访问技术无关的统一的DAO层，借助AOP技术，Spring提供了声明式事务的功能。

#### 1.3.4 Web及远程操作
​		该模块建立在Application Context模块之上，提供了Web应用的各种工具类，如**通过Listener或Servlet初始化Spring容器，将Spring容器注册到Web容器中**。该模块还提供了多项面向Web的功能，如透明化文件上传、Velocity、 FreeMarker、 XSLT的支持。此外，Spring 可以整合Struts、 WebWork 等MVC框架。

#### 1.3.5 Web及远程访问
​		Spring自己提供了一个完整的类似于Struts的MVC框架，称为Spring MVC。据说Spring之所以也提供了一个MVC框架,是因为Rod Johnson想证明实现MVC其实是一项简单的工作。当然，如果你不希望使用Spring MVC,那么Spring对Struts、WebWork等MVC框架的整合，一定也可以给你带来方便。相对于Servlet 的MVC, Spring 在简化Portlet的开发上也做了很多工作，开发者可以从中受益。

#### 1.3.6 WebSocket
​		WebSocket提供了一个在Web应用中高效、双向的通信，需要考虑到客户端(浏览器)和服务器之间的高频和低时延消息交换。一般的应用场景有在线交易、游戏、协作、数据可视化等。

​		此外，Spring 在远程访问及Web Service上提供了对很多著名框架的整合。由于Spring框架的扩展性，特别是随着Spring 框架影响性的扩大，越来越多的框架主动支持Spring框架，使得Spring框架应用的涵盖面越来越宽广。

### 1.4  Spring框架的版本

​		Spring 4.0基于Java6.0,全面支持Java 8.0。运行Spring 4.0必须使用Java 6.0以上版本，推荐使用Java 8.0及以.上版本，如果要编译Spring 4.0，则必须使用Java 8.0。此外，Spring 保持和Java EE 6.0的兼容，同时也对Java EE 7.0提供一些早期的支持。

**Spring Framework 版本**

![image-20200629123149385](..\img-folder\image-20200629123149385.png)

Spring Framework不同版本对jdk的要求

![image-20200629123310085](..\img-folder\image-20200629123310085.png)

### 1.5 Spring子项目

​		Spring官方网站htp://spring.io/projects，可以看到Spring众多的子项目，它们构建起一个丰富的企业级应用解决方案的生态系统。在这个生态系统中，除Spring框架本身外，还有很多值得关注的子项目。从配置到安全，从普通Web应用到大数据，用户在构建应用基础设施的时候，总能从Spring子项目中找到一个适合自己的子项目。对Spring应用开发者来说，了 解这些子项目，可以更好地使用Spring;也可以通过阅读这些子项目的源代码，更深入地了解Spring的设计架构和实现原理。

![image-20200629123521879](..\img-folder\image-20200629123521879.png)

### 1.6 小结

​		全世界成千上万的项目都构建于Spring技术框架之上，Spring 已然成为事实上标准的Java技术框架。它颠覆了传统Java开发笨重难用的学院派风格，给Java开发者带来了一股敏捷便利、灵活实用的编程之风。Spring4.0在核心容器、Web、 测试、缓存、数据访问等方面进行了重大升级，全面支持Java 8.0、WebSocket、 Groovy 动态语言等，项目源码以当前灵活的Gradle构建工具进行组织，进一步增强了Spring 在Java开源领域第一开源框 架的领导地位。

## 第二部分 IOC容器

### 2.1 IOC容器概念

​		loC Inversion of Control (控制反转/反转控制)，注意它是一个技术思想，不是一个技术实现。描述的是 Java开发领域对象的创建，管理的问题。传统开发方式，比如类A依赖于类B，往往会在类A中new一个B的对象。loC思想下开发方式，我们不用自己去new对象了，而是由IoC容器(Spring框架) 去帮助我们实例化对象并且管理它，我们需要使用哪个对象，去问loC容 器要即可。

​		IoC容器，它帮助完成类的初始化与装配工作，让开发者从这些底层实现类的实例化、依赖关系装配等工作
中解脱出来，专注于更有意义的业务逻辑开发工作。这无疑是一件令人向往的事情。Spring IoC就是这样的一一个容器，它通过配置文件或注解描述类和类之间的依赖关系，自动完成类的初始化和依赖注入工作。	

​		Spring为什么会有这种“ 神奇”的力量，仅凭一个简单的配置文件，就能魔法般地实例化并装配好程序所用的Bean呢？这种“神奇”的力量归功于Java语言的反射功能。

#### 2.1.1 什么是IoC

​		IoC (Inverse of Control,控制反转)是Spring容器的内核，AOP、声明式事务等功能在此基础上开花结果。但是IoC这个重要的概念却比较晦涩难懂，不容易让人望文生义，这不能不说是一大遗憾。不过IoC确实包括很多内涵，它涉及**代码解耦**、设计模式、代码优化等问题的考量。

​		IoC (Inverse of Control)的字面意思是控制反转，它包括两方面的内容:

* 其一是控制
* 其二是反转

​       那到底是什么东西的“控制”被“反转”了呢？对于软件来说，即**某一接口具体实现类的选择控制权从调用类中移除，转交给第三方决定，即由Spring容器借由Bean配置来进行控制**。因为IoC确实不够开门见山，因此业界曾进行了广泛的讨论，最终软件界的泰斗级人物Martin Fowler提出了DI (Dependency Injection,依赖注入)的概念用来代替IoC，即让**调用类对某一接口实现类的依赖关系由第三方 (容器或协作类)注入**，**以移除调用类对某一接口实现类的依赖**。“依赖注入”这个名词显然比“控制反转”直接明了、易于理解。

#### 2.1.2 IoC解决了什么问题

​	解决对象之间的耦合问题

![image-20200629150811133](..\img-folder\image-20200629150811133.png)

#### 2.1.3 IoC和DI的区别

IoC： Inverse of Control（控制反转）

DI：Dependancy Injection（依赖注入）
怎么理解，IoC和DI描述的是同一件事情，只不过角度不一样罢了。

**IoC是站在对象（调用类对象）的角度**，某一接口具体实现类的选择控制权从调用类中移除，转交给第三方决定，对象实例化及其管理的权利交给了(反转) 给了容器。
**DI是站在容器的角度**，容器会把对象依赖的其他对象注入，比如A对象实例化过程中因为声明了一个B类型的属性，那么就需要容器把B对象注入给A。

### 2.2 Spring IoC基础

#### 2.2.1 Spring配置概述

##### 2.2.1.1 Spring容器高层视图

要使应用程序中的Spring容器成功启动，需要同时具备以下三方面的条件：

* Spring 框架的类包都已经放到应用程序的类路径下。

* 应用程序为Spring提供了完备的Bean配置信息。

* Bean 的类都已经放到应用程序的类路径下。

Spring启动时读取应用程序提供的Bean配置信息，并在Spring容器中生成一份相应的Bean配置注册表，然后根据这张注册表实例化Bean,装配好Bean之间的依赖关系，为上层应用提供准备就绪的运行环境。

Bean配置信息是Bean的元数据信息，它由以下4个方面组成：

* Bean 的实现类。

* Bean 的属性信息，如数据源的连接数、用户名、密码等。

* Bean的依赖关系，Spring根据依赖关系配置完成Bean之间的装配。

* Bean的行为配置，如生命周期范围及生命周期各过程的回调函数等。

​		Bean元数据信息在Spring容器中的内部对应物是由一个个BeanDefinition 形成的Bean注册表，Spring 实现了Bean元数据信息内部表示和外部定义的解耦。Spring 支持多种形式的Bean配置方式。Spring 1.0 仅支持基于XML的配置，Spring 2.0新增基于注解配置的支持， Spring 3.0新增基于Java类配置的支持，而Spring 4.0则新增基于Groovy动态语言配置的支持。

​		下图描述了Spring容器、Bean 配置信息、Bean 实现类及应用程序四者的相互关系。

![image-20200630144614861](..\img-folder\image-20200630144614861.png)

##### 2.2.1.2 基于xml的配置文件介绍

* **XML Schema**

​		对于基于XML的配置，Spring 1.0的配置文件采用DTD格式，Spring 2.0以后采用Schema格式，后者让不同类型的配置拥有了自己的命名空间，使得配置文件更具扩展性。此外，Spring 基于Schema配置方案为许多领域的问题提供了简化的配置方法，配置工作因此得到了大幅简化。
​		采取基于Schema的配置格式，文件头的声明会复杂一些，先看一个简单的示例，如下:

![image-20200630145700215](..\img-folder\image-20200630145700215.png)

​		要了解文件头所声明的内容，需要学习一些**XML Schema** 的知识。Schema 在文档根节点中通过xmlns对文档所引用的命名空间进行声明。在上面的代码中定义了3个命名空间。

​		① **默认命名空间**：它没有空间名，用于Spring Bean的定义。

​		② **xsi标准命名空间**：这个命名空间用于为每个文档中的命名空间指定相应的Schema样式文件，是W3C定义的标准命名空间。

​		③ **aop命名空间**：这个命名空间是Spring配置AOP的命名空间，即一一种自定义的命名空间。

​		命名空间的定义分为两个步骤:第--步指定命名空间的名称;第二步指定命名空间的Schema文档格式文件的位置，用空格或回车换行进行分隔。
​		在**第一步**中，需要指定命名空间的缩略名和全名,请看下面配置所定义的命名空间:

```
	xm1ns:aop= "http://www.springframework.org/schema/aop"
```

​		aop为命名空间的别名，一-般使用简洁易记的名称，文档后面的元素可通过命名空间别名加以区分，如<<aop:config/>>等。 而 http://ww.springframework.org/schema/aop 为空间的全限定名，习惯上用文档发布机构的官方网站和相关网站目录作为全限定名。这种命名方式既可以标识文档所属的机构，又可以很好地避免重名的问题。但从XMLSchema语法来说，别名和全限定名都可以任意命名。

​		如果命名空间的别名为空，则表示该命名空间为文档默认命名空间。文档中无命名空间前缀的元素都属于默认命名空间，如<beans/>、 <bean/>等 都属于在①处定义的默认命名空间。
​		在**第二步**中，为每个命名空间指定了对应的Schema文档格式的定义文件，定义的
语法如下:（中间用空格隔开）

​		<命名空间1>	<命名空间1Schema文件>   <命名空间2>    <命名空间2Schema文件>

​		命名空间使用全限定名，每个组织机构在发布Schema 文件后，都会为该Schema文件提供-一个引用的URL地址，一般使用这个URL地址指定命名空间对应的Schema文件。命名空间名称和对应的Schema文件地址之间使用空格或回车分隔，不同的命名空间之间也使用这种分隔方法。
​		指定**命名空间的Schema文件地址**有两个用途：**其一**，XML解析器可以获取Schema文件并对文档进行格式合法性验证；**其二**，在开发环境下，IDE可以引用Schema文件对文档编辑提供诱导功能(自动补全功能)。当然，这个Schema文件的远程地址并非一定能够访问，一般的IDE都提供了从本地类路径查找Schema文件的功能，只有找不到时才从远程加载。

​		Spring配置的Schema文件放置在各模块JAR文件内-一个名为config的目录下。

下表对部分Schema文件的用途进行了说明。

| Schema文件       | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| spring-beans.xsd | 说明: Spring 最主要的Schema,用于配置Bean<br/>命名空间: http://www.springframework.org/schema/beans<br/>Schema文件: https://www.springframework.org/schema/beans/spring-beans.xsd"> |
| spring-aop.xsd   | 说明: AOP的配置定义的Schema<br/>命名空间: http://www.springframework.org/schema/aop<br/>Schema文件: http://www.springframework.org/schema/aop/spring-aop.xsd |
| ...              | ...                                                          |

​		虽然Spring为AOP、声明事务、Java EE都提供了专门的Schema XML配置，但Spring也允许继续使用低版本的基于DTD的XML配置方式。Spring 4.0配置的升级是向后兼容的，但我们强烈建议使用新的基于Schema的配置方式。
​		除支持XML配置方式外，Spring 还支持基于注解、Java 类及Groovy的配置方式，不同的配置方式在“质”上是基本相同的，只是存在“形”的区别。

* **Bean的定义、Bean命名规范**

  具体，见《精通Spring 4.x 企业应用实战开发》5.2节

#### 2.2.2 容器实例化Bean三种方式

##### 2.2.2.1 使⽤⽆参构造函数  

​		在默认情况下，它会通过反射调⽤⽆参构造函数来创建对象。如果类中没有⽆参构造函数，将创建失败  

~~~xml
<!--配置service对象-->
<bean id="userService" class="com.lagou.service.impl.TransferServiceImpl"></bean>  
~~~

##### 2.2.2.2 使用静态方法创建

​		在实际开发中，我们使⽤的对象有些时候并不是直接通过构造函数创建出来的，它可能在创建的过程中会做很多额外的操作。此时会提供⼀个创建对象的⽅法，恰好这个⽅法是static修饰的⽅法。

~~~xml
<!--使⽤静态⽅法创建对象的配置⽅式-->
<bean id="userService" class="com.lagou.factory.BeanFactory"
factory-method="getTransferService"></bean>
~~~

##### 2.2.2.3 使用对象方法创建

​		此种⽅式和上⾯静态⽅法创建其实类似，区别是⽤于获取对象的⽅法不再是static修饰的了，⽽是
类中的⼀个普通⽅法。
​		在早期开发的项⽬中，⼯⼚类中的⽅法有可能是静态的，也有可能是⾮静态⽅法，当是⾮静态⽅法
时，即可采⽤下⾯的配置⽅式：  

~~~xml
<!--使⽤实例⽅法创建对象的配置⽅式-->
<bean id="beanFactory" class="com.lagou.factory.instancemethod.BeanFactory"></bean>
<bean id="transferService" factory-bean="beanFactory" 
      factory-method="getTransferService"></bean>
~~~

#### 2.2.3 依赖注入的方式

​		Spring支持两种依赖注入方式，分别是属性注入和构造函数注入。

##### 2.2.3.1 属性注入

​		属性注入指通过setXxx()方法注入Bean 的属性值或依赖对象。由于属性注入方式具有可选择性和灵活性高的优点，因此属性注入是实际应用中最常采用的注入方式。

① 属性注入实例

​		属性注入要求Bean提供--个默认的构造函数，并为需要注入的属性提供对应的Setter方法。Spring 先调用Bean的默认构造函数实例化Bean对象，然后通过反射的方式调用Setter方法注入属性值。来看一个简单的例子

~~~java
public class Car {
    private int maxSpeed;
    private String brand;
    private double price;

    public void setMaxSpeed(int maxSpeed) {
        this.maxSpeed = maxSpeed;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "Car{" +
                "maxSpeed=" + maxSpeed +
                ", brand='" + brand + '\'' +
                ", price=" + price +
                '}';
    }
}
~~~

~~~xml
	<!--属性注入-->
    <bean id="car" class="com.duck.pojo.Car">
        <property name="brand"><value>凯美瑞</value></property>
        <property name="maxSpeed"><value>200</value></property>
        <property name="price"><value>200000</value></property>
    </bean>

    <bean id="transferService" class="com.duck.service.impl.TransferServiceImpl">
        <!--set+ name 之后锁定到传值的set方法了，通过反射技术可以调用该方法传入对应的值-->
        <property name="AccountDao" ref="accountDao"></property>
    </bean>
~~~

~~~java
   // 测试
	@Test
    public void diWayTest(){
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
        Car car = (Car) applicationContext.getBean("car");
        System.out.println(car);
    }
~~~

测试结果

![image-20200630163214831](..\img-folder\image-20200630163214831.png)

② JavaBean关于属性命名的规范

​		Spring配置文件中<property>元素所指定的属性名和Bean实现类的Setter 方法满足，Sun JavaBean的属性命名规范: xxxx的属性对应setXxx()方法。

​		一般情况下，Java的属性变量名都以小写字母开头，如maxSpeed、brand 等，但也存在特殊的情况。考虑到一些特定意义的大写英文缩略词(如USA、XML等),JavaBean也**允许以大写字母开头的属性变量名，不过必须满足“变量的前两个字母要么全部大写, 要么全部小写”的要求**，如brand、IDCode、 IC、ICCard等属性变量名是合法的，而iC、iCcard、iDCode等属性变量名则是非法的。这个并不广为人知的JavaBean规范条款引发了众多让人困惑的配置问题。

​		当变量名是非法的时候，如果<property> name属性值的字符串前两个字母不满足“要么全部大写，要么全部小写”可能会报错。所以name的值最好满足“前两个字母不满足要么全部大写，要么全部小写”

具体报错案列见《精通Spring 4.x 企业应用实战开发》5.3.1节

##### 2.2.3.2 构造函数注入

​		构造函数注入是除属性注入外的另一种常用的注入方式，它保证一-些必要的属性在Bean实例化时就得到设置，确保Bean在实例化后就可以使用。

~~~xml
    <!--构造函数注入-->
    <!--按照类型匹配入参-->
    <bean id="constructorTypeWayCar" class="com.duck.pojo.Car">
        <constructor-arg type="java.lang.String">
            <value>雅阁</value>
        </constructor-arg>
        <constructor-arg type="int" value="200"/>
        <constructor-arg type="double">
            <value>200000</value>
        </constructor-arg>
    </bean>

    <!--按照索引匹配入参-->
    <bean id="constructorIndexWayCar" class="com.duck.pojo.Car">
        <constructor-arg index="0">
            <value>200</value>
        </constructor-arg>
        <constructor-arg index="1" value="雅阁"/>
        <constructor-arg index="2">
            <value>200000</value>
        </constructor-arg>
    </bean>

    <!--联合使用类型和索引匹配入参-->
    <bean id="constructorTypeAndIndexWayCar" class="com.duck.pojo.Car">
        <constructor-arg index="0" type="int">
            <value>200</value>
        </constructor-arg>
        <constructor-arg index="1" type="java.lang.String" value="雅阁"/>
        <constructor-arg index="2" type="double">
            <value>200000</value>
        </constructor-arg>
    </bean>

    <!--
        如果Bean构造函数入参的类型是可辨别的(非基础数据类型且入参类型各异)，
        由于Java反射机制可以获取构造函数入参的类型，即使构造函数注入的配置不提
        供类型和索引的信息，Spring依旧可以正确地完成构造函数的注入工作。
        下面Boss类构造函数的入参就是可辨别的
	-->
    <bean id="constructorSimpleWayCar" class="com.duck.pojo.Boss">
        <constructor-arg value="boss"/>
        <constructor-arg ref="constructorTypeAndIndexWayCar"/>
    </bean>
~~~

#### 2.2.4 集合类型参数注入



#### 2.2.2 启动IoC容器的方式

* JavaSE环境下启动IoC容器

  * ClassPathXmlApplicationContext，从类的根路径下加载配置文件（推荐使用）
  * FileSystemXmlApplicationContext，从磁盘路径上加载配置文件
  * AnnotationConfigApplicationContext，纯注解模式下启动容器

* JavaEE（Web)环境下启动IoC容器

  * 从xml启动容器

  ~~~xml
  <!DOCTYPE web-app PUBLIC
  "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
  "http://java.sun.com/dtd/web-app_2_3.dtd" >
  <web-app>
  <display-name>Archetype Created Web Application</display-name>
  <!--配置Spring ioc容器的配置⽂件-->
  <context-param>
  <param-name>contextConfigLocation</param-name>
  <param-value>classpath:applicationContext.xml</param-value>
  </context-param>
  <!--使⽤监听器启动Spring的IOC容器-->
  <listener>
  <listenerclass>org.springframework.web.context.ContextLoaderListener</listenerclass>
  </listener>
  </web-app> 
  ~~~

  * 从配置类启动容器

  ~~~xml
  <!DOCTYPE web-app PUBLIC
  "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
  "http://java.sun.com/dtd/web-app_2_3.dtd" >
  <web-app>
  <display-name>Archetype Created Web Application</display-name>
  <!--告诉ContextloaderListener知道我们使⽤注解的⽅式启动ioc容器-->
  <context-param>
  <param-name>contextClass</param-name>
  <paramvalue>org.springframework.web.context.support.AnnotationConfigWebAppli
  cationContext</param-value>
  </context-param>
  <!--配置启动类的全限定类名-->
  <context-param>
  <param-name>contextConfigLocation</param-name>
  <param-value>com.lagou.edu.SpringConfig</param-value>
  </context-param>
  <!--使⽤监听器启动Spring的IOC容器-->
  <listener>
  <listenerclass>org.springframework.web.context.ContextLoaderListener</listenerclass>
  </listener>
  </web-app>
  ~~~

#### 2.2.3 BeanFactory和ApplicationContext区别

​		Spring通过一个配置文件描述Bean及Bean之间的依赖关系，利用Java语言的反射功能实例化Bean并建立Bean之间的依赖关系。Spring 的IoC容器在完成这些底层工作的基础上，还提供了Bean实例缓存、生命周期管理、Bean实例代理、事件发布、资源装载等高级服务。

​		Bean工厂(com.springframework.beans. factory.BeanFactory)是Spring框架最核心的接口，它提供了高级IoC的配置机制。BeanFactory 使管理不同类型的Java对象成为可能。

​		应用上下文(com.springframework .context.ApplicationContext)建立在BeanFactory基础之上，提供了更多面向应用的功能，它提供了国际化支持和框架事件体系，更易于创建实际应用。一般称BeanFactory 为IoC容器，而称ApplicationContext为应用上下文。但有时为了行文方便，我们也将ApplicationContext称为Spring容器。

​		对于二者的用途，我们可以进行简单的划分: BeanFactory 是Spring 框架的基础设施，面向Spring本身，ApplicationContext 面向使用Spring框架的开发者，几乎所有的应用场合都可以直接使用ApplicationContext而非底层的BeanFactory。

![image-20200629173330550](..\img-folder\image-20200629173330550.png)

#### 





### 2.3 源码剖析



## 第三部分 AOP

### 3.1 AOP概念

#### 3.1.1 什么是AOP

#### 3.1.2 AOP解决了什么问题

#### 3.1.3 为什么叫做面向切面编程

### 3.2 应用

### 3.3 源码剖析

## 参考资料

《精通Spring 4.x 企业应用开发实战》 — 陈雄花 林开雄 文建国 编著