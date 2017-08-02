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
//mainScreen
#define kScreenW    [UIScreen mainScreen].bounds.size.width       //屏幕宽度
#define kScreenH    [UIScreen mainScreen].bounds.size.height      //屏幕高度
#define kFit(x)       (kScreenW*((x)/375.0))

#define ROW_SPACING  kFit(5.0)          //行间距
#define ICON_TITLE_SPACING kFit(5.0)  //图标和字的间距
#define TITLE_HEIGHT kFit(15.0)         //按钮上文字的高度

const

@interface ActionButtonView ()

@property (nonatomic, assign) CGFloat   actionButtonViewWidth; //实际按钮宽度
@property (nonatomic, strong) NSString  *actionButtonPlaceholderName; //按钮图标若为URL时的占位图
@property (nonatomic, assign) NSInteger pagingColumn; //列数
@property (nonatomic, assign) CGSize actionButtonIconSize; //实际按钮图标大小
@property (nonatomic, assign) CGFloat actionButtonfontSize;

- (void)yfm_setWithFrame:(CGRect)frame WithImageName:(NSString *)iconImageName WithTitle:(NSString *)title withTextColor:(UIColor *)textColor;


@end

@implementation ActionButtonView

- (void)yfm_setWithImageName:(NSString *)iconImageName WithTitle:(NSString *)title withTextColor:(UIColor *)textColor {
    
    CGFloat padding = (self.frame.size.height - TITLE_HEIGHT -_actionButtonIconSize.height)/4;
    UIImageView *iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake((_actionButtonViewWidth - _actionButtonIconSize.width)/2, padding, _actionButtonIconSize.width, _actionButtonIconSize.height)];
    
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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - TITLE_HEIGHT - padding  , self.frame.size.width, TITLE_HEIGHT)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    if (!self.actionButtonfontSize)  self.actionButtonfontSize = 12.0f;
    label.font = [UIFont systemFontOfSize:self.actionButtonfontSize];
    
    label.textColor = textColor;
    [self addSubview:label];
}

@end


@interface PagingButtonView ()

@property (nonatomic, strong) UIScrollView *bgScrollerView; //背景ScrollerView
@property (nonatomic, strong) UIPageControl *pageControl; //分页标识
@property (nonatomic, assign) CGFloat buttonViewsWidth; //按钮的宽度 （屏幕宽度除以列数）

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
    
    NSInteger count = bttTitleArr.count ,page = 0, pageControl_H = kFit(5.0f) ;
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
            pageControl_H = kFit(5.0f);
            break;
        default:
            pageControl_H = kFit(20);
            if ((self.pagingColumn * self.pagingRow ) >= count) {
                pageControl_H = kFit(5.0f);
            }
            break;
    }
    
    self.buttonViewsWidth = frame.size.width / self.pagingColumn;
    
    if (self.pageButtonIconSize.width > self.buttonViewsWidth) {
        self.pageButtonIconSize  = CGSizeMake(_buttonViewsWidth, _buttonViewsWidth);
    }else if (self.pageButtonIconSize.width <= 0.0) {
        self.pageButtonIconSize = CGSizeMake(kFit(40.0f), kFit(40.0f));
    }
    
    CGFloat icon_MAXH = (frame.size.height - pageControl_H -_mainTitleLab.frame.size.height - _mainTitleLab.frame.origin.y  -ROW_SPACING *(_pagingRow - 1)) /_pagingRow - ICON_TITLE_SPACING -TITLE_HEIGHT;
    if (self.pageButtonIconSize.height > icon_MAXH) {
        self.pageButtonIconSize  = CGSizeMake(icon_MAXH, icon_MAXH  );
    }
    
    CGFloat BUTTON_H = self.pageButtonIconSize.height + ICON_TITLE_SPACING + TITLE_HEIGHT;
    
    CGFloat ALL_H =  BUTTON_H *_pagingRow + ROW_SPACING * (_pagingRow - 1) + pageControl_H + _mainTitleLab.frame.size.height + _mainTitleLab.frame.origin.y;
    if ( ALL_H > frame.size.height ) {
        //按照frame高度来重新计算出 ALL_H
        self.pageButtonIconSize  = CGSizeMake((frame.size.height - ROW_SPACING * (_pagingRow - 1)) /_pagingRow, (frame.size.height - ROW_SPACING) /_pagingRow);
        ALL_H =  BUTTON_H *_pagingRow + ROW_SPACING * (_pagingRow - 1) + pageControl_H + _mainTitleLab.frame.size.height + _mainTitleLab.frame.origin.y;
        
    }else {
        ALL_H = frame.size.height;
        BUTTON_H = icon_MAXH + ICON_TITLE_SPACING + TITLE_HEIGHT; //重置按钮高度
    }
    
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
                CGFloat but_X = _buttonViewsWidth * column;
                CGFloat but_Y = ROW_SPACING + (ROW_SPACING + BUTTON_H) * rowNum;
                id textColor = [textColorArrOrOne isKindOfClass:[UIColor class]] ? textColorArrOrOne:(i < tempTextColorArr.count ? tempTextColorArr[i] : [UIColor blackColor]);
                
                ActionButtonView *buttonView = [[ActionButtonView alloc]init];
                buttonView.actionButtonViewWidth = self.buttonViewsWidth;
                buttonView.pagingColumn = self.pagingColumn;
                
                if (self.pageButtonTitleFontSize)
                    buttonView.actionButtonfontSize = _pageButtonTitleFontSize;
                
                if (self.pagingButtonPlaceholderName.length) buttonView.actionButtonPlaceholderName = self.pagingButtonPlaceholderName;
                
                buttonView.actionButtonIconSize = _pageButtonIconSize;
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
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - kFit(18.0f), self.frame.size.width, kFit(20))];
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

/** 按钮的图标大小（建议宽高相等）。【若设置过大则程序会根据主View的高度推算出一个最大值的图标宽高】 */
-(void)setPageButtonIconSize:(CGSize)pageButtonIconSize {
    
    _pageButtonIconSize = pageButtonIconSize;
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
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 3.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
