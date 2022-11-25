### 使用 Makefile 管理开发各阶段

佳明的插件非常不给力, 经常有各种各样的问题, 目前遇到的比较严重的问题是直接提示 sdk 版本太低, 但是实际并非如此. 关于此问题的讨论可以看这个 thread 以及 FlowState 提出的 bugreport.
https://forums.garmin.com/developer/connect-iq/f/discussion/276200/vscode-extension-failed-to-launch-the-app-timeout/1502579#1502579
2022 年 11 月前后, 我追踪到了佳明 vscode 的插件源代码, 用 hardcode 的方式暂时解决了问题, 如果你有类似问题可以追踪到上面这个 thread 中我的原问题找到最下面的 workaround 解法. 希望后续的版本能修复吧,不然还要继续 hack.

使用 makefile 构建的完整示范代码,忘了用中文写,凑活着看吧.
https://github.com/Likenttt/garmin-connect-iq-makefile-demo
主体思路借用了某个网友的 github 仓库中的代码,但是是哪位大神的我忘记了, 应该是示例之一.
