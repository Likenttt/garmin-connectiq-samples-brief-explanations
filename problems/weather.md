### 做天气

这个问题内容比较多，可以聊的地方不少。

#### 数据获取

按照天气的提供商可以分为佳明天气、三方天气。

##### 佳明天气

佳明天气以官方SDK中API形式给出（佳明没有直接说明他们使用了具体哪个供应商，也许是像Connect里面的地图一样，全球各地不一样），所有的天气情况已经在API文档中罗列清楚了，我们可以直接在代码里面调用方法参照文档使用即可。关于天气的使用说明，可以查看[Weather](https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather.html)。官方天气API是最简单、稳定的，一般有条件的设备推荐默认使用佳明天气，下面说三方天气。

##### 三方天气

常见的国内外天气供应商，大约有OpenWeatherMap、和风天气、彩云天气（搜索引擎可以直接搜索到官网），这种天气服务需要我们自己通过http请求去获取。需要注意的是，这些服务商在提供服务的时候需要使用一个API KEY作为鉴权口令，我想这样做应该是为了防止接口滥用同时也是一种差异化定价策略。通常这些服务商面向个人有免费版本的API KEY可以申请，让用户去相应的网站注册申请即可，操作也比较简单。（简单只是我们的简单，人类的感受不能相通，很多用户可能仍然嫌烦琐，所以推荐能使用佳明天气就默认选佳明天气）。

##### 数据聚合

一个应用里面为了适应多种情况，我们需要支持多种天气供应商，这时候就要聚合天气情况。每一家的天气供应商的返回结果数据结构有差异，但是最终的聚合指向是一致的。天气状况无非那几十种，晴朗，多云等等。

#### 数据呈现

下面主要讨论天气图标问题。

前面说到OpenWeatherMap提供了免费的API接口，真是大善人啊。它还提供了天气的描述等等，当然其他天气供应商也有。特别的一点是，它还提供了图标的名字（文件名）和获取链接。我们可以参考这个页面[Weather Conditions](https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2)。

```
...
    "weather": [
        {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n" //天气图标的名字，可以组合使用放大倍数
        }
    ],
    ...

How to get icon URL
For code 500 - light rain icon = "10d". See below a full list of codes
URL is http://openweathermap.org/img/wn/10d@2x.png
```

手表上其实不太适合使用这种方式，目前据我所知，佳明应用启动时，所有的资源都需要加载到内存里，似乎并不能从网上下载图片显示。而且大部分手表（目前forerunner945lte是自带蜂窝网络的，但是中国大陆还没有发售）的网络服务都是通过蓝牙连接到手机的间接获取的，带宽资源十分有限，大约只是0.1MB/s，这点带宽要想实现稳定获取图片资源，我是认为十分不可靠。

**可靠的方式就是将图标全部下载下来。** 我们可以直接逐个下载这个网站的资源，或者去网上找图标资源。这里我推荐这么一套开源图标 [Weather Icons](https://github.com/erikflowers/weather-icons), 基于 [SIL Open Font License (OFL) ](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)，可以免费商用不需要授权（思源字体也是基于这样的协议，感谢伟大的开源世界）。

图标下载下来可以操作的方式就比较多了，可以一个一个地处理svg变成相应分辨率的png图标（我推荐使用免费的figma或者gimp，收费的sketch或者ps），也可以用bmfont做成自定义的天气字体。

不展开说了，图片编辑不是我的强项，我只是会用一些方法。但是图片还是有一些处理的细节的，比如抗锯齿化（anti-aliasing）等等，这部分后面具体问题再说。



#### ⚠️注意事项

1. 佳明天气API中的天气获取**可能为空**，比如用户断开了手表和手机的蓝牙连接，记得进行空指针判断。
2. 天气图标不同分辨率下尺寸要调整，不然显示效果会比较差。



#### 本部分参考

1. Garmin Forums https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather.html



