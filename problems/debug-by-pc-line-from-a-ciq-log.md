### 错误日志中的 pc:0x10001f4c 是什么意思，怎么定位问题？

放出亲爱的 jim 大叔的经典文章](https://forums.garmin.com/developer/connect-iq/f/discussion/231129/so-you-have-a-ciq_log-file-but-all-you-see-is-pc-without-a-friendly-stack-trace---what-to-do)

pc 是 Program counter 的缩写，即程序计数器。

总结下 jim 大叔说的，把 0x10001f4c 转换成十进制数字，然后去项目编译后的 bin/目录中的 xxxdebug.xml 搜索，直接找不到的话，从低位开始删除一位再搜索，如果还是搜索不到，再删除。一般来说，删除一位两位就够了，找到附近的真实代码行号，这样就定位到出问题的行了。具体的问题需要自行分析是了，是空指针还是什么其他问题。

最推荐的还是用 ERA report, 该工具的可读性比较好. 对于不同的机型, 如果是同一个错误, 即便是不同机型编译的最终代码不同, 该工具最终都能将问题聚合到同一个行号.
