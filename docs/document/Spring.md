



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

##### 2.2.1.3 简化配置方式

具体，见《精通Spring 4.x 企业应用实战开发》5.4.7

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

① **属性注入实例**

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

② **JavaBean关于属性命名的规范**

​		Spring配置文件中<property>元素所指定的属性名和Bean实现类的Setter 方法满足，Sun JavaBean的属性命名规范: xxxx的属性对应setXxx()方法。

​		一般情况下，Java的属性变量名都以小写字母开头，如maxSpeed、brand 等，但也存在特殊的情况。考虑到一些特定意义的大写英文缩略词(如USA、XML等),JavaBean也**允许以大写字母开头的属性变量名，不过必须满足“变量的前两个字母要么全部大写, 要么全部小写”的要求**，如brand、IDCode、 IC、ICCard等属性变量名是合法的，而iC、iCcard、iDCode等属性变量名则是非法的。这个并不广为人知的JavaBean规范条款引发了众多让人困惑的配置问题。

​		当变量名是非法的时候，如果<property> name属性值的字符串前两个字母不满足“要么全部大写，要么全部小写”可能会报错。所以name的值最好满足“前两个字母不满足要么全部大写，要么全部小写”

具体报错案列见《精通Spring 4.x 企业应用实战开发》5.3.1节



③ **集合类型参数注入**

​		java.util包中的集合类型是最常用的数据结构类型，主要包括List、 Set、 Map、Properties，Spring 为这些集合类型属性提供了专属的配置标签。

~~~java
public class Boss {
    private String name;
    private Car car;
    private List<House> houseList;
    private Set<Child> children;
    private Map<Object,Object> jobs;
    private Properties mails;
    private Map<String,Integer> jobTime;

    public Boss(){

    }
    public Boss(String name, Car car) {
        this.name = name;
        this.car = car;
    }

    public Boss(String name, Car car, List<House> houseList) {
        this.name = name;
        this.car = car;
        this.houseList = houseList;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    public void setHouseList(List<House> houseList) {
        this.houseList = houseList;
    }

    public void setChildren(Set<Child> children) {
        this.children = children;
    }

    public void setJobs(Map<Object, Object> jobs) {
        this.jobs = jobs;
    }

    public void setMails(Properties mails) {
        this.mails = mails;
    }

    public void setJobTime(Map<String, Integer> jobTime) {
        this.jobTime = jobTime;
    }

    @Override
    public String toString() {
        return "Boss{" +
                "name='" + name + '\'' +
                ", car=" + car +
                ", houseList=" + houseList +
                ", children=" + children +
                ", jobs=" + jobs +
                ", mails=" + mails +
                ", jobTime=" + jobTime +
                '}';
    }
}
~~~

~~~xml
    <!--集合类型参数注入-->
    <bean id="house1" class="com.duck.pojo.House">
        <property name="size" value="100"/>
        <property name="address" value="大学城"/>
    </bean>
    <bean id="house2" class="com.duck.pojo.House">
        <property name="size" value="120"/>
        <property name="address" value="大学城"/>
    </bean>
    <bean id="child1" class="com.duck.pojo.Child">
        <property name="name"><value>张三</value></property>
        <property name="age" ><value>18</value></property>
        <property name="sex" ><value>男</value></property>
    </bean>
    <bean id="child2" class="com.duck.pojo.Child">
        <property name="name" value="李四" />
        <property name="age"  value="16"/>
        <property name="sex" value="男"/>
    </bean>


    <!--list集合-->
    <bean id="myboss" class="com.duck.pojo.Boss">
        <property name="name" value="boss"/>
        <property name="car" ref="attributeWayCar"/>
        <property name="houseList">
            <list>
                <ref bean="house1"/>
                <ref bean="house2"/>
            </list>
        </property>
    </bean>

    <!--set集合-->
    <bean id="myboss1" class="com.duck.pojo.Boss">
        <property name="name" value="boss"/>
        <property name="car" ref="attributeWayCar"/>
        <property name="children">
            <set>
                <ref bean="child1"/>
                <ref bean="child2"/>
            </set>
        </property>
    </bean>

    <!--Map集合-->
    <bean id="myboss2" class="com.duck.pojo.Boss">
        <property name="name" value="boss"/>
        <property name="car" ref="attributeWayCar"/>
        <property name="jobs">
            <map>
                <entry>
                    <key><value>AM</value></key>
                    <value>看书</value>
                </entry>
                <entry>
                    <key><value>M</value></key>
                    <value>睡觉</value>
                </entry>
            </map>
        </property>
    </bean>

    <!--Properties-->
    <bean id="myboss3" class="com.duck.pojo.Boss">
        <property name="name" value="boss"/>
        <property name="car" ref="attributeWayCar"/>
        <property name="mails">
            <props>
                <prop key="jobMail">jobmail@job.com</prop>
                <prop key="lifeMail">lifeMail@job.com</prop>
            </props>
        </property>
    </bean>

    <!--强类型集合-->
    <bean id="myboss4" class="com.duck.pojo.Boss">
        <property name="jobTime">
            <map>
                <entry>
                    <key><value>AM</value></key>
                    <value>2020070209</value>
                </entry>
                <entry>
                    <key><value>PM</value></key>
                    <value>2020070214</value>
                </entry>
            </map>
        </property>
    </bean>
~~~





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

#### 2.2.4 整合多个配置文件

​		对于一个大型应用来说，可能存在多个XML配置文件，在启动Spring容器时，可以通过一一个String数组指定这些配置文件。Spring 还允许通过<import>将多个配置文件引入到一一个文件中，进行配置文件的集成。这样，在启动Spring容器时，仅需指定这个合并好的配置文件即可。

~~~xml
<import resource="classpath:applicationContext1.xml"/>
~~~

​		对于大型应用来说，为了防止开发时配置文件的资源竞争，或者为了使模块便于拆卸，往往每个模块都拥有自己独立的配置文件。应用层面提供了一个整合的配置文件，通过<import>将各个模块整合起来。这样，在容器启动时，只需加载这个整合的配置文件即可。

#### 2.2.5 Bean作用域

​		在配置文件中定义Bean时，用户不但可以配置Bean的属性值及相互之间的依赖关系，还可以定义Bean的作用域。作用域将对Bean的生命周期和创建方式产生影响。

##### 2.2.5.1 作用域介绍

| 类型          | 说明                                                         |
| ------------- | ------------------------------------------------------------ |
| singleton     | 在Spring loC容器中仅存在一一个Bean实例，Bean 以单实例的方式存在。默认为singleton |
| prototype     | 每次从容器中调用Bean 时，都返回一个新的实例，即每次调用getBean()时， 相当于执行new XxxBean()操作 |
| request       | 每次HTTP请求都会创建一个新的Bean。该作用域仅适用于WebApplicationContext环境 |
| session       | 同一个HTTP Session 共享一个Bean,不同的HTTP Session 使用不同的Bean。该作用域仅适用于WebApplicationContext环境 |
| globalSession | 同一个全局Session 共享一个Bean， 一般用于Portlet 应用环境。该作用域仅适用于WebApplicationContext环境 |

##### 2.2.5.2 与Web应用环境相关的Bean作用域

如果用户使用Spring的WebApplicationContext,则可使用另外3种Bean的作用域:request. session 和globalSession。不过在使用这些作用域之前，**首先必须在Web容器中进行一些额外的配置**。

* 在低版本的Web容器中(Servlet 2.3 之前)，用户可以使用HTTP请求过滤器进行

~~~xml
<web-app>
<filter>
<filter-name>requestContextFilter </filter-name>
<filter-class>org . springframework . web . filter RequestContextFilter </filter-class>
</filter>
<filter-mapping>
<filter-name>requestContextFilter</filter-name>
<!--对所有的URL进行过滤拦截-->
<url-pattern>/*</url-pattern>
</filter-mapping>
</web-app>
~~~

* 在高版本的Web容器中，则可以利用HTTP请求监听器进行配置。

~~~xml
<web-app>
    <listener>
        <listener-class>
            org.springframework.web.context.request.RequestContextListener
        </1istener-class>
    </listener>
     ...
</web-app>
~~~

在WebApplicationContext初始化时，已经通过ContextLoaderListener (或ContextLoaderServlet)将Web容器与Spring容器进行了整合，为什么在这里又要引入-一个额外的RequestContextListener以支持Bean的另外3个作用域呢?通过分析两个监听器的源码，一切疑问就真相大白了，如下图。

![image-20200702161258348](..\img-folder\image-20200702161258348.png)


​		在整合Spring容器时使用ContextL oaderListener，它实现了ServletContextListener监听器接口，ServletContextListener 只负责监听Web容器启动和关闭的事件。而RequestContextListener实现了ServletRequestListener 监听器接口，该监听器监听HTTP请求事件，Web服务器接收的每一次请求都会通知该监听器。

​		Spring容器启动和关闭操作由Web容器的启动和关闭事件触发，但如果Spring容器中的Bean需要request、session 和globalSession作用域的支持，Spring 容器本身就必须获得Web容器的HTTP请求事件，以HTTP请求事件“驱动”Bean作用域的控制逻辑。也就是说，通过配置RequestContextL istener, Spring 容器和Web容器的结合更加密切，Spring容器对Web容器中的“风吹草动”都能够察觉，因而就可以实施Web相应Bean作用域的控制了。

​		当然，Spring完全可以提供一个既实现ServletContextListener又实现ServletContextListener接口的监听器，这样我们仅需配置-次就可以了。 探究Spring将二者分开的原因，可能出于两个方面的考虑:第一，考虑版本兼容的问题，毕竟针对Web应用的Bean作用域是从Spring2.0开始提供的；第二，这3种新增的Bean作用域的适用场合并不多，用户往往并不真的需要这些新增的Bean作用域。

##### 2.2.5.3 小结

​		除了以上5种预定义的Bean作用域外，Spring 还允许用户自定义Bean的作用域。可以先通过org.springframework.beans. factory.config.Scope接口定义新的作用域，再通过org.springframework. beans.factory.confg.CustomScopeConfigurer这个BeanFactoryPostProcessor注册自定义的Bean作用域。在一般的应用中，Spring 所提供的作用域已经能够满足应用的要求，用户很少需要自定义新的Bean作用域。



#### 2.2.6 基于注解的配置

##### 2.2.6.1 使用注解定义bean

​		不管是XML还是注解，它们都是表达Bean定义的载体，其实质都是为Spring容器提供Bean定义的信息，在表现形式上都是将XML定义的内容通过类注解进行描述。Spring 从2.0开始就引入了基于注解的配置方式，在2.5时得到了完善，在4.0时进一步增强。

我们知道，Spring 容器成功启动的三大要件分别是Bean定义信息、Bean 实现类及Spring本身。如果采用基于XML的配置，则Bean定义信息和Bean实现类本身是分离的；而如果采用基于注解的配置文件，则Bean定义信息通过在Bean实现类上标注注解实现。
下面是使用注解定义一个DAO的Bean:

~~~java
// ①
@Component("userDao")
public class UserDaoImpl {
    // ...
}
~~~

在①处使用@Component注解在UserDao类声明处对类进行标注，它可以被Spring容器识别，Spring容器自动将POJO转换为容器管理的Bean。
它和以下XML配置是等效的:

~~~xml
<bean id="userDao" class="com.duck.dao.imp.UserDaoImpl"/>
~~~

除**@Component**外，Spring 还提供了**3个功能基本和@Component等效的注解**，分别用于对DAO、Service 及Web层的Controller进行注解。

* **@Repository**: 用于对DAO实现类进行标注。
* **@Service**: 用于对Service 实现类进行标注。

* **@Controller**: 用于对Controller实现类进行标注。

之所以要在@Component之外提供这3个特殊的注解，是为了让标注类本身的用途清晰化，完全可以用@Component替代这3个特殊的注解。但是，我们推荐使用特定的注解标注特定的Bean，毕竟这样一眼就可以看出Bean的真实身份。

##### 2.2.6.2 扫描注解定义的Bean

​		Spring提供了一个context命名空间，它提供了通过扫描类包以应用注解定义Bean的方式

~~~xml
<!--①声明context命名空间-->
<beans  xmlns="http://www.springframework.org/schema/beans"
        xmlns:context="http://www.springframework.org/schema/context"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.springframework.org/schema/beans
            https://www.springframework.org/schema/beans/spring-beans.xsd
            http://www.springframework.org/schema/context
            https://www.springframework.org/schema/context/spring-context.xsd">

    <!--②扫描注解定义的Bean-->
    <context:component-scan base-package="com.duck"/>
    
</beans>    
~~~

​		在①处声明context命名空间，在②处即可通过context命名空间的component-scan的base-package属性指定一个需要扫描的基类包，Spring 容器将会扫描这个基类包里的所有类，并从类的注解信息中获取Bean的定义信息。
如果仅希望扫描特定的类而非基包下的所有类，那么可以使用resource-pattern属性过滤出特定的类，如下:

~~~xml
<context:component-scan base-package="com.duck" resource-pattern="anno/*.class"/>
~~~

​		这里将基类包设置为com.smart; 默认情况下resource-pattern 属性的值为“**/* .class"，即基类包里的所有类，将其设置为“anno/* .class"，则Spring仅会扫描基类包里anno子包中的类。

##### 2.2.6.3 自动装配Bean

1. **@Autowired**注解进行依赖注入

   **通过@Autowired注解实现Bean的依赖注入**，@Autowired 默认按类型(byType) 匹配的方式在容器中查找匹配的Bean,当有且仅有一个匹配的Bean时，Spring 将其注入@Autowired标注的变量中。

   使用@Autowired的required属性
   如果容器中没有一个和标注变量类型匹配的Bean，那么Spring容器启动时将报NoSuchBeanDefinitionException异常。如果希望Spring即使找不到匹配的Bean完成注入也不要抛出异常,那么可以使用@Autowired(required=false)进行标注。在默认情况下,@Autowired的required属性值为ture,即要求必须找到匹配的Bean,否则将报异常。

   对类方法进行标注，@Autowired可以对类**成员变量**及**方法的入参**进行标注

2. **@Qualifier**指定注入Bean的名称。
   如果容器中有一个以上匹配的Bean时，则可以通过@Qualifier注解限定Bean的名称

3. **@Lazy**注解对延迟依赖注入的支持
   Spring 4.0支持延迟依赖注入，即在Spring容器启动的时候，对于在Bean上标注@Lazy及@Autowired注解的属性，不会立即注入属性值，而是延迟到调用此属性的时候才会注入属性值。

4. **@Resource**、**@Inject**标准注解
   此外，Spring还支持JSR-250中定义的**@Resource**和JSR-330中定义的**@Inject**注解，这两个标准注解和@Autowired注解的功用类似，都是对类变更及方法入参提供自动注入功能。@Resource 注解要求提供一个Bean名称的属性，如果属性为空，则自动采用标注处的变量名或方法名作为Bean的名称。（需要引入javax.annotation-api.jar包）

   **@Autowired默认按类型匹配注入Bean**, **@Resource 则按名称匹配注入Bean**。而**@Inject和@Autowired同样也是按类型匹配注入Bean的，只不过它没有required**属性。可见，不管是@Resource还是@Inject注解，其功能都没有@Autowired丰富，因此，除非必要，大可不必在乎这两个注解。

5. **@Scope**注解定义Bean作用范围

   通过注解配置的Bean 和通过xml标签配置的Bean一样，默认的作用范围都是singleton。Spring 为注解配置提供了一个@Scope 注解，可以通过它显式指定Bean的作用范围。

6. **@PostConstruct 、@PreDestroy**

   **@PostConstruct 、@PreDestroy**注解分别定义Bean初始化和容器销毁前Bean执行的方法。这个跟使用xml标签<bean>的init-method、destroy-method时一样的效果。区别是，可以使用**@PostConstruct 、@PreDestroy** 标注多个方法。

   

   具体使用实例如下：

   ~~~~java
   @Lazy
   @Scope("singleton")
   @Repository("accountDao")
   public class JdbcAccountDaoImpl implements AccountDao {
   
       @Autowired
       private ConnectionUtils connectionUtils;
       
       // ...
   }
   
   
   @Service("transferService")
   public class TransferServiceImpl implements TransferService {
   
       // @Autowired的required属性默认为true，要求必须匹配bean，否则报异常
       // 如果希望Spring容器即使找不到匹配的bean注入，也不要抛异常，可以使用@Autowired(required=false)进行配置
       // 容器中如果有一个以上相同类型的bean时，可以通过@Qualifier("beanId")来确定时哪哪一个
       @Autowired
       @Qualifier("accountDao")
       private AccountDao accountDao;
       
       // ...
   }
   ~~~~

   ~~~java
   @Component
   public class Dog {
   
       public Dog(){
           System.out.println("Dog Constructor ...");
       }
   
       @PostConstruct
       public void init(){
           System.out.println("dog init ...");
       }
   
       @PostConstruct
       public void init1(){
           System.out.println("dog init1 ...");
       }
   
       public void move(){
           System.out.println("move");
       }
   
       @PreDestroy
       public void destroy(){
           System.out.println("dog destroy ...");
       }
   
       @PreDestroy
       public void destroy1(){
           System.out.println("dog destroy1 ...");
       }
   }
   ~~~

   

#### 2.2.7 基于java类的配置

具体，见《精通Spring 4.x 企业应用实战开发》5.11

#### 2.2.8 lazy-Init延迟加载

* **Bean的延迟加载**

  ApplicationContext容器的默认行为是在启动服务器时将所有singleton bean提前进行实例化。提前
  实例化意味着作为初始化过程的一部分。

  ~~~xml
  <bean id="connectionUtils" class="com.duck.utils.ConnectionUtils"></bean>
  该bean默认设置为：
  <bean id="connectionUtils" class="com.duck.utils.ConnectionUtils" lazy-init="false"></bean>
  ~~~

  lazy-init="false"，立即加载，表示在spring启动时， 立刻进行实例化。如果不想让一个singleton bean在ApplicationContext实现初始化时被提前实例化，那么可以将bean设置为延迟实例化。

  ~~~xml
  <bean id="connectionUtils" class="com.duck.utils.ConnectionUtils" lazy-init="true"></bean>
  ~~~

  ​        设置lazy-init为true的bean将不会在ApplicationContext启动时提前被实例化，而是第一次向容器通过getBean索取bean时实例化的。
  ​		如果一个设置了立即加载的bean1,引用了一个延迟加载的bean2，那么bean1在容器启动时被实例化，而bean2由于被bean1引用，所以也被实例化，这种情况也符合延时加载的bean在第一次调用时才被实例化的规则。
  ​		**如果一个bean的scope属性为scope="pototype"时，即使设置了lazy-init="false"， 容器启动时也不**
  **会实例化bean，而是在调用getBean方法时实例化的。**

* **延迟加载应用场景**：

  （1）开启延迟加载一 定程度提高容器启动和运转性能

  （2）对于不常使用的Bean设置延迟加载，这样偶尔使用的时候再加载，不必要从一开始该Bean就占
  用资源

#### 2.2.8 启动IoC容器的方式

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

#### 2.2.9 BeanFactory和ApplicationContext区别

​		Spring通过一个配置文件描述Bean及Bean之间的依赖关系，利用Java语言的反射功能实例化Bean并建立Bean之间的依赖关系。Spring 的IoC容器在完成这些底层工作的基础上，还提供了Bean实例缓存、生命周期管理、Bean实例代理、事件发布、资源装载等高级服务。

​		Bean工厂(com.springframework.beans. factory.BeanFactory)是Spring框架最核心的接口，它提供了高级IoC的配置机制。BeanFactory 使管理不同类型的Java对象成为可能。

​		应用上下文(com.springframework .context.ApplicationContext)建立在BeanFactory基础之上，提供了更多面向应用的功能，它提供了国际化支持和框架事件体系，更易于创建实际应用。一般称BeanFactory 为IoC容器，而称ApplicationContext为应用上下文。但有时为了行文方便，我们也将ApplicationContext称为Spring容器。

​		对于二者的用途，我们可以进行简单的划分: BeanFactory 是Spring 框架的基础设施，面向Spring本身，ApplicationContext 面向使用Spring框架的开发者，几乎所有的应用场合都可以直接使用ApplicationContext而非底层的BeanFactory。

![image-20200629173330550](..\img-folder\image-20200629173330550.png)

#### 2.2.10 BeanFactory 和FactoryBean的区别

​		BeanFactory接口是容器的顶级接口，定义了容器的一些基础行为，负责生产和管理Bean的一个工厂,具体使用它下面的子接口类型，比如ApplicationContext。

​		Spring中Bean有两种，一种是普通Bean，一种是工厂Bean (FactoryBean) ，FactoryBean可以生成某一个类型的Bean实例(返回给我们)， 也就是说我们可以借助于它自定义Bean的创建过程。Bean创建的三种方式中的静态方法和实例化方法和FactoryBean作用类似，FactoryBean使用较多， 尤其在Spring框架一些组件中会使用， 还有其他框架和Spring框架整合时使用。可以让我们自定义Bean的创建过程(完成复杂Bean的定义)

~~~java
//FactoryBean接口源码
public interface FactoryBean<T> {
@Nullable
	//返回FactoryBean创建的Bean实例，如果isSingleton返回true,则该实例会放到Spring容器
    //的单例对象缓存池中Map
	T getObject( ) throws Exception;
	@Nullable
	//返回FactoryBean创建 的Bean类型
	Class<?> getobjectType();
	//返回作用域是否单例
	default boolean isSingleton() {
	return true;
}
~~~

~~~java
public class Company {
	private String name;
	private String address;
	private int scale;
	
    public String getName() {
		return name;CompanyFactoryBean类
	}
    public void setName(String name) {
    	this.name = name;
    }
    public String getAddress() {
    	return address;
    }
    public void setAddress(String address) {
    	this.address = address;
    }
    public int getScale() {
    	return scale;
    }
    public void setScale(int scale) {
    	this.scale = scale;
    }
    
    
    @Override
    public String toString() {
        return "Company{" +
        "name='" + name + '\'' +
        ", address='" + address + '\'' +
        ", scale=" + scale +
        '}';
    }
}
~~~

~~~java
public class CompanyFactoryBean implements FactoryBean<Company> {
    private String companyInfo; // 公司名称,地址,规模
    public void setCompanyInfo(String companyInfo) {
        this.companyInfo = companyInfo;
    }
    
    @Override
    public Company getObject() throws Exception {
        // 模拟创建复杂对象Company
        Company company = new Company();
        String[] strings = companyInfo.split(",");
        company.setName(strings[0]);
        company.setAddress(strings[1]);
        company.setScale(Integer.parseInt(strings[2]));
        return company;
    }
    
    @Override
    public Class<?> getObjectType() {
        return Company.class;
    }
    
    @Override
    public boolean isSingleton() {
        return true;
    }
}
~~~

~~~xml
<bean id="companyBean" class="com.duck.factory.CompanyFactoryBean">
	<property name="companyInfo" value="百度,中关村,500"/>
</bean>
~~~

~~~java
Object companyBean = applicationContext.getBean("companyBean");
System.out.println("bean:" + companyBean);
// 结果如下
bean:Company{name='拉勾', address='中关村', scale=500}

// 测试，获取FactoryBean，需要在id之前添加“&
Object companyBean = applicationContext.getBean("&companyBean");
System.out.println("bean:" + companyBean);
// 结果如下
bean:com.lagou.edu.factory.CompanyFactoryBean@53f6fd09
~~~

#### 2.2.11 后置处理器

Spring提供了两种后处理bean的扩展接口，分别为**BeanPostProcessor**和**BeanFactoryPostProcessor**,两者在使用上是有所区别的。

工厂初始化（BeanFactory） —> Bean对象

在BeanFactory初始化之后可以使用BeanFactoryPostProcessor进行后置处理做一些事情

在Bean对象实例化（并不是Bean的整个生命周期完成）之后可以使用BeanPostProcessor进行后置处
理，做一些事情。

注意: 对象不一定是springbean,而springbean一定是个对象
SpringBean的生命周期

* **BeanPostProcessor**

  BeanPostProcessor是针对Bean级别的处理，可以针对某个具体的Bean。

  ~~~java
  public interface BeanPostProcessor {
  	@Nullable
  	default Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
  		return bean;
  	}
      
  		@Nullable
  	default Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
  		return bean;
  	}
  	}
  ~~~

  该接⼝提供了两个⽅法，分别在Bean的初始化⽅法前和初始化⽅法后执⾏，具体这个初始化⽅法指的是
  什么⽅法，类似我们在定义bean时，定义了init-method所指定的⽅法。
  **定义⼀个类实现了BeanPostProcessor，默认是会对整个Spring容器中所有的bean进⾏处理**。**如果要对**
  **具体的某个bean处理，可以通过⽅法参数判断**，两个类型参数分别为Object和String，第⼀个参数是每
  个bean的实例，第⼆个参数是每个bean的name或者id属性的值。所以我们可以通过第⼆个参数，**来判**
  **断我们将要处理的具体的bean**。
  注意：处理是发⽣在Spring容器的实例化和依赖注⼊之后。  

* **BeanFactoryPostProcessor**  

  BeanFactory级别的处理，是针对整个Bean的⼯⼚进⾏处理，典型应⽤:PropertyPlaceholderConfigurer  

  ~~~java
  // 源码
  @FunctionalInterface
  public interface BeanFactoryPostProcessor {
      void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException;
  }
  ~~~

  此接⼝只提供了⼀个⽅法，⽅法参数为ConfigurableListableBeanFactory，该参数类型定义了⼀些⽅法  

  ![image-20200702210006356](..\img-folder\image-20200702210006356.png)

  其中有个⽅法名为getBeanDefinition的⽅法，我们可以根据此⽅法，找到我们定义bean 的BeanDefinition对象。然后我们可以对定义的属性进⾏修改，以下是BeanDefinition中的⽅法  

  <img src="..\img-folder\image-20200702210123151.png" alt="image-20200702210123151" style="zoom:100%;" />

  ⽅法名字类似我们bean标签的属性， setBeanClassName对应bean标签中的class属性，所以当我们拿
  到BeanDefinition对象时，我们可以⼿动修改bean标签中所定义的属性值。
  BeanDefinition对象： 我们在 XML 中定义的 bean标签， Spring 解析 bean 标签成为⼀个 JavaBean，
  这个JavaBean 就是 BeanDefinition
  注意：调⽤ BeanFactoryPostProcessor ⽅法时，这时候bean还没有实例化，此时 bean 刚被解析成
  BeanDefinition对象  

#### 2.2.12 属性编辑器

​		在Spring配置文件里，往往通过字面值为Bean各种类型的属性提供设置值:不管是double类型还是int类型，在配置文件中都对应字符串类型的字面值。BeanWrapper在填充Bean属性时如何将这个字面值正确地转换为对应的double或int等内部类型呢?我们可以隐约地感觉到一定有一个转换器在“暗中相助”，这个转换器就是属性编辑器。

具体，见《精通Spring 4.x 企业应用实战开发》6.2

#### 2.2.13 使用外部属性文件

在进行数据源或邮件服务器等资源的配置时,用户可以直接在Spring配置文件中配置用户名/密码、链接地址等信息。但一种更好的做法是将这些配置信息独立到一个外部属性文件中，并在Spring配置文件中通过形如$ {user}、$ {password}的占位符引用属性文件中的属性项。这种配置方式拥有两个明显的好处。

* 减少维护的工作量:资源的配置信息可以被多个应用共享，在多个应用使用同一资源的情况下，如果资源用户名/密码、链接地址等配置信息发生更改，则用户只需调整独立的属性文件即可。
* 使部署更简单: Spring配置文件主要描述应用工程中的Bean, 这些配置信息在开发完成后就基本固定下来了。但数据源、邮件服务器等资源配置信息却需要在部署时根据现场情况确定。如果通过一个独立的属性文件存放这些配置信息，则部署人员只需调整这个属性文件即可，根本不需要关注结构复杂、信息量大的Spring配置文件。这不仅给部署和维护带来了方便，也降低了出错的概率。

Spring提供了一个 PropertyPlaceholderConfigurer,它能够使Bean在配置时引用外部属性文件。PropertyPlaceholderConfigurer 实现了BeanFactoryPostProcessorBean 接口，因而也是一个Bean工厂后处理器。

~~~xml
<!--引入jdbc.properties属性文件-->
<bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer"
    p:location="classpath:jdbc.properties"
    p:fileEncoding="utf-8"/>

<!--通过属性名引用属性值-->
<bean id="dataSource" class="org.apache .commons.dbcp.BasicDataSource"
    destroy-method="close"
    p:driverClassName="$ {driverClassName}"
    p:url="${ur1}"
    p:username-"${userName}"
    p:password="${password}"/>



~~~

具体，见《精通Spring 4.x 企业应用实战开发》6.3

#### 2.2.14 国际化

具体，见《精通Spring 4.x 企业应用实战开发》6.4

#### 2.2.15 容器事件

具体，见《精通Spring 4.x 企业应用实战开发》6.5

#### 2.2.16 Spring容器技术内幕

具体，见《精通Spring 4.x 企业应用实战开发》6.1

### 2.3 源码剖析



## 第三部分 AOP

### 3.1 AOP概念

​		编程语言的终极目标就是能以更自然、更灵活的方式**模拟世界**，从原始机器语言到面向过程语言再到面向对象语言，编程语言一步步地用更自然、更灵活的方式编写软件。AOP是软件开发思想发展到一定阶段的产物，但AOP的出现并不是要完全替代OOP,而仅作为0OP的有益补充。

​		**AOP是有特定的应用场合**的，它只适合那些具有横切逻辑的应用场合，如**性能监测**、**访问控制**、**事务管理**及日志记录(虽然有很多文章用日志记录作为讲解AOP的实例，但很多人认为很难用AOP编写实用的程序日志)。不过，这丝毫不影响AOP作为一种新的软件开发思想在软件开发领域所占有的地位。

​		AOP的工作重心在于**如何将增强应用于目标对象的连接点上**。这里包括两项工作：第一，**如何通过切点和增强定位到连接点上**；第二，**如何在增强中编写切面的代码**。

#### 3.1.1 什么是AOP

​		AOP是Aspect Oriented Programing的简称，最初被译为“面向方面编程”，这个翻译向来为人所诟病，但是由于先入为主的效应，受众广泛，所以这个翻译依然被很多人使用。但我们更倾向于用“面向切面编程”的译法，因为它更加达意。按照软件重构思想的理念，如果多个类中出现相同的代码，则应该考虑定义一个父类，将这些相同的代码提取到父类中。通过引入父类消除多个类中重复代码的方式在大多数情况下是可行的，但世界并非永远这样简单，请看如下代码。

~~~java
package com.smart.concept;
public class ForumService {
    private TransactionManager transManager;
    private Per fo rmanceMonitor pmonitor;
    private TopicDao topicDao;
    private ForumDao forumDao;
    
    public void removeTopic(int topicId) {
        pmonitor.start();
        transManager.beginTransaction();
        topicDao.removeTopic(topicId); // 1 
        transManager.commit();
        pmonitor.end() ;
    }
    
    public void createForum (Forum forum) {
        pmonitor.start();
        transManager.beginTransaction() ;
        forumDao.create (forum); // 2 
        transManager.commit();
        pmonitor.end();
    }
}

~~~

​		上面代码中，pmonitor.start()、pmonitor.end()方法是性能监视代码，它在方法调用前启动，在方法调用返回前结束，并在内部记录性能监视的结果信息。而transManager.beginTransaction()、transManager.commit()是事务开始和事务提交的代码。我们发现①、②处的业务代码淹没在重复化非业务性的代码之中，性能监视和事务管理这些非业务性代码包围着业务性代码。

​		假设将ForumService 业务类看成一段圆木， 将removeTopic()和createForum()方法分别看成圆木的一截，会发现性能监视和事务管理的代码就好像一个年轮，而业务代码是圆木的树心，这也正是横切代码概念的由来。

![image-20200706103511383](..\img-folder\image-20200706103511383.png)

​		我们无法通过抽象父类的方式消除如上所示的重复性横切代码，因为这些横切逻辑依附在业务类方法的流程中，它们不能转移到其他地方去。AOP独辟蹊径,通过横向抽取机制为这类无法通过纵向继承体系进行抽象的重复性代码提供了解决方案。

​		将这些重复性的横切逻辑独立出来是很容易的，但如何将这些独立的逻辑融合到业务逻辑中以完成和原来一样的业 务流程，才是事情的关键，这也正是AOP要解决的主要问题。

#### 3.1.2 AOP术语

1. 连接点

   ​		特定点是程序执行的某个特定位置，如类开始初始化前、类初始化后、类的某个方法调用前/调用后、方法抛出异常后。一个类或一段程序代码拥有一些具有边界性质的特定点，这些代码中的特定点就被称为“连接点”。**Spring仅支持方法的连接点**，即仅能在方法调用前、方法调用后、方法抛出异常时及方法调用前后这些程序执行点织入增强。我们知道，黑客攻击系统需要找到突破口，没有突破口就无法进行攻击。从某种程度上来说，AOP也可以看成一个黑客(因为它要向目前类中嵌入额外的代码逻辑)，连接点就是AOP向目标类打入楔子的候选锚点。

   ​		连接点由两个信息确定：一是用**方法表示的程序执行点**；二是用**相对位置表示的方位**。如在Test.foo()方法执行前的连接点，执行点为Test.foo()，方位为该方法执行前的位置。Spring使用切点对执行点进行定位，而方位则在增强类型中定义。

2. 切点

3. 增强

4. 目标对象

5. 引介

6. 织入

7. 代理

8. 切面

具体，见《精通Spring 4.x 企业应用实战开发》7.1.2

#### 3.1.3 基础知识

​		Spring AOP使用动态代理技术在运行期织入增强的代码，为了揭示Spring AOP底层的工作机理，有必要学习涉及的Java知识。Spring AOP使用了两种代理机制：一种是基于JDK的动态代理；另一种是基于CGLib的动态代理。之所以需要两种代理机制，很大程度上是因为JDK本身只提供接口的代理，而不支持类的代理。

##### 3.1.3.1 Jdk动态代理

​		自Java1.3以后，Java提供了动态代理技术，允许开发者在运行期创建接口的代理实例。在Sun刚推出动态代理时，还很难想象它有多大的实际用途，现在终于发现动态代理是实现AOP的绝好底层技术。**JDK的动态代理主要涉及java.lang.reflect包中的两个类: Proxy和InvocationHandler。其中，InvocationHandler 是一个接口，可以通过实现该接口定义横切逻辑，并通过反射机制调用目标类的代码，动态地将横切逻辑和业务逻辑编织在一起。而Proxy利用InvocationHandler动态创建一一个符合某一接口的实例， 生成目标类的代理对象**。

具体，见《精通Spring 4.x 企业应用实战开发》7.2

##### 3.1.3.2 Cglib动态代理

​		使用JDK创建代理有一个限制，即它只能为接口创建代理实例,这一点可以从Proxy的接口方法newProxyInstance(ClassLoader loader, Class[] interfaces, InvocationHandler h)中看得很清楚，第二个入参interfaces就是需要代理实例实现的接口列表。

​		对于没有通过接口定义业务方法的类，如何动态创建代理实例呢? JDK动态代理技术显然已经黔驴技穷，CGLib 作为一个替代者，填补了这项空缺。**CGLib采用底层的字节码技术**，**可以为一个类创建子类，在子类中采用方法拦截的技术拦截所有父类方法的调用并顺势织入横切逻辑**。

​		具体，见《精通Spring 4.x 企业应用实战开发》7.2	

##### 3.1.3.3 小结

​		JDK动态代理所创建的代理对象，在Java1.3下，性能差强人意。虽然在高版本的JDK中动态代理对象的性能得到了很大的提高，但有研究表明，CGLib 所创建的动态代理对象的性能依旧比JDK所创建的动态代理对象的性能高不少(大概10倍)。但CGLib在创建代理对象时所花费的时间却比JDK动态代理多(大概8倍)。对于singleton的代理对象或者具有实例池的代理，因为无须频繁地创建代理对象，所以比较适合采用CGLib动态代理技术；反之则适合采用JDK动态代理技术。

​		具体，见《精通Spring 4.x 企业应用实战开发》7.2（**7.2基础知识挺重要的，多看几遍**）

### 3.2 增强

具体，见《精通Spring 4.x 企业应用实战开发》7.3

### 3.3 切点

具体，见《精通Spring 4.x 企业应用实战开发》7.4

### 3.4 切面

具体，见《精通Spring 4.x 企业应用实战开发》7.4

### 3.5 自动创建代理

具体，见《精通Spring 4.x 企业应用实战开发》7.5

### 3.6 源码剖析

## 参考资料

《精通Spring 4.x 企业应用开发实战》 — 陈雄花 林开雄 文建国 编著