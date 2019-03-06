

## Maven本质
Maven本质上是一个插件框架，它的核心并不执行任何具体的构建任务，所有这些任务都交给插件来完成，例如编译源代码是由maven- compiler-plugin完成的
进一步说，每个任务对应了一个插件目标（goal），每个插件会有一个或者多个目标，
例如maven- compiler-plugin的compile目标用来编译位于src/main/java/目录下的主源码，testCompile目标用来编译位于src/test/java/目录下的测试源码

### 2种方式调用Maven插件目标
用户可以通过两种方式调用Maven插件目标。
第一种方式是将插件目标与生命周期阶段（lifecycle phase）绑定，这样用户在命令行只是输入生命周期阶段而已，
>例如Maven默认将maven-compiler-plugin的compile目标与compile生命周期阶段绑定，因此命令mvn compile实际上是先定位到compile这一生命周期阶段，然后再根据绑定关系调用maven-compiler-plugin的compile目标。

第二种方式是直接在命令行指定要执行的插件目标，
>例如`mvn archetype:generate` 就表示调用maven-archetype-plugin的generate目标，这种带冒号的调用方式与生命周期无关。

### 重点
而Maven所做的工作，『就是把网络上一个地址映射到你本地一个地址』然后使用一个『坐标』的概念拼接出来这个路径。其实质就是`一个本地文件夹和云盘的同步`

### maven的依赖管理
依赖管理一般是最吸引人使用maven的功能特性了，这个特性让开发者只需要关注代码的直接依赖，比如我们用了spring，就加入spring依赖说明就可以了，至于spring自己还依赖哪些外部的东西，maven帮我们搞定。

任意一个外部依赖说明包含如下几个要素：groupId, artifactId, version, scope, type, optional。其中前3个是必须的，各自含义如下：

groupId 必须
artifactId 必须
version 必须。 
这里的version可以用区间表达式来表示，比如(2.0,)表示>2.0，[2.0,3.0)表示2.0<=ver<3.0；多个条件之间用逗号分隔，比如[1,3),[5,7]。
scope 作用域限制
type 一般在pom引用依赖时候出现，其他时候不用
optional 是否可选依赖

#### 依赖关系有作用域(scope)的限制
maven认为，程序对外部的依赖会随着程序的所处阶段和应用场景而变化，所以maven中的依赖关系有作用域(scope)的限制。在maven中，scope包含如下的取值：

compile（编译范围） 
compile是默认的范围；如果没有提供一个范围，那该依赖的范围就是编译范围。编译范围依赖在所有的classpath中可用，同时它们也会被打包。
provided（已提供范围） 
provided依赖只有在当JDK或者一个容器已提供该依赖之后才使用。例如，如果你开发了一个web应用，你可能在编译classpath中需要可用的Servlet API来编译一个servlet，但是你不会想要在打包好的WAR中包含这个Servlet API；这个Servlet API JAR由你的应用服务器或者servlet容器提供。已提供范围的依赖在编译classpath（不是运行时）可用。它们不是传递性的，也不会被打包。
runtime（运行时范围） 
runtime依赖在运行和测试系统的时候需要，但在编译的时候不需要。比如，你可能在编译的时候只需要JDBC API JAR，而只有在运行的时候才需要JDBC驱动实现。
test（测试范围） 
test范围依赖 在一般的 编译和运行时都不需要，它们只有在测试编译和测试运行阶段可用。测试范围依赖在之前的???中介绍过。
system（系统范围） 
system范围依赖与provided类似，但是你必须显式的提供一个对于本地系统中JAR文件的路径。这么做是为了允许基于本地对象编译，而这些对象是系统类库的一部分。这样的构件应该是一直可用的，Maven也不会在仓库中去寻找它。 `如果你将一个依赖范围设置成系统范围，你必须同时提供一个systemPath元素` 。注意该范围是不推荐使用的（你应该一直尽量去从公共或定制的Maven仓库中引用依赖）。


## Maven的pom.xml文件

### Maven的中央仓库
地址: http://central.maven.org/maven2/

这个就是Maven在网络上的中央仓库，说白了就是个文件夹，里面存了所有在Maven上发布的Jar包


### 配置文件的解析
Maven的配置文件是个xml文件，其具体有什么标签，代表什么意思，可以去Maven的官方网站文档查询，这里做简单的解释。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="
         http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/maven-v4_0_0.xsd
         ">
    <modelVersion>4.0.0</modelVersion>
    <groupId>坐标组</groupId>
    <artifactId>坐标名</artifactId>
    <version>坐标版本号</version>
    <packaging>Target格式</packaging>
    <dependencies>需要加载哪些Jar包</dependencies>
    <build>编译和生成Target目录</build>
</project>
```
project节点： 该节点代表一个工程或者是一个模块，是pom文件的最外层节点，其下有9个基本节点
坐标节点：指的是「groupId」「artifactId」「version」这三个节点，定义了目录信息
packaging节点：项目编译后打包成Target时生成的格式
dependencies节点： 重点的重点！规定了Project要加载哪些Jar包
build节点：编译打包生成相关配置



## Maven项目的应用

### Maven项目目录结构(jar类型)
- src/main/java真实目录的快捷目录,写java代码
- src/main/resources 快捷目录
	+ 存放配置文件.
	+ 虽然看见resources但是里面所有配置文件最终会被编译放入到classes类路径.
- src/test/java 写测试java代码
- src/text/resources 测试的配置文件夹
- pom.xml maven的配置文件
	+ 当前项目所依赖的其他项目或jar或插件等

 pom.xml maven的配置文件

### Maven项目之间的关系

- 依赖关系
	+ 标签<dependency>把另一个项目的jar引入到当过前项目
	+ 自动下载另一个项目所依赖的其他项目

- 继承关系
- 聚合关系

#### maven子项目如何使用父项目的jar包
```xml
如果父pom中使用的是

<dependencies>....</dependencies>
方式，
则子pom会自动使用pom中的jar包


如果父pom使用

<dependencyManagement>
  <dependencies>....
  </dependencies>
</dependencyManagement>

方式，则子pom不会自动使用父pom中的jar包，这时如果子pom想使用的话，就要给出groupId和artifactId，无需给出version
```

### maven用法
3.3 web工程
创建一个简单的web项目，只需要修 -DarchetypeArtifactId为maven-archetype-webapp即可，如下命令

```sehll
mvn archetype:generate -DgroupId=com.bernard -DartifactId=MemoSSH -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false
```

#### maven打包命令
打包时跳过测试
```sehll
mvn package -DskipTests
```

#### maven安装jar包到本地仓库
`mvn install:install-file -DgroupId=com.hanvon -DartifactId=FaceId -Dversion=1.0 -Dpackaging=jar -Dfile=FaceId-1.0.jar`
-Dversion 为了符合Maven的规定，需要给FaceId.jar一个版本号，故将FaceId.jar改名为FaceId-1.0.jar
-Dfile选项应给出需要安装jar文件的路径



### Maven仓库的分类

#### Maven本地仓库
这里要引入一个新的元素：`localRepository`，它是存在于maven的settings.xml文件中

`1更改配置用户范围的本地仓库`：
先在/.m2/目录下创建settings.xml文件，然后在~/.m2/settings.xml，设置localRepository元素的值为想要的仓库地址
```xml
<settings> <localRepository>D:\maven_new_repository</localRepository> </settings>
```
这时候，maven的本地仓库地址就变成了 D:\maven_new_repository ，注：此时配置的maven的本地仓库是属于用户范围的。

`2 更改配置全局范围的本地仓库`：
在M2_HOME/conf/settings.xml中更改配置，更改配置的方法同上
注：此时更改后，所有的用户都会受到影响，而且如果maven进行升级，那么所有的配置都会被清除，所以要提前复制和备份M2_HOME/conf/settings.xml文件
故：一般情况下不推荐配置全局的settings.xml

#### 中央仓库
说到远程仓库先从 最核心的中央仓库开始，中央仓库是默认的远程仓库，maven在安装的时候，自带的就是中央仓库的配置
在maven的聚合与继承中我们说过，所有的maven项目都会继承超级pom，具体的说，包含了下面配置的pom我们就称之为超级pom
```xml
<repositories> 
    <repository> 
        <id>central</id> 
        <name>Central Repository</name> 
        <url>http://repo.maven.apache.org/maven2</url> 
        <layout>default</layout> 
        <snapshots> 
        <enabled>false</enabled> 
        </snapshots> 
    </repository> 
</repositories> 
```
中央仓库包含了绝大多数流行的开源Java构件，以及源码、作者信息、SCM、信息、许可证信息等。一般来说，简单的Java项目依赖的构件都可以在这里下载到


###　Maven私服nexus

#### Maven私服[Nexus]理论原理
`私服是一种特殊的远程仓库，它是架设在局域网内的仓库服务，私服代理广域网上的远程仓库，供局域网内的Maven用户使用。
Nexus的仓库类型`

hosted（宿主）：宿主仓库主要用于存放项目部署的构件、或者第三方构件用于提供下载。
`用户往里面填东西`
用户可以把自己的一些构件，deploy到hosted中，也可以手工上传构件到hosted里。比如说oracle的驱动程序，ojdbc6.jar，在central repository是获取不到的，就需要手工上传到hosted里

proxy（代理）：代理仓库就是对远程仓库的一种代理，从远程仓库下载构件和插件然后缓存在Nexus仓库中
`用户从里面拿出东西`
比如说在nexus中配置了一个central repository的proxy，当用户向这个proxy请求一个artifact，这个proxy就会先在本地查找，如果找不到的话，就会从远程仓库下载，然后返回给用户，相当于起到一个中转的作用

group（仓库组）：仓库的一种组合策略，并不存在实在意义的依赖，只是作为一种中转站的作用存在。
`nexus特有概念`
在maven里没有这个概念，是nexus特有的。目的是将上述多个仓库聚合，对用户暴露统一的地址，这样用户就不需要在pom中配置多个地址，只要统一配置group的地址就可以了右边那个Repository Path可以点击进去，看到仓库中artifact列表。不过要注意浏览器缓存。我今天就发现，明明构件已经更新了，在浏览器里却看不到，还以为是BUG，其实是被浏览器缓存了

#### Maven私服的 特性
1.节省自己的外网带宽：减少重复请求造成的外网带宽消耗
2.加速Maven构件：如果项目配置了很多外部远程仓库的时候，构建速度就会大大降低
3.部署第三方构件：有些构件无法从外部仓库获得的时候，我们可以把这些构件部署到内部仓库(私服)中，供内部maven项目使用

#### Maven私服使用办法

前提:已经配置JDK环境变量

1. 把压缩包解压到任意非中文目录中

2. 根据自己的系统选择对应的版本
D:\nexus\soft\nexus-2.12.0-01\bin\jsw

3. 运行install-nexus.bat 在系统中注册服务

4. 注册后可以通过start-nexus.bat/stop-nexus.bat 开启服务和关闭服务
也可以在系统服务中开启关闭服务

	4.1 uninstall-nexus.bat 表示卸载服务

5. 在浏览器输入   http://localhost:8081/nexus 进入主界面

6. 在主界面右上角log in 进行登录,默认用户名和密码是 
	用户名:admin
	密码:admin123

修改nexus端口
`nexus.properties文件中# Jetty section application-port=8091`

#### 只对单独一个项目有效

我们要想使用这个私服仓库，先在项目pom中配置相关私服信息指定仓库，如下片段需要配置到maven项目的 pom.xml 中。

```xml
<project>
    ...
    <!-- 配置仓库 -->
    <repositories>  
        <repository>  
            <id>nexus</id>  
            <name>nexus</name>
            <url>http://127.0.0.1:8081/repository/maven-public/</url>  
            <releases>  
                <enabled>true</enabled>  
            </releases>  
            <snapshots>  
                <enabled>true</enabled>  
            </snapshots>  
        </repository>  
    </repositories> 

    <!-- 配置插件仓库 -->
    <pluginRepositories>  
        <pluginRepository>  
            <id>nexus</id>  
            <name>nexus</name>  
            <url>http://127.0.0.1:8081/repository/maven-public/</url>  
            <releases>  
                <enabled>true</enabled>  
            </releases>  
            <snapshots>  
                <enabled>true</enabled>  
            </snapshots>  
        </pluginRepository>  
    </pluginRepositories>
    ... 
</project>

```


#### 本地所有Maven使用私服

安装和配置好之后，在开发中如何使用呢。可在maven的默认配置settings.xml中修改如下：

settins.xml并不支持直接配置repositories和pluginRepositories。但是Maven提供了Profile机制，能让用户将仓库配置防止到setting.xml中的Profile中。修改 settings.xml 中的profiles内容为：

```xml
<servers>
    <server>
        <id>releases</id>
        <username>admin</username>
        <password>admin123</password>
    </server>
    <server>
        <id>snapshots</id>
        <username>admin</username>
        <password>admin123</password>
    </server>
</servers>

<mirrors>
    <mirror>
        <id>nexus</id>
        <mirrorOf>*</mirrorOf>
        <url>http://127.0.0.1:8081/repository/maven-public/</url>
    </mirror>
</mirrors>

 </profiles>
    <profile>
      <id>Nexus</id>
	<!--配置仓库 -->
      <repositories>
        <repository>
          <id>nexus</id>
          <url>http://127.0.0.1:8081/repository/maven-public/</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>true</enabled>
          </snapshots> 
        </repository>
      </repositories>

	<!--配置插件仓库 -->
      <pluginRepositories>
        <pluginRepository>
          <id>nexus</id>
          <url>http://127.0.0.1:8081/repository/maven-public/</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>true</enabled>
          </snapshots> 
        </pluginRepository>
      </pluginRepositories>
    </profile>

    <profile>
      <id>jdk-1.8</id>
      <activation>
        <activeByDefault>true</activeByDefault>
        <jdk>1.8</jdk>
      </activation>
      <properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
      </properties>
    </profile>
    
  </profiles>
 
 	 <!--激活id为Nexus的profile-->
  <activeProfiles>      
	<activeProfile>Nexus</activeProfile>
  </activeProfiles>

```


### Maven3中ojdbc驱动问题
由于Oracle授权问题，Maven3不提供Oracle JDBC driver，为了在Maven项目中应用Oracle JDBC driver,必须手动添加到本地仓库。

此文档用的是Oracle 11g.


### 项目中的POMxml文件

#### 资源拷贝插件
```xml
<!-- 资源拷贝插件配置 -->
<resources>
    <resource>
        <directory>src/main/java</directory>
        <includes>
            <include>**/*.xml</include>
        </includes>
    </resource>
    <resource>
        <directory>src/main/resources</directory>
        <includes>
            <include>**/*.xml</include>
            <include>**/*.properties</include>
        </includes>
    </resource>
</resources>
```


#### war包构建时pom中build元素中配置拷贝webapp目录下内容
```xml
  <build>
      <finalName>manage</finalName>

      <plugins>
          <plugin>
              <groupId>org.apache.maven.plugins</groupId>
              <artifactId>maven-compiler-plugin</artifactId>
              <version>2.3.2</version>
              <configuration>
                  <source>1.7</source>
                  <target>1.7</target>
              </configuration>
          </plugin>
          <plugin>
              <groupId>org.apache.maven.plugins</groupId>
              <artifactId>maven-war-plugin</artifactId>
              <version>3.1.0</version>
              <configuration>
                  <webResources>
                      <resource>
                          <directory>src/main/webapp</directory>
                          <!--<targetPath>WEB-INF/lib</targetPath>-->
                          <includes>
                              <include>**/*.jar</include>
                          </includes>
                      </resource>
                  </webResources>
              </configuration>
          </plugin>
          <plugin>
              <groupId>org.apache.maven.plugins</groupId>
              <artifactId>maven-eclipse-plugin</artifactId>
              <inherited>true</inherited>
          </plugin>
      </plugins>
  </build>

```




