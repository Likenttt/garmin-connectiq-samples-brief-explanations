### 错误日志中的pc:0x10001f4c是什么意思，怎么定位问题？

放出亲爱的jim大叔的经典文章](https://forums.garmin.com/developer/connect-iq/f/discussion/231129/so-you-have-a-ciq_log-file-but-all-you-see-is-pc-without-a-friendly-stack-trace---what-to-do)

pc是Program counter的缩写，即程序计数器。

总结下jim大叔说的，把0x10001f4c转换成十进制数字，然后去项目编译后的bin/目录中的 xxxdebug.xml搜索，直接找不到的话，从低位开始删除一位再搜索，如果还是搜索不到，再删除。一般来说，删除一位两位就够了，找到附近的真实代码行号，这样就定位到出问题的行了。具体的问题需要自行分析是了，是空指针还是什么其他问题。
