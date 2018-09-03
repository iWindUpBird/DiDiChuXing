#
iOS 仿滴滴出行界面UI

简书链接[《iOS 仿滴滴出行界面UI（2）》](https://www.jianshu.com/p/e770908825f0)

看到不少人看了我的上一篇[《iOS 仿滴滴出行界面UI（1）》](https://www.jianshu.com/p/239b65caa677)的，看来还是有不少人有这个需求的，一直想再写一篇补充完善，一直懒得去写...

我更新了一下滴滴出行的APP，看到UI部分已经有了一点变化，但是变化不是很大。

好吧，我现在把做的一些仿的滴滴的UI发上来，顺便说一下是怎么实现的。

先说一下有哪些知识点会用到：UIScrollView、UITableView、KVO、响应链，总体来说就这些，还有一些琐碎的东西（例如UIView的动画的简单使用），下面边说边看吧。

##### 我已经把Demo发到了GitHub——[链接](https://github.com/1533889695/DiDiChuXing)。

---

##### Demo演示
GIF有4M，加载可能会慢：
![2018-09-03 12_22_00.gif](https://upload-images.jianshu.io/upload_images/11158342-b99a73ee2c555105.gif?imageMogr2/auto-orient/strip)

##### 1.视图的层级
先看一下视图的层级：

![62DE8DB4-FFB0-43CF-AD40-CCBE4223EB8E.png](https://upload-images.jianshu.io/upload_images/11158342-d38caa85cd0b5de8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

——（1级）UIViewController的UIView，也就是主视图；

————（2级）mapView，这一层是加在UIView上的，没什么疑问；

————（2级）headerView，头部视图，加在UIView上的；

————（2级）UIScrollView，加在UIView上的；

——————（3级）UITableView，加在UIScrollView上的；

——————（3级）和UITableView同级的其它视图，也加在UIScrollView上。

##### 2. ViewController里要加载的视图

```objc
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupMapView];        //地图视图
    [self setupHeaderView];   //HeaderView
    [self setupScrollView];      //ScrollView
    [self setupTableView];      //TableView
    [self setupTaxiView];        //TaxiView
}
```
##### 2. 说一下scrollView

将headerView和MapView加到UIView上之后，将ScrollView放到UIView上。

首先创建一个UIScrollView的子类，我这里取名叫XDSScrollView，然后重写它的
`- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event`方法（响应链的相关方法），重写后如下：
```objc
@implementation XDSScrollView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    //注意，这里是判断现在操作的界面是在ScrollView的哪一个部分上（快车还是出租车）
    int count = self.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = self.subviews[count];

    //手指点击的坐标本来是以主视图为基准的，现在我们以快车（XDSTbaleView）或出租车界面（XDSTaxiView）为基准。
    CGPoint viewPoint = [self convertPoint:point toView:view];
    
    //如果在快车（XDSTableView）或出租车界面（XDSTaxiView）外面，则操作地图
    if (viewPoint.y<0) {
        return nil;
    }
    //在快车（XDSTableView）或出租车界面（XDSTaxiView）里面，则正常调用此方法。
    return [super hitTest:point withEvent:event];
   
}
@end
```

然后在ViewController.m中设置ScrollView，注意颜色为透明的，contentSize为(0,0)。

```objc
#pragma mark - ScrollView视图
- (void)setupScrollView{
    
    XDSScrollView *scrollView = [[XDSScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.contentSize = CGSizeMake(0, 0);
    scrollView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;

}
```
然后将快车（XDSTableView）和出租车界面（XDSTaxiView）外面分别添加到scrollView的第一页和第二页上。

##### 3. 如何上滑tableView伸缩headerView

利用KVO监听XDSTableView的contentOffset。下面代码中self.tableView是目标对象，也就是被监听的对象，监听的属性是contentOffset；Observer是self，即ViewController。
```objc
  //添加KVO监听
 [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
```
KVO的回调方法如下。在里面判断tableView滑到屏幕的一半时，headerView就会收缩，使用了`animateWithDuration...`方法做平滑动画效果。
```objc
#pragma mark - KVO 监听tableView（收缩头部视图）
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGPoint tableContenOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        if (tableContenOffset.y > -ScreenH*0.5) {
            
            if (self.headerView.xds_y == 0) {
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{ //0.15秒内做完改变frame的动画，动画效果匀速
                    self.headerView.xds_y = -headerH;
                } completion:nil];
                
            }
            
        }
        if (tableContenOffset.y < -ScreenH*0.5) {
            
            if (self.headerView.xds_y == -headerH) {
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{ //0.15秒内做完改变frame的动画，动画效果匀速
                    
                    self.headerView.xds_y = 0;;
                } completion:nil];
                
            }
        }
    }
    
}
```

##### 4. 快车（XDSTableView）和出租车界面（XDSTaxiView）

将XDSTableView添加到XDSScrollView作为第一个子视图，设置contentInset将其下移；将XDSTaxiView作为XDSScrollView的第二个子视图添加上去。

然后headerView上的两个按钮的点击事件设置一下。

---

先说到这里吧，后面有空的话会在完善。

> 对你有帮助的话可以点个喜欢，谢谢~~

> 如有错误或改进，烦请指出，感谢！

