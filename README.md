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
	
	精简VC中的代码，分离出交互逻辑和业务逻辑，方便后期项目的扩展和维护；
	主要分离UITableView的代理和数据源方法；
	涉及到UITableView的页码管理代码；
	VC中的代码更简洁；

3、自定义iOS SDK中UITableView (NBTableView)
	
	功能：
	主要结合业务场景，优化原有的UITableView，初步计划，带分页&刷新功能、delegate、datasource做分离、在后台线程中绘制简单的cell；
	功能初步定下来，写好后开源；
	很明显，这个重量级的控件不是像我想象的那么容易！！！
	需要制定一个计划，来做长期的准备：
		1、利用RunTime技术调试系统提供的UITableView，弄明白UITableView的执行过程；
		2、NBTableView现有的代码中，包括查询缓存、删除、增加等算法或者数据结构应该有优化的空间；
		3、暂时就这样吧，bitch！！！！

4、Masonry
	
	这个项目主要在于体验纯手工编写页面布局，包括纯手工计算布局、使用iOS提供的VFL约束页面布局、使用Masonry第三方类库来约束页面布局。
	相对于手动计算页面布局来说，特别是针对横屏、竖屏、iPad等场景，Masonry和VFL更有优势，可以实现少量代码实现布局。
	但是VFL使用时不好调试，不过Apple对VFL的封装很到位，通过metrics和options的使用，基本上可以避免在代码中硬编码的情况，这一点Masonry做的较差。
	而Masonry则通过类似自然语言的链式语法，非常易用，但是Masonry封装的接口依然没有避免硬编码的情况，特殊情况下可能需要大量宏定义。
	另外，针对Masonry添加的约束添加动画效果有点问题。

5、关于UIWebView调整字体大小、页面高度自适应、加载网页速度优化

	主要通过对本地html代码进行注入（注入主要通过stringByEvaluatingJavaScriptFromString实现），结合WebViewJavascriptBridge这个类库进行本地代码和HTML代码交互，实现图片大小自适应、字体缩放、页面高度适配；
	加载速度优化参考[STMURLCache](https://github.com/ming1016/STMURLCache)这个第三方类库的优化思路；

6、关于animation

	关于animation有很多可以说，关键是研究动画的本质，也就是动画背后的数学；
	这部分可以参考[时间胶囊](http://kittenyang.com/)！！！
	基础点：
		小交互动画，这部分主要基于iOS SDK提供的基础动画就能实现不错的效果；
		转场动画，需要结合基础动画、转场协议来实现，关键是要针对业务场景实现转场动画的封装、抽离；
	
