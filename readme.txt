『错误记录』

1. 错误信息：org.junit.runners.model.InvalidTestClassError: Invalid test class 'testone.auto.TestStudentTest':
            1. No runnable methods

   解决：
   测试MyBatis 逆向工程生成的Mapper配置文件时使用Spring-Test提供的单元测试模块，此时引入的JUnit
   版本需要是4.12 及以上

2. 错误信息：无法读取 applicationContext.xml 配置文件，Line 55 有问题
            <tx:advice>
            <aop:config>

   解决：
   使用这两个标签的时候需要添加正确的约束文件，最好复制之前的『但仅限于使用XML配置文件方式实现
   事务机制的时候』
   如下：
   <beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/tx
       http://www.springframework.org/schema/tx/spring-tx.xsd
       http://www.springframework.org/schema/context
       https://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/aop
       https://www.springframework.org/schema/aop/spring-aop.xsd">

3. 错误信息：无法读取加载 Resources 资源文件夹下的配置文件。
   解决：
   在 pom.xml 文件中的<resource>标签中添加  Resources 资源文件夹下的.xml .properties
   文件，这样在编译的时候就会将此类文件也打包到项目的target 的classes 的文件夹下，
   进而在程序运行读取配置文件『因为用的是classpath』的时候才会读取的到

4. 错误信息：Failed to load ApplicationContext
            Error creating bean with name 'employeeServiceImpl':
            Unsatisfied dependency expressed through field 'mapper';
            nested exception is org.springframework.beans.factory.BeanCreationException:
            Error creating bean with name 'employeeMapper' defined in file
            [D:\Project\SSM\SSM_CRUD\target\classes\com\foubaby\dao\EmployeeMapper.class]:
            Cannot resolve reference to bean 'sqlSessionFactory'
            while setting bean property 'sqlSessionFactory';
            nested exception is org.springframework.beans.factory.NoSuchBeanDefinitionException:
            No bean named 'sqlSessionFactory' available
   错误信息：Error creating bean with name 'employeeController':
            Unsatisfied dependency expressed through field 'employeeService';
            nested exception is org.springframework.beans.factory.NoSuchBeanDefinitionException:
            No qualifying bean of type 'com.foubaby.service.EmployeeService' available:
            expected at least 1 bean which qualifies as autowire candidate.
            Dependency annotations: {@org.springframework.beans.factory.annotation.Autowired(required=true)}
   在进行 Spring-Test 单元测试模块测试请求的时候读取加载 SpringMVC 容器失败

   解决：
   在 dispatcherServlet.xml、 applicationContext.xml 配置文件中声明组件扫描器的时候，使用
   <!-- 1. 配置组件扫描器   -->
       <context:component-scan base-package="com.foubaby" use-default-filters="false">
           <!--  禁掉默认扫描包下的全部组件，而只扫描Controller注解  -->
           <context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
       </context:component-scan>

   <!--  0. 组件扫描器，识别 @Service、@的标签、  -->
       <!--<context:component-scan base-package="com.foubaby" use-default-filters="false">
           <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
       </context:component-scan>

   这种方式没有真正实现扫描 @Controller @Service 注解，导致在读取配置文件创建SpringMVC、Spring容器
   对象的时候无法对 Service 对象创建，导致后面创建 Controller 对象的时候引用类型自动注入失败，出现
   Error creating bean错误， 并最终导致无法创建容器对象 ==> Failed to load ApplicationContext

   还是用我们之前那种默认的对一个包下全部的注解都扫描吧
       <context:component-scan base-package="com.foubaby.controller"/>
       <context:component-scan base-package="com.foubaby.service"/>


5. 关于前端页面中的路径写法
   不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
   解决：
   (1) 以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)；需要加上项目名
       <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
       %>
       写路径信息的时候：src="${APP_PATH }/static/js/jquery-1.12.4.min.js"
       ${APP_PATH } 表示 /crud 当前工程名

   (2) 可以设置 base 标签，这样每个页面就知道在不以/开始的相对路径的时候参考的根路径是哪儿
       『不太好使 还是第一种吧』
       <%
           String basePath = request.getScheme() + "://" +
                               request.getServerName() + ":" +
                               request.getServerPort() + request.getContextPath() + "/";
           效果就是：http://localhost:3306/crud/
       %>
       <head>
           <base href="<%=basePath%>">
       </head>

       可以将这些语句和每个页面都需要添加的一个头标签整合在一起放到static文件夹下的header.jsp文件中
       然后让每个页面都通过<jsp:include page="../../static/html/header.jsp"/>来引入即可『要注意
       根据当前页面的位置来找 header.jsp 的位置』
       可以整合的有：关于 jquery、bootstrap的文件位置等等

       <script type="text/javascript" src="static/js/jquery-3.4.1.js"></script>
       <link rel="stylesheet" href="static/bootstrap-3.3.7-dist/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous">
       <script src="static/bootstrap-3.3.7-dist/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>

       这样其他页面在编写的时候，首先
       <head>
           <jsp:include page="../../static/html/header.jsp"/>
       </head>
       引入此jsp页面，然后就可以自由使用不以/开始的相对路径，且相对的参考路径限定为：
       http://localhost:3306/crud/

6. 为了适用于各种客户端，不应该让数据以request域对象存储的方式传送给客户端，因为客户端还可能是手机、平板
   它们没有像浏览器一样的html 页面解析能力 ===> 应该采用 Json 这种数据交换格式将返回的数据保存起来传送给
   客户端， 并采用 Ajax 请求的方式， 这样不用每切换一次页面就发送一次完整的请求，使得可以异步发起请求，
   局部更新页面。
