# iosDemo
a set of iOS demo

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
