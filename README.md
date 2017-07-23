# PagingButton

## 一、介绍：
#### 这是一个左右分页按钮的集合视图控件。用于快速编写出集合视图上分页多按钮点击事件！

效果图：<br>

![](https://ws1.sinaimg.cn/mw690/cb81ffe8gy1fht8em8hldg20ag0lbdqf.gif)

## 二、 使用：

> **pod 'PagingButton'**

**然后导入头文件，添加代理：**

    #import <PagingButtonView.h>
    
    @interface ViewController ()<PagingButtonViewDelegate>

**实现代理方法：**
可在代理方法里执行各个按钮点击后的跳转页面操作

    #pragma mark - PagingButtonViewDelegate
    - (void)PagingButtonView:(PagingButtonView *)actionView clickButtonWithIndex:(NSInteger)index {
        
        NSLog(@"clickButtonWithIndex：%ld",(long)index);
    }

#### 简单使用： 

    self.demo02 = [[PagingButtonView alloc] init];
    
    [_demo02 yfm_createPagingButtonViewWithFrame:CGRectMake(0, 350, [UIScreen mainScreen].bounds.size.width, 0) showToSuperView:self.view delegate:self iconUrlsOrNamesArr:@[@"yfzwxx",@"yfzsbs",@"yfqtms",@"yfxwzx",@"yfmsfq",@"yfczms",@"yfwzms",@"yfzzms",@"yf-homexzms",@"yf-homejctj",@"yf-homewifi",@"yf-hometqcx",@"yf-homekqcx",@"yf-homekdcx",@"yf-homeswcx",@"yf-homeswcx",@"yf-homeswcx"] buttonTextColorArrOrOneColor:[UIColor blueColor] buttonTitleArray:@[@"政务信息",@"掌上办事",@"倾听民声",@"新闻资讯",@"民俗风情",@"吃在天朝",@"玩在天朝",@"住在天朝",@"行在天朝",@"精彩图集",@"免费WIFI",@"天气查询",@"空气查询",@"快递查询",@"税务查询",@"违章查询",@"水费查询"]];


#### 自定义使用：


    self.demo01 = [[PagingButtonView alloc] init];
    
    //         pageControl 当前页颜色 【默认不写为 darkGrayColor】
            _demo01.pageControlCurrentPageColor = [UIColor redColor];
    
    //         pageControl 其他页颜色 【默认不写为 lightGrayColor】
            _demo01.pageControlOtherPageColor = [UIColor blueColor];
    
    //          PageControl 样式 【默认不写为 小灰点】
            _demo01.pageControlStyle = PageControlStyleLongImage;
    
            _demo01.pagingRow = 3; //设置行，不设置默认2行
            _demo01.pagingColumn = 5; //设置列 不设置默认4列
        
    //        按钮点击动画效果 【默认带有点击效果】
    //        _demo01.hasClickAnimation = NO;
    
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        title.textColor = [UIColor redColor];
        title.backgroundColor = [UIColor lightGrayColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"图标可以URL或者图片文件名称啊";
        
    //        设置大标题 【默认不设置 没有标题】
        _demo01.mainTitleLab = title;
    
    //        配置完自定义属性后最后一步调用此方法。 
      CGRect demo01frame =  [_demo01 yfm_createPagingButtonViewWithFrame:CGRectMake(20,50, 270, 0)  showToSuperView:self.view delegate:self iconUrlsOrNamesArr:@[@"yf-homeswcx",@"yf-homeswcx",@"yf-homeswcx",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"http://www.yooyoo360.com/photo/2009-1-1/20090113082955297.jpg",@"yf-homeswcx",@"yf-homeswcx",@"yf-homeswcx"] buttonTextColorArrOrOneColor:@[[UIColor colorWithRed:0.984 green:0.467 blue:0.082 alpha:1.000],[UIColor colorWithRed:0.169 green:0.557 blue:0.929 alpha:1.000],[UIColor colorWithRed:0.973 green:0.220 blue:0.247 alpha:1.000],[UIColor colorWithRed:0.525 green:0.780 blue:0.137 alpha:1.000],[UIColor colorWithRed:0.988 green:0.761 blue:0.145 alpha:1.000],[UIColor colorWithRed:0.757 green:0.341 blue:0.925 alpha:1.000],[UIColor colorWithRed:0.149 green:0.773 blue:0.682 alpha:1.000],[UIColor colorWithRed:0.929 green:0.267 blue:0.408 alpha:1.000],[UIColor colorWithRed:0.992 green:0.459 blue:0.078 alpha:1.000]] buttonTitleArray:@[@"政务信息",@"掌上办事",@"倾听民声",@"新闻资讯",@"民俗风情",@"吃在天朝",@"玩在天朝",@"住在天朝",@"行在天朝",@"精彩图集",@"免费WIFI",@"天气查询",@"空气查询",@"快递查询",@"税务查询",@"违章查询",@"水费查询"]];
        
        NSLog(@"demo02frame:(x:%f,y:%f,W:%f,H:%f)方便用于其它视图frame设置",demo01frame.origin.x,demo01frame.origin.y,demo01frame.size.width,demo01frame.size.height);


## 三、联系：
- 联系邮箱：yfmingo@163.com
- 联系网站：[www.yfmingo.cn](https://www.yfmingo.cn/)
- 项目地址：[https://github.com/yfming93/PagingButton](https://github.com/yfming93/PagingButton)

## 四、后记：
- 欢迎大家使用哈。如果大家发现问题和有好的建议欢迎随时  `Issues` 和 `Pull requests`
- 如果用的好欢迎点个星星以鼓励。你的 `Star`  是我源源不断努力优化的最大动力。




