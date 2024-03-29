# JPImageresizerView

[![CI Status](http://img.shields.io/travis/ZhouJianPing/JPImageresizerView.svg?style=flat)](https://travis-ci.org/ZhouJianPing/JPImageresizerView)
[![Version](https://img.shields.io/cocoapods/v/JPImageresizerView.svg?style=flat)](http://cocoapods.org/pods/JPImageresizerView)
[![License](https://img.shields.io/cocoapods/l/JPImageresizerView.svg?style=flat)](http://cocoapods.org/pods/JPImageresizerView)
[![Platform](https://img.shields.io/cocoapods/p/JPImageresizerView.svg?style=flat)](http://cocoapods.org/pods/JPImageresizerView)

英文文档（English document）：https://www.jianshu.com/p/5600da5c9bf6

## 简介

仿微信裁剪图片的一个裁剪小工具。

    目前功能：
        1.能自适应裁剪区域的缩放；
        2.高自由度的参数设定，包括裁剪区域的间距、裁剪宽高比、是否自适应缩放等；
        3.支持最多8个拖拽方向的裁剪区域；
        4.支持上左下右的旋转；
        5.水平和垂直的镜像翻转；
        6.两种边框样式；
        7.自定义遮罩颜色，或两种高斯模糊的遮罩。

    注意：
        1.由于autoLayout不利于手势控制，所以目前使用的是frame布局，暂不支持autoLayout；
        2.目前仅支持竖屏操作。
        
    之后的更新内容：
        1.Swift版本；
        2.适配横竖屏切换；
        3.更多新的边框和遮罩样式；
        4.更多的参数设定；
        5.实现苹果自带的裁剪功能中的自由拖拽旋转方向的效果。

![image](https://github.com/Rogue24/JPImageresizerView/raw/master/Cover/h05JLQ3kCA.gif)

## 如何使用

#### 初始化
```obj
// 方式一：使用工厂方法配置参数
// 可设置参数：裁剪的图片、frame、遮罩样式、边框样式、动画曲线、裁剪线颜色、背景色、遮罩透明度、垂直和水平的间距、裁剪的宽高比、裁剪框边线能否进行对边拖拽、裁剪区域的内边距、可否重置的回调、是否预备缩放的回调

JPImageresizerView *imageresizerView = [[JPImageresizerView alloc]
                        initWithResizeImage:[UIImage imageNamed:@"Girl.jpg"]
                        frame:frame
                        maskType:JPConciseFrameType
                        frameType:JPConciseFrameType
                        animationCurve:JPAnimationCurveLinear
                        strokeColor:[UIColor whiteColor]
                        bgColor:[UIColor blackColor]
                        maskAlpha:0.75
                        verBaseMargin:10
                        horBaseMargin:10
                        resizeWHScale:0
                        contentInsets:UIEdgeInsetsZero
                        imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
                            // 可在这里监听到是否可以重置
                            // 如果不需要重置（isCanRecovery为NO），可在这里做相应处理，例如将重置按钮设置为不可点或隐藏
                            // 具体操作可参照Demo
                            // 注意循环引用
                        }
                        imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
                            // 可在这里监听到裁剪区域是否预备缩放至适合范围
                            // 如果预备缩放（isPrepareToScale为YES），此时裁剪、旋转、镜像功能不可用，可在这里做相应处理，例如将对应按钮设置为不可点或隐藏
                            // 具体操作可参照Demo
                            // 注意循环引用
                        }];

// 方式二：使用JPImageresizerConfigure配置好参数再创建

JPImageresizerConfigure *configure = [JPImageresizerConfigure defaultConfigureWithResizeImage:image make:^(JPImageresizerConfigure *configure) {
    // 到这里已经有了默认参数值，可以在这里另外设置你想要的参数值（使用了链式编程方式）
    configure.jp_resizeImage([UIImage imageNamed:@"Kobe.jpg"]).
    jp_maskAlpha(0.5).
    jp_strokeColor([UIColor yellowColor]).
    jp_frameType(JPClassicFrameType).
    jp_contentInsets(contentInsets).
    jp_bgColor([UIColor orangeColor]).
    jp_isClockwiseRotation(YES).
    jp_animationCurve(JPAnimationCurveEaseOut);
}];

JPImageresizerView *imageresizerView = [JPImageresizerView imageresizerViewWithConfigure:self.configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
    // 可在这里监听到是否可以重置
    // 如果不需要重置（isCanRecovery为NO），可在这里做相应处理，例如将重置按钮设置为不可点或隐藏
    // 具体操作可参照Demo
    // 注意循环引用
} imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
    // 可在这里监听到裁剪区域是否预备缩放至适合范围
    // 如果预备缩放（isPrepareToScale为YES），此时裁剪、旋转、镜像功能不可用，可在这里做相应处理，例如将对应按钮设置为不可点或隐藏
    // 具体操作可参照Demo
    // 注意循环引用
}];

// 添加到视图上
[self.view addSubview:imageresizerView];
self.imageresizerView = imageresizerView;

// 注意：iOS11以下的系统，所在的controller最好设置automaticallyAdjustsScrollViewInsets为NO，不然就会随导航栏或状态栏的变化产生偏移
if (@available(iOS 11.0, *)) {

} else {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

// 创建后也可以修改以上部分参数（除了maskType和contentInsets）
self.imageresizerView.resizeImage = [UIImage imageNamed:@"Kobe.jpg"];
self.imageresizerView.resizeWHScale = 16.0 / 9.0;
```
#### 更改边框样式
![image](https://github.com/Rogue24/JPImageresizerView/raw/master/Cover/JPConciseFrameTypeCover.jpeg)
![image](https://github.com/Rogue24/JPImageresizerView/raw/master/Cover/JPClassicFrameTypeCover.jpeg)

```obj
// 目前只提供两种边框样式，分别是简洁样式JPConciseFrameType，和经典样式JPClassicFrameType
// 可在初始化或直接设置frameType属性来修改边框样式
self.imageresizerView.frameType = JPClassicFrameType;
```

#### 镜像翻转
![image](https://github.com/Rogue24/JPImageresizerView/raw/master/Cover/ggseHhuRnt.gif)

```obj
// 垂直镜像，YES->沿着Y轴旋转180°，NO->还原
BOOL isVerticalityMirror = !self.imageresizerView.verticalityMirror;
[self.imageresizerView setVerticalityMirror:isVerticalityMirror animated:YES];

// 水平镜像，YES->沿着X轴旋转180°，NO->还原
BOOL isHorizontalMirror = !self.imageresizerView.horizontalMirror;
[self.imageresizerView setHorizontalMirror:isHorizontalMirror animated:YES];
```


#### 旋转
```obj
// 默认逆时针旋转，旋转角度为90°
[self.imageresizerView rotation];

// 若需要顺时针旋转可设置isClockwiseRotation属性为YES
self.imageresizerView.isClockwiseRotation = YES;
```

#### 重置
```obj
// 重置为初始状态，方向垂直向上
[self.imageresizerView recovery];
```

#### 裁剪
```obj
// 裁剪过程是在子线程中执行，回调则切回主线程执行
// 如果是高清图片，调用前可添加HUD提示...
// referenceWidth：裁剪的图片的参照宽度，例如设置为375，如果裁剪区域为图片宽度的一半，则裁剪的图片宽度为187.5，而高度则根据宽高比得出，最大和最小不超过原图和imageView两者的宽度

// 1.默认以imageView的宽度为参照宽度进行裁剪
[self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
    // 裁剪完成，resizeImage为裁剪后的图片
    // 注意循环引用
}];

// 2.自定义参照宽度进行裁剪（例如按屏幕宽度）
[self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
    // 裁剪完成，resizeImage为裁剪后的图片
    // 注意循环引用
} referenceWidth:[UIScreen mainScreen].bounds.size.width];

// 3.以原图尺寸进行裁剪
[self.imageresizerView originImageresizerWithComplete:^(UIImage *resizeImage) {
    // 裁剪完成，resizeImage为裁剪后的图片
    // 注意循环引用
}];
```

#### 其他
```obj
// 锁定裁剪区域，锁定后无法拖动裁剪区域，NO则解锁
self.imageresizerView.isLockResizeFrame = YES;

// 旋转至水平方向时是否自适应裁剪区域大小
// 当图片宽度比图片高度小时，该属性默认YES，可手动设为NO
self.imageresizerView.isAutoScale = NO;
```

## 各版本的主要更新

#### 0.5.1~0.5.3 更新内容
    1.修复了设置镜像后的旋转、裁剪错乱问题；
    2.修复了切换裁剪比例时的缩放错误问题；
    3.移除isRotatedAutoScale属性（该属性会导致多处错误，且不利于优化，所以决定移除）；
    4.优化计算。

#### 0.4.9 更新内容
    新增edgeLineIsEnabled属性：用于设置裁剪框边线能否进行对边拖拽，只有当裁剪宽高比(resizeWHScale)为0，即任意比例时才有效，适用于所有边框样式，默认为yes。（之前是只有触碰上下左右的中点才可以进行对边拖拽，现在是整条边线的作用范围）

#### 0.4.3~0.4.6 更新内容
    1.修复了image的scale不为1的情况下裁剪错误问题；
    2.移除裁剪方法（imageresizerWithComplete:isOriginImageSize:），新增（originImageresizerWithComplete:）来代替原图尺寸裁剪；
    3.新增两个压缩尺寸裁剪方法（imageresizerWithComplete:referenceWidth:）和（imageresizerWithComplete:），其中referenceWidth为裁剪的图片的参照宽度，例如设置为375，如果裁剪区域为图片宽度的一半，则裁剪的图片宽度为187.5，而高度则根据宽高比得出，最大和最小不超过原图和imageView两者的宽度。
    4.修复了原图裁剪导致的内存泄露；
    5.修复了长久以来旋转后没有自动调整至最大尺寸的问题；
    6.修复了拖拽边框松手时没有立刻更新拖拽区域的问题。

#### 0.4.1 更新内容
    1.优化了重置动画；
    2.裁剪方法（imageresizerWithComplete:isOriginImageSize:）新增 isOriginImageSize 参数，YES 为裁剪的图片尺寸按原图尺寸裁剪，NO 则为屏幕尺寸。

#### 0.3.8~0.3.9 更新内容
    1.修复1:1比例情况下旋转导致错位的问题；
    2.优化代码结构，更好的注释。

#### 0.3.6 更新内容
    1.修复了图片旋转和镜像后裁剪位置错乱的问题；
    2.新增边框样式：只有4角拖拽方向的简洁样式（JPConciseWithoutOtherDotFrameType）。

#### 0.3.4 更新内容
    修复了指定裁剪宽高比（resizeWHScale大于0）的情况下，重置动画的错乱（recovery方法）。

#### 0.3.3 更新内容
    新增resizeWHScale的动画形式的设置接口（-setResizeWHScale:animated:）。

    说明：平时裁剪头像区域一般都是使用1:1的比例，但如果一进去就以该比例呈现，就会立马裁掉超出区域，可能会给人一种图片尺寸改变了的错觉，所以个人建议进去页面后（例如控制器的viewDidApper时）再调用改方法重新调整宽高比（请看gif图效果），这样用户体验会好点。

![image](https://github.com/Rogue24/JPImageresizerView/raw/master/Cover/ivpFV94K5W.gif)

#### 0.3.2 更新内容
    1.新增【裁剪区域预备缩放至适应范围的回调】，当预备缩放时裁剪、旋转、镜像功能不可用，可在这回调中作相应处理；
    2.修改【旋转后是否自动缩放】的属性名 isAutoScale -> isRotatedAutoScale。

#### 0.3.0 更新内容
    1.修正旋转水平方向时自动整体自适应缩小的问题，现在为图片宽度比图片高度小时才自适应，也可以手动设定；
    2.新增锁定功能，裁剪区域可锁定，无法继续拖动；
    3.新增镜像功能，可进行垂直方向和水平方向镜像操作。

#### 0.2.3 更新内容
    1.修复相册照片方向错乱的bug；
    2.修复水平方向边框点和线有所缩小的问题；
    3.更正属性的注释。

#### 0.2.0 更新内容
    1.新增高斯模糊的遮罩样式；
    2.可设置动画曲线；
    3.可设置裁剪区域的内边距；
    4.新增JPImageresizerConfigure类，更加方便设定参数。

## 安装

JPImageresizerView 可通过[CocoaPods](http://cocoapods.org)安装，只需添加下面一行到你的podfile：

```obj
pod 'JPImageresizerView'
```

## 反馈地址

    扣扣：184669029
    博客：https://www.jianshu.com/u/2edfbadd451c

## License

JPImageresizerView is available under the MIT license. See the LICENSE file for more info.

