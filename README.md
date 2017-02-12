# iosDemo
a set of iOS demo, all third-party libraries are managed by CocoaPods.

1、Mantle  
功能：
	MTLModel作为基类，提供对象的encode和decode操作，通过RunTime特性来获取对象属性的相关信息；
	MTLJSONAdapter作为适配器，主要负责Model和Json数据的互相转换；
	ValueTransform负责对象属性的类型转换；
	libextobjc主要负责把属性的相关信息映射成结构体，再转化成Model；  

优缺点：
	Mantle的功能相比于国内的MJExtensions、YYModel等Json数据解析类库比较丰富；
	Mantle对Json数据的容错性支持相对比较好；
	使用Mantle的过程中需要将MTLModel作为基类，解耦性做得稍差；
	和MJExtensions、YYModel相比，Mantle的解析性能最差，YYModel的性能最好；

2、精简ViewController中的代码  
	a、精简VC中的代码，分离出交互逻辑和业务逻辑，方便后期项目的扩展和维护；  
	b、主要分离UITableView的代理和数据源方法；  
	c、涉及到UITableView的页码管理代码；  
	d、VC中的代码更简洁；  

3、自定义iOS SDK中UITableView (NBTableView)  
	a、主要结合业务场景，优化原有的UITableView，初步计划，带分页&刷新功能、delegate、datasource做分离、在后台线程中绘制简单的cell；  
	b、功能初步定下来，写好后开源；  
	c、很明显，这个重量级的控件不是像我想象的那么容易！！！  
	d、需要制定一个计划，来做长期的准备：  
		1、利用RunTime技术调试系统提供的UITableView，弄明白UITableView的执行过程；  
		2、NBTableView现有的代码中，包括查询缓存、删除、增加等算法或者数据结构应该有优化的空间；  
		3、暂时就这样吧，bitch！！！！  
	2016/12/5  
		完成NBTableView的基本功能，已经可以在简单的业务场景使用；  
		有待完善更高级的功能；  
		有待性能优化；  
4、Masonry  
	a、这个项目主要在于体验纯手工编写页面布局，包括纯手工计算布局、使用iOS提供的VFL约束页面布局、使用Masonry第三方类库来约束页面布局。  
	b、相对于手动计算页面布局来说，特别是针对横屏、竖屏、iPad等场景，Masonry和VFL更有优势，可以实现少量代码实现布局。  
	c、但是VFL使用时不好调试，不过Apple对VFL的封装很到位，通过metrics和options的使用，基本上可以避免在代码中硬编码的情况，这一点Masonry做的较差。  
	d、而Masonry则通过类似自然语言的链式语法，非常易用，但是Masonry封装的接口依然没有避免硬编码的情况，特殊情况下可能需要大量宏定义。  
	d、另外，针对Masonry添加的约束添加动画效果有点问题。

5、关于UIWebView调整字体大小、页面高度自适应、加载网页速度优化  
	a、主要通过对本地html代码进行注入（注入主要通过stringByEvaluatingJavaScriptFromString实现）；
	b、结合WebViewJavascriptBridge这个类库进行本地代码和HTML代码交互，实现图片大小自适应、字体缩放、页面高度适配；
	c、特别注意一点：对网页中已有的Js功能的拦截，需要使用下面的方法  
	      	JsContext context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    		context[@"js func name"] = ^() {}
	d、加载速度优化参考[STMURLCache](https://github.com/ming1016/STMURLCache)这个第三方类库的优化思路；  
	e、在调试的过程中发现UIWebView对于内存的占用爆炸式增长，而且在iOS8.0之后官方推出WKWebView代替UIWebView，优化了内存爆炸的问题;  
	*_注：关于WKWebView的使用可以参考[这篇文章](http://ios.jobbole.com/90729/)；*  
	2017/1/5  
	a、想把这个模块写成一个开源的类库，目前，加载本地的html资源没有太大问题了，但是加载服务端html资源还是有问题，用浏览器自带的控制台又有盲点，用第三方的调试工具遇到了问题。 
	b、打算先把这个第三方工具的问题解决了，再往下走！祝自己顺利！

6、关于animation  
	关于animation有很多可以说，关键是研究动画的本质，也就是动画背后的数学；
	这部分可以参考[时间胶囊](http://kittenyang.com/)！！！
	基础点：
		小交互动画，这部分主要基于iOS SDK提供的基础动画就能实现不错的效果；
		转场动画，需要结合基础动画、转场协议来实现，关键是要针对业务场景实现转场动画的封装、抽离；
	
7、性能监控  
    目前主要针对界面卡顿做监控，crash报告由第三方负责，包括友盟、听云等。
