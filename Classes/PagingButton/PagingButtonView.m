//
//  PagingButtonView.m
//  PagingButton
//
//  Created by Mingo on 2017/7/20.
//  Copyright © 2017年 袁凤鸣. All rights reserved.
//
//  联系邮箱： yfmingo@163.com
//  个人主页： https://www.yfmingo.cn
//  项目地址： https://github.com/yfming93/PagingButton


#import "PagingButtonView.h"
#import "UIImageView+WebCache.h"

#define ROW_SPACING 5           //行间距
#define ICON_TITLE_SPACING 5.0  //图标和字的间距
#define TITLE_HEIGHT 15         //按钮上文字的高度
#define IMAGE_TO_BUTTON_TOP 10.0   //按钮图标到按钮顶部的距离
//按钮视图整个高度
#define BUTTON_H IMAGE_TO_BUTTON_TOP/2 + (self.buttonViewsWidth - IMAGE_TO_BUTTON_TOP * 2) + ICON_TITLE_SPACING + TITLE_HEIGHT

const

@interface ActionButtonView ()

@property (nonatomic, assign) CGFloat   actionButtonViewWidth; //实际按钮宽度
@property (nonatomic, strong) NSString  *actionButtonPlaceholderName; //按钮图标若为URL时的占位图
@property (nonatomic, assign) NSInteger pagingColumn; //列数

- (void)yfm_setWithFrame:(CGRect)frame WithImageName:(NSString *)iconImageName WithTitle:(NSString *)title withTextColor:(UIColor *)textColor;


@end

@implementation ActionButtonView


- (void)yfm_setWithImageName:(NSString *)iconImageName WithTitle:(NSString *)title withTextColor:(UIColor *)textColor {
    
    UIImageView *iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake(IMAGE_TO_BUTTON_TOP, IMAGE_TO_BUTTON_TOP/2, (self.actionButtonViewWidth - IMAGE_TO_BUTTON_TOP * 2), (self.actionButtonViewWidth - IMAGE_TO_BUTTON_TOP * 2))];
    
    UIImage *placeholderIma ;
    if (self.actionButtonPlaceholderName.length){
        
        placeholderIma = [UIImage imageNamed:self.actionButtonPlaceholderName];
    }else {
        placeholderIma = [UIImage imageNamed:[@"PagingButtonView.bundle" stringByAppendingPathComponent:@"placeholder-button-ima.png"]];
    }
    
    if ([iconImageName hasPrefix:@"http"]) {
        [iconImageview sd_setImageWithURL:[NSURL URLWithString:iconImageName] placeholderImage:placeholderIma];
    }else
    iconImageview.image = [UIImage imageNamed:iconImageName];
    
    [self addSubview:iconImageview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageview.frame) + ICON_TITLE_SPACING, self.frame.size.width, TITLE_HEIGHT)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    if (self.pagingColumn > 6 ) {
        
        label.font = [UIFont systemFontOfSize:8];
    }else if (self.pagingColumn > 4 ) {
        
        label.font = [UIFont systemFontOfSize:10];
    }
    
    label.textColor = textColor;
    [self addSubview:label];
}

@end


@interface PagingButtonView ()

@property (nonatomic, strong) UIScrollView *bgScrollerView; //背景ScrollerView
@property (nonatomic, strong) UIPageControl *pageControl; //分页标识
@property (nonatomic, assign) CGFloat buttonViewsWidth; //按钮的宽度 默认60 。若溢出自动从设【同时 传值给 actionButtonViewWidth 用作实际按钮宽度】

@end


@implementation PagingButtonView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hasClickAnimation = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.mainTitleLab = [[UILabel alloc] init];
        self.mainTitleLab.textAlignment = NSTextAlignmentCenter;
        self.pagingRow = 2;
        self.pagingColumn = 4;
        self.buttonViewsWidth = 60.0;
    }
    return self;
}

/**
 创建 PagingButtonView 【请在设置好相关属性后 最后一步调用此方法】
 
 @param frame 传入的frame 【注意 ：传入的 height 是无效的。 视图高度为动态生成】
 @param superView 显示在父视图上
 @param delegate 代理
 @param iconUrlsOrNames 按钮图标数组 【网络URL 或者 本地图片名称】
 @param textColorArrOrOne 按钮文字的颜色 【传入颜色数组分别设置 或者 传入一个色值统一为一种颜色】
 @param bttTitleArr 按钮文字数组
 @return 返回 PagingButtonView 自身的 frame （方便用于设置其他上下视图）
 */
- (CGRect )yfm_createPagingButtonViewWithFrame:(CGRect)frame showToSuperView:(UIView *)superView delegate:(id)delegate iconUrlsOrNamesArr:(NSArray *)iconUrlsOrNames  buttonTextColorArrOrOneColor:(id)textColorArrOrOne buttonTitleArray:(NSArray *)bttTitleArr
{
    self.delegate = delegate;
    if (_mainTitleLab.text.length) {
        //标题
        [_mainTitleLab setFrame:CGRectMake(self.mainTitleLab.frame.origin.x, self.mainTitleLab.frame.origin.y, ((frame.size.width > self.mainTitleLab.frame.size.width) && self.mainTitleLab.frame.size.width != 0 ) ? self.mainTitleLab.frame.size.width : frame.size.width,
                                           self.mainTitleLab.frame.size.height ? self.mainTitleLab.frame.size.height : 30)];
        [self addSubview:_mainTitleLab];
        
    }
    
    if (!self.pagingRow)  self.pagingRow = 2 ; //默认设置 2 行
    if (!self.pagingColumn) self.pagingColumn = 4 ; //默认设置 4 列
    
    NSInteger count = bttTitleArr.count ,page = 0, pageControl_H = IMAGE_TO_BUTTON_TOP/2;
    /** pageControl_H是 _pageControl 的高度 */
    
    while ((_pagingRow * _pagingColumn - count) >= _pagingColumn) {
        self.pagingRow -= 1;  //【若 行数过大导致空白多行则会自动重算行数】
    }
    
    page = count / (_pagingRow * _pagingColumn); //分页个数
    if ( (count % ( _pagingRow * _pagingColumn ))!= 0) {
        page = page + 1;
    }
    
    switch (self.pageControlStyle) {
            case PageControlStyleHiden:
            pageControl_H = 5;
            break;
        default:
            pageControl_H = 20;
            if ((self.pagingColumn * self.pagingRow ) >= count) {
                pageControl_H = 15;
            }
            break;
    }
    
    float horizontalSpacing = 0; //每列按钮的间隙
    
    if (frame.size.width >= (self.buttonViewsWidth * self.pagingColumn)) {
        horizontalSpacing = (frame.size.width - self.buttonViewsWidth * _pagingColumn) / (_pagingColumn + 1);
    }else {
        
        horizontalSpacing = 3.0f;
        self.buttonViewsWidth = (frame.size.width - horizontalSpacing * (_pagingColumn + 1)) / _pagingColumn;
    }
    
    CGFloat ALL_H =  ( BUTTON_H + ROW_SPACING ) * _pagingRow + pageControl_H + _mainTitleLab.frame.size.height + _mainTitleLab.frame.origin.y;
    self.frame = CGRectMake(frame.origin.x , frame.origin.y, frame.size.width, ALL_H);
    UIScrollView *bgScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,_mainTitleLab.frame.size.height + _mainTitleLab.frame.origin.y, self.frame.size.width, self.frame.size.height - _mainTitleLab.frame.size.height)];
    bgScrollerView.backgroundColor = self.backgroundColor;
    bgScrollerView.pagingEnabled = YES;
    bgScrollerView.showsHorizontalScrollIndicator = NO;
    bgScrollerView.delegate = self;
    bgScrollerView.bounces = NO;
    bgScrollerView.contentSize = CGSizeMake(self.frame.size.width * page, bgScrollerView.frame.size.height);
    self.bgScrollerView = bgScrollerView;
    [self addSubview:_bgScrollerView];
    
    if ((self.pagingColumn * self.pagingRow ) < count) {
        [self addPageControl:page pageControlStyle:self.pageControlStyle];
    }
    
    NSArray *tempTextColorArr;
    if ([textColorArrOrOne isKindOfClass:[NSArray class]]) {
        tempTextColorArr = textColorArrOrOne;
    }
    
    for (NSInteger p = 0; p < page; p ++) {
        UIView *multView = [[UIView alloc]initWithFrame:CGRectMake(bgScrollerView.frame.size.width * p, 0, bgScrollerView.frame.size.width, bgScrollerView.frame.size.height)];
        [bgScrollerView addSubview:multView];
        
        for (NSInteger i = (p * (_pagingRow * _pagingColumn ) ); i < bttTitleArr.count; i ++) {
            if (i < ((p+1) * _pagingRow * _pagingColumn)) {
                NSInteger column = ( i % ( _pagingRow * _pagingColumn )) % _pagingColumn;
                NSInteger rowNum = ( i % (_pagingRow * _pagingColumn)) / _pagingColumn;
                
                
                
                //创建各个button
                CGFloat but_X = horizontalSpacing + (horizontalSpacing + _buttonViewsWidth) * column;
                CGFloat but_Y = ROW_SPACING + (ROW_SPACING + BUTTON_H) * rowNum;
                id textColor = [textColorArrOrOne isKindOfClass:[UIColor class]] ? textColorArrOrOne:(i < tempTextColorArr.count ? tempTextColorArr[i] : [UIColor blackColor]);
                
                ActionButtonView *buttonView = [[ActionButtonView alloc]init];
                buttonView.actionButtonViewWidth = self.buttonViewsWidth;
                buttonView.pagingColumn = self.pagingColumn;
                if (self.pagingButtonPlaceholderName.length) buttonView.actionButtonPlaceholderName = self.pagingButtonPlaceholderName;
                
                
                [buttonView setFrame:CGRectMake(but_X,but_Y, _buttonViewsWidth, BUTTON_H)];
                [buttonView yfm_setWithImageName: (i < iconUrlsOrNames.count ? iconUrlsOrNames[i] : nil) WithTitle:bttTitleArr[i]  withTextColor:textColor ];
                
                [buttonView addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                buttonView.tag = i;
                
                [multView addSubview:buttonView];
                
            }
        }
    }
    
    [superView addSubview:self];
    return self.frame;
}

- (void)addPageControl:(NSInteger)page pageControlStyle:(PageControlStyle)pageControlStyle {
    
    if (pageControlStyle != PageControlStyleHiden) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 18, self.frame.size.width, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = page;
        [self addSubview:_pageControl];
    }
    
    if (pageControlStyle  == PageControlStyleLongImage ) {
        [_pageControl setValue:[self yfm_imageWithColor:self.pageControlCurrentPageColor ? self.pageControlCurrentPageColor : [UIColor darkGrayColor]] forKeyPath:@"_currentPageImage"];
        [_pageControl setValue:[self yfm_imageWithColor:self.pageControlOtherPageColor ? self.pageControlOtherPageColor : [UIColor lightGrayColor]] forKeyPath:@"_pageImage"];
        
    }else if ((pageControlStyle == PageControlStyleGrayDot) | !pageControlStyle) {
        
        _pageControl.currentPageIndicatorTintColor = self.pageControlCurrentPageColor ? self.pageControlCurrentPageColor : [UIColor darkGrayColor];
        _pageControl.pageIndicatorTintColor = self.pageControlOtherPageColor ? self.pageControlOtherPageColor : [UIColor lightGrayColor];
    }
}

-(void)setPageControlCurrentPageColor:(UIColor *)pageControlCurrentPageColor {
    _pageControlCurrentPageColor = pageControlCurrentPageColor;
}

-(void)setPageControlOtherPageColor:(UIColor *)pageControlOtherPageColor {
    _pageControlOtherPageColor = pageControlOtherPageColor;
}

/** 行数 【若 行数过大导致空白多行则会自动重算行数】*/
-(void)setPagingRow:(NSInteger)pagingRow {
    if (pagingRow < 1) pagingRow = 1;
    
    _pagingRow = pagingRow;
}

/** 列数 【最大 8列，不然文字显示不全哈。】 */
-(void)setPagingColumn:(NSInteger)pagingColumn {
    
    if (pagingColumn > 8)
    pagingColumn = 8;
    else if (pagingColumn < 1)
    pagingColumn = 4;
    
    
    _pagingColumn = pagingColumn;
}

/** 标题 【不赋值默认无标题】 */
- (void)setMainTitleLab:(UILabel *)mainTitleLab {
    _mainTitleLab = mainTitleLab;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x/self.frame.size.width;
    _pageControl.currentPage = page;
}

- (void)actionButtonClick:(UIButton *)btn{
    
    if (self.hasClickAnimation == YES) {
        [UIView animateWithDuration:1.0 animations:^{
            btn.alpha = 0.5;
            
            [UIView animateWithDuration:0.5 animations:^{
                btn.alpha = 1.0;
            }];
        }];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(PagingButtonView:clickButtonWithIndex:)]) {
        [self.delegate PagingButtonView:self clickButtonWithIndex:btn.tag];
    }
}

#pragma mark - 颜色创建UIImage
- (UIImage *)yfm_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 30.0f, 3.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
