# CSToast

一个简洁的提示框（Toast），可以用于用户提示，或者测试提示。该版为Swift版。

### OC版入口：[CSToast-OC](https://github.com/JoslynWu/CSToast-OC.git)

## 效果

![](/resource/CSToast.gif)

##  关于工具:

 - 本工具默认以window为载体，显示在window中心。可以调整与上下边的距离。
 - 可以指定在显示在某个View中心。
 - Toast接收点击事件，点击时可以移除。
 
##  关于API:

 除了常用的text和duration外，其他配置都放在闭包里。
 
##  关于使用

将下列文件（CSToast目录下）拖入项目即可

```
CSToast.swift
```
 
##  关于说明

- `func viewDidAppear(_ animated: Bool)`之后调用有效。
- 位置属性权重：inView > top > bottom。 及同时设置时，权重高的生效。
- 头文件中有相应说明。