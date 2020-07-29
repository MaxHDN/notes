# SpringMVC 高级框架

### 第一部分 SpringMVC 简介

### 1.1 MVC 思想

#### 1.1.1 思想

​		MVC即Model-View-Controller（模型-视图-控制器）。它是一种软件的设计思想，将应用的一个输入、处理、输出按照模型层，视图层，控制层进行分层设计。最早出现在Smalltalk语言中，后被Sun公司推荐为Java EE平台的设计模式。

* Model(模型)：即数据以及程序逻辑，独立于视图和控制器

* 视图：**呈现模型，类似于Web程序中的界面**（jsp、html），视图会从模型中拿到需要展现的数据，对于相同的数据可以有多种不同的显示形式(视图)。

* 控制器：视图发请求给控制器，由控制器来选择相应的模型来处理，模型层返回的结果给控制器，由控制器选择合适的视图。

#### 1.1.2 为什么要用MVC模型？

​		可以将程序的M(Model) 和 V(View)代码分离，前后端代码的分离，有以下好处

* 可以使同一个程序使用不同的表现形式，如果控制器反馈给模型的数据发生了变化，那么模型将及时通知有关的视图，视图会对应的刷新自己所展现的内容

* 因为模型是独立于视图的，所以模型可复用，模型可以独立的移植到别的地方继续使用

* 前后端的代码分离，使项目开发的分工更加明确，程序的测试更加简便，提高开发效率

### 1.2 SpringMVC 简介

​		Spring MVC框架围绕**DispatcherServlet** 这个核心展开，DispatcherServlet 是SpringMVC的总导演、总策划，它负责截获请求并将其分派给相应的处理器处理。SpringMVC框架包括注解驱动控制器、请求及响应的信息处理、视图解析、本地化解析、上传文件解析、异常处理及表单标签绑定等内容。

​		Spring MVC 是基于**Model 2**实现的技术框架，Model 2是经典的MVC (Model、View、Control) 模型在Web应用中的变体，这个改变主要源于HTTP协议的无状态性。**Model 2的目的和MVC一样，也是利用处理器分离模型、视图和控制，达到不同技术层级间松散层耦合的效果，提高系统灵活性、复用性和可维护性**。在大多数情况下，可以将Model2与MVC等同起来。

​		在利用Model2之前，把所有的展现逻辑和业务逻辑集中在一起， 有时也称这种应用模式为Model 1。Model 1的主要缺点就是紧耦合，复用性差，维护成本高。由于Spring MVC是基于Model 2实现的框架，所以它底层的机制也是MVC。

### 1.2.1 三层架构

​		我们的开发架构一般都是基于两种形式，一种是C/S架构，也就是客户端/服务器;另-种是B/S架构也就是浏览器服务器。在JavaEE开发中，几乎全都是基于B/S架构的开发。那么在B/S架构中，系统标准的三层架构包括:表现层、业务层、持久层。三层架构在我们的实际开发中使用的非常多，所以我们课程中的案例也都是基于三层架构设计的。
​		三层架构中，每一层各司其职，接下来我们就说说每层都负责哪些方面:

* 表现层:
  也就是我们常说的web层。它负责接收客户端请求，向客户端响应结果，通常客户端使用http协
  议请求web层，web需要接收http请求，完成http响应。

  表现层包括展示层和控制层:控制层负责接收请求，展示层负责结果的展示。

  表现层依赖业务层，接收到客户端请求-般会调用业务层进行业务处理，并将处理结果响应给客户端。

  表现层的设计一般都使用MVC模型。(MVC 是表现层的设计模型，和其他层没有关系)



* 业务层:
  也就是我们常说的service层。它负责业务逻辑处理，和我们开发项目的需求息息相关。web层依赖业务层，但是业务层不依赖web层。

  业务层在业务处理时可能会依赖持久层，如果要对数据持久化需要保证事务-致性。(也就是我们说的，事务应该放到业务层来控制)

* 持久层

  也就是我们是常说的dao层。负责数据持久化，包括数据层即数据库和数据访问层，数据库是对数据进
  行持久化的载体，数据访问层是业务层和持久层交互的接口，业务层需要通过数据访问层将数据持久化
  到数据库中。通俗的讲，持久层就是和数据库交互，对数据库表进行增删改查的。

### 1.3 SpringMVC 和 Servlet 区别

Spring MVC 本质可以认为是对servlet的封装，简化了我们serlvet的开发
作⽤： 1）接收请求 2）返回响应，跳转⻚⾯  

![image-20200716213045324](..\..\img-folder\image-20200716213045324.png)

## 第二部分 Spring开发流程

开发过程

* 配置DispatcherServlet前端控制器

  ~~~xml
  <!DOCTYPE web-app PUBLIC
   "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
   "http://java.sun.com/dtd/web-app_2_3.dtd" >
  
  <web-app>
    <display-name>Archetype Created Web Application</display-name>
    <servlet>
    <servlet-name>springmvc</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:spring-mvc.xml</param-value>
    </init-param>
  </servlet>
    <servlet-mapping>
      <servlet-name>springmvc</servlet-name>
      <url-pattern>/</url-pattern>
    </servlet-mapping>
  </web-app>
  ~~~

  

* 开发处理具体业务逻辑的Handler（@Controller、 @RequestMapping）

  ~~~java
  import java.util.Date;
  
  @Controller
  @RequestMapping("/demo")
  public class DemoController {
  
      @RequestMapping("/handle01")
      public ModelAndView handle01(){
          Date date =  new Date();
  
          ModelAndView modelAndView = new ModelAndView();
          modelAndView.addObject("date",date);
          modelAndView.setViewName("success");
          System.out.println(date.toString());
          return modelAndView;
      }
  }
  ~~~

  

* xml配置⽂件配置controller扫描，配置springmvc三⼤件

  ~~~xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns:context="http://www.springframework.org/schema/context"
         xmlns:mvc="http://www.springframework.org/schema/mvc"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd
                             http://www.springframework.org/schema/context
                             http://www.springframework.org/schema/context/spring-context.xsd
                             http://www.springframework.org/schema/mvc
                             http://www.springframework.org/schema/mvc/spring-mvc.xsd
  
  ">
  
      <!--开启controller扫描-->
      <context:component-scan base-package="com.lagou.edu.controller"/>
  
      <!--视图解析器-->
      <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
          <property name="prefix" value="/WEB-INF/jsp/"/>
          <property name="suffix" value=".jsp"/>
      </bean>
  
      <!--自动注册处理器映射器、处理器适配器-->
      <mvc:annotation-driven/>
  </beans>
  ~~~

  

* 将xml⽂件路径告诉springmvc（DispatcherServlet）  

  ~~~xml
  <!DOCTYPE web-app PUBLIC
   "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
   "http://java.sun.com/dtd/web-app_2_3.dtd" >
  
  <web-app>
    <display-name>Archetype Created Web Application</display-name>
    <servlet>
    <servlet-name>springmvc</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:spring-mvc.xml</param-value>
    </init-param>
  </servlet>
    <servlet-mapping>
      <servlet-name>springmvc</servlet-name>
      <url-pattern>/</url-pattern>
    </servlet-mapping>
  </web-app>
  ~~~

## 第三部分 SpringMVC工作流程

### 3.1 SpringMVC请求处理流程

![image-20200716213930585](..\..\img-folder\image-20200716213930585.png)

流程说明

第一步：用户发送请求至前端控制器DispatcherServlet

第二步： DispatcherServlet收到请求调用HandlerMapping处理器映射器

第三步：处理器映射器根据请求Url找到具体的Handler (后端控制器)，生成处理器对象及处理器拦截
器(如果有则生成)-并返回DispatcherServlet

第四步：DispatcherServlet调用HandlerAdapter处理 器适配器去调用Handler

第五步：处理器适配器执行Handler

第六步：Handler执行完成给处理器适配器返回ModelAndView

第七步：处理器适配器向前端控制器返回ModelAndView, ModelAndView 是SpringMVC框架的一个底层对象，包括Model和View

第八步：前端控制器请求视图解析器去进行视图解析，根据逻辑视图名来解析真正的视图。

第九步：视图解析器向前端控制器返回View

第十步：前端控制器进行视图渲染，就是将模型数据(在ModelAndView对象中)填充到request域

第十一步：前端控制器向用户响应结果

### 3.2 SpringMVC九大组件

* HandlerMapping (处理器映射器)
  HandlerMapping是用来查找Handler的，也就是处理器，具体的表现形式可以是类，也可以是
  方法。比如，标注了@RequestMapping的每个方法都可以看成是-个Handler。 Handler负责具
  体实际的请求处理，在请求到达后，HandlerMapping 的作用便是找到请求相应的处理器
  Handler和Interceptor。

* HandlerAdapter (处理器适配器)

  HandlerAdapter是-一个适配器。因为Spring MVC中Handler可以是任意形式的，只要能处理请
  求即可。但是把请求交给Servlet的时候，由于Servlet的方法结构都是doService(HttpServletRequest req,HttpServletResponse resp)形式的，要让固定的Servlet处理方法调用Handler来进行处理，便是HandlerAdapter的职责。

* HandlerExceptionResolver
  HandlerExceptionResolver用于处理Handler产生的异常情况。它的作用是根据异常设置ModelAndView，之后交给渲染方法进行渲染，渲染方法会将ModelAndView渲染成页面。

* ViewResolver
  ViewResolver即视图解析器，用于将String类 型的视图名和Locale解析为View类型的视图，只有一个resolveViewName()方法。从方法的定义可以看出，Controller层返回的String类型视图名viewName最终会在这里被解析成为View。View是用来渲染页面的，也就是说，它会将程序返回的参数和数据填入模板中，生成htm|文件。ViewResolver 在这个过程主要完成两件事情：ViewResolver找到渲染所用的模板(第-一件大事)和所用的技术(第二件大事，其实也就是找到视图的类型，如JSP) 并填入参数。默认情况下，Spring MVC会自动为我们配置一个InternalResourceViewResolver,是针对JSP类型视图的。

* RequestToViewNameTranslator
  RequestToViewNameTranslator组件的作用是从请求中获取ViewName.因为ViewResolver根据ViewName查找View,但有的Handler处理完成之后,没有设置View,也没有设置ViewName,便要通过这个组件从请求中查找ViewName。

* LocaleResolver
  ViewResolver组件的resolveViewName方法需要两个参数，-个是视图名，-个是Locale。LocaleResolver用于从请求中解析出Locale,比如中国Locale是zh-CN,用来表示一个区域。这个组件也是i18n的基础。

* ThemeResolver
  ThemeResolver组件是用来解析主题的。主题是样式、图片及它们所形成的显示效果的集合。Spring MVC中-套主题对应一个properties文件,里面存放着与当前主题相关的所有资源，如图片、CSS样式等。创建主题非常简单,只需准备好资源，然后新建一个"主 题名.properties"并将资源设置进去，放在classpath下， 之后便可以在页面中使用了。SpringMVC中与 主题相关的类有ThemeResolver.、ThemeSource和Theme。 ThemeResolver负 责从请求中解析出主题名,ThemeSource根据主题名找到具体的主题，其抽象也就是Theme,可以通过Theme来获取主题和具体的资源。

* MultipartResolver
  MultipartResolver用于上传请求，通过将普通的请求包装成MultipartHttpServletRequest来实现。MultipartHttpServletRequest 可以通过getFile()方法直接获得文件。如果上传多个文件，还可以调用getFileMap()方法得到Map<FileName，File> 这样的结构，MultipartResolver 的作用就是封装普通的请求，使其拥有文件.上传的功能。

* FlashMapManager
  FlashMap用于重定向时的参数传递，比如在处理用户订单时候，为了避免重复提交，可以处理完post请求之后重定向到一个get请求，这个get请求可以用来显示订单详情之类的信息。这样做虽然可以规避用户重新提交订单的问题，但是在这个页面上要显示订单的信息，这些数据从哪里来获得呢?因为重定向时么有传递参数这一功能的，如果不想把参数写进URL (不推荐)，那么就可以通过FlashMap来传递。只需要在重定向之前将要传递的数据写入请求(可以通过ServletRequestAttributes.getRequest()方法获得)的属性OUTPUT_ FLASH_ MAP_ ATTRIBUTE中，这样在重定向之后的Handler中Spring就会自动将其设置到Model中，在显示订单信息的页面上就可以直接从Model中获取数据。FlashMapManager 就是用来管理FalshMap的。

### 3.3 Spring url-pattern配置原理及使用说明

### 3.4 业务层、Web层的spring容器

## 第四部分 请求绑定参数

请求参数绑定，说⽩了是SpringMVC如何接收请求参数。http协议（超⽂本传输协议），参数都是字符串。
原⽣servlet接收⼀个整型参数：

~~~java
String ageStr = request.getParameter("age");
Integer age = Integer.parseInt(ageStr);
~~~

SpringMVC框架对Servlet的封装，简化了servlet的很多操作，SpringMVC在接收整型参数的时候，直接在Handler⽅法中声明形参即可

~~~java
@RequestMapping("xxx")
	public String handle(Integer age) {
	System.out.println(age);
}
~~~

所以参数绑定，就是取出参数值绑定到handler⽅法的形参上 。在处理器适配器调用handler是将对应的参数正确的传给handler方法。

### 4.1 默认⽀持 Servlet API 作为⽅法参数

具体见《SpringMVC讲义_Java高薪训练营》第3节

### 4.2 绑定简单类型

具体见《SpringMVC讲义_Java高薪训练营》第3节

### 4.3 绑定POJO及POJO包装类型

具体见《SpringMVC讲义_Java高薪训练营》第3节

### 4.4 绑定日期类型

具体见《SpringMVC讲义_Java高薪训练营》第3节

## 第五部分  Ajax Json交互

交互：两个⽅向

1）前端到后台：前端ajax发送json格式字符串，后台直接接收为pojo参数，使⽤注解@RequstBody

2）后台到前端：后台直接返回pojo对象，前端直接接收为json对象或者字符串，使⽤注解@ResponseBody  

### 5.1 @RequestBody

​		@RequestBody 将 HTTP 请求正文参数绑定到方法中，使用适合的 HttpMessageConverter 将请求体写入某个对象。

​       1)  该注解用于读取Request请求的body部分数据，使用系统默认配置的HttpMessageConverter进行解析，然后把相应的数据绑定到要返回的对象上； 

​       2)  再把HttpMessageConverter返回的对象数据绑定到 controller中方法的参数上。

​		@RequestBody主要用来接收前端传递给后端的json字符串中的数据的(请求体中的数据的)；**GET方式无请求体，所以使用@RequestBody接收数据时，前端不能使用GET方式提交数据，而是用POST方式进行提交**。在后端的同一个接收方法里，@RequestBody与@RequestParam()可以同时使用，@RequestBody最多只能有一个，而@RequestParam()可以有多个。


使用时机：

* GET、POST方式提时， 根据request header Content-Type的值来判断:

   application/x-www-form-urlencoded， 可选（即非必须，因为这种情况的数据@RequestParam, @ModelAttribute，也可以处理，当然@RequestBody也能处理）； 

  multipart/form-data, 不能处理（即使用@RequestBody不能处理这种格式的数据）；

  其他格式， 必须（其他格式包括application/json, application/xml等。这些格式的数据，必须使用@RequestBody来处理）；



### 5.2 @ResponseBody

​		@ResponseBody的作用其实是将java对象转为json格式的数据。

​		@responseBody注解的作用是将controller的方法返回的对象通过适当的转换器转换为指定的格式之后，写入到response对象的body区，通常用来返回JSON数据或者是XML数据。注意：在使用此注解之后不会再走视图处理器，而是直接将数据写入到输入流中，效果等同于通过response对象输出指定格式的数据。

​		@ResponseBody是作用在方法上的，@ResponseBody 表示该方法的返回结果直接写入 HTTP response body 中，一般在异步获取数据时使用【也就是AJAX】。

​		注意：在使用 @RequestMapping后，返回值通常解析为跳转路径，但是加上 @ResponseBody 后返回结果不会被解析为跳转路径，而是直接写入 HTTP response body 中。 比如异步获取 json 数据，加上 @ResponseBody 后，会直接返回 json 数据。

### 5.3 媒体类型Content-type

​		MediaType,即是Internet Media Type,互联网媒体类型；也叫做MIME类型， 在Http协议消息头中，使用Content-Type来表示具体请求中的媒体类型信息。

​		Content-type存放在Http的实体首部字段，在request的请求行（或response的状态码）之后，也是首部的一部分。用于说明请求或返回的消息主体是用何种方式编码，在request header和response header里都存在.

​		当浏览器发起http请求时，有一个关于媒体格式的请求头字段， 浏览器会根据请求链接的内容帮我们自动加上，那就是Acept字段， 它的作用告诉WEB服务器自己接受的MIME类型，属于请求头，而服务器接收到该信息后，使用Content-Type 应答头通知客户端它选择的MIME类型，属于实体头，服务端不返回Content- Type字段时浏览器会按Accept字段里的属性顺序对返回的数据进行解析。Content-Typet也可以用在请求头信息中，用来指定报文主体的类型。

​		注: MIME的全名叫多用途互联网邮件扩展(Multipurpose Internet MailExtensions) MIME的常见形式是一 个主类型加一个子类型， 用斜线分隔。比如text/html、application/javascript、image/png等， MIME和操作系统的文件拓展名有共同的用途，就是用来标注信息的格式，但应用场景完全不同，个是操作系统中标注文件的， 一个是 邮件和HTTP协议中用来标 注网络数据的。

**常见的媒体格式类型如下：**

* text/html ： HTML格式
* text/plain ：纯文本格式    
* text/xml ：  XML格式
* text/x-markdown：markdown格式
* image/gif ：gif图片格式   
* image/jpeg ：jpg图片格式 
* image/png：png图片格式

**以application开头的媒体格式类型**

* application/xhtml+xml ：XHTML格式
* application/xml     ： XML数据格式
* application/atom+xml  ：Atom XML聚合格式
* application/json    ： JSON数据格式
* application/pdf       ：pdf格式
* application/msword  ： Word文档格式
* application/octet-stream ： 二进制流数据（如常见的文件下载）
* application/x-www-form-urlencoded ： 是<form encType="">中默认的encType，**form表单数据被编码为key/value格式发送到服务器**（表单默认的提交数据的格式）

另外一种常见的媒体格式是上传文件时使用：

* multipart/form-data ： 上传文件之时使用的，需要在表单中进行文件上传时，就需要使用该格式。

~~~html
常见的 POST 数据提交的方式。我们使用表单上传文件时，必须让 form 的 enctype 等于这个值。
<form action="/" method="post" enctype="multipart/form-data">
  <input type="text" name="description" value="some text">
  <input type="file" name="myFile">
  <button type="submit">Submit</button>
</form>
~~~

## 第六部分 Restful支持

具体见《SpringMVC讲义_Java高薪训练营》

## 第七部分 过滤器、监听器、拦截器

具体见《SpringMVC讲义_Java高薪训练营》

## 第八部分 异常处理器

具体见《SpringMVC讲义_Java高薪训练营》

## 第九部分 文件上传

具体见《SpringMVC讲义_Java高薪训练营》

## 第十部分 重定向、转发