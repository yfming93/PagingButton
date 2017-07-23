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
#define BUTTON_VIEW_WIDTH 60    //按钮视图的宽度
#define ICON_WIDTH_HEIGHT 40    //图标的宽高度（宽高要一样）
#define ICON_TITLE_SPACING 5.0  //图标和字的间距
#define TITLE_HEIGHT 15         //按钮上文字的高度
#define IMAGE_TO_BUTTON_TOP 5   //按钮图标到按钮顶部的距离
//按钮视图整个高度
#define BUTTON_H IMAGE_TO_BUTTON_TOP + ICON_WIDTH_HEIGHT + ICON_TITLE_SPACING + TITLE_HEIGHT

const

@interface ActionButtonView ()

@end

@implementation ActionButtonView

- (instancetype)initWithFrame:(CGRect)frame WithImageName:(NSString *)iconImageName WithTitle:(NSString *)title withTextColor:(UIColor *)textColor{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, IMAGE_TO_BUTTON_TOP, ICON_WIDTH_HEIGHT, ICON_WIDTH_HEIGHT)];
        
        if ([iconImageName hasPrefix:@"http"]) {
            [iconImageview sd_setImageWithURL:[NSURL URLWithString:iconImageName] placeholderImage:[UIImage imageNamed:[@"PagingButtonView.bundle" stringByAppendingPathComponent:@"placeholder-button-ima.png"]]];
        }else
            iconImageview.image = [UIImage imageNamed:iconImageName];
        
        [self addSubview:iconImageview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageview.frame) + ICON_TITLE_SPACING, self.frame.size.width, TITLE_HEIGHT)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = textColor;
        [self addSubview:label];
    }
    return self;
}

@end


@interface PagingButtonView ()

@property (nonatomic, strong) UIScrollView *bgScrollerView; //背景ScrollerView
@property (nonatomic, strong) UIPageControl *pageControl; //分页标识

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

    NSInteger count = bttTitleArr.count ,page = 0, pageControl_H = IMAGE_TO_BUTTON_TOP;
    /** pageControl_H是 _pageControl 的高度 */
    page = count / (_pagingRow * _pagingColumn); //分页个数
    if ( count % (_pagingRow * _pagingColumn) != 0)  page += 1;
    
    switch (self.pageControlStyle) {
        case PageControlStyleHiden:
            pageControl_H = 5;
            break;
        default:
            pageControl_H = 20;
            break;
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
  
    [self addPageControl:page pageControlStyle:self.pageControlStyle];

    float horizontalSpacing  = (self.frame.size.width - BUTTON_VIEW_WIDTH * _pagingColumn) / (_pagingColumn + 1);
    
    NSArray *tempTextColorArr;
    if ([textColorArrOrOne isKindOfClass:[NSArray class]]) {
        tempTextColorArr = textColorArrOrOne;
    }
    
    for (NSInteger p = 0; p < page; p ++) {
        UIView *multView = [[UIView alloc]initWithFrame:CGRectMake(bgScrollerView.frame.size.width * p, 0, bgScrollerView.frame.size.width, bgScrollerView.frame.size.height)];
        [bgScrollerView addSubview:multView];
        
        for (NSInteger i = p * _pagingRow * _pagingColumn ; i < bttTitleArr.count; i ++) {
            if (i < (p+1) * _pagingRow * _pagingColumn) {
                NSInteger column = ( i % ( _pagingRow * _pagingColumn )) % _pagingColumn;
                NSInteger rowNum = ( i % ( _pagingRow * _pagingColumn )) / _pagingColumn;
                
                
                
                //创建各个button
                CGFloat but_X = horizontalSpacing + (horizontalSpacing + BUTTON_VIEW_WIDTH) * column;
                CGFloat but_Y = ROW_SPACING + (ROW_SPACING + BUTTON_H) * rowNum;
                id textColor = [textColorArrOrOne isKindOfClass:[UIColor class]] ? textColorArrOrOne:(i < tempTextColorArr.count ? tempTextColorArr[i] : [UIColor blackColor]);
                
                ActionButtonView *buttonView = [[ActionButtonView alloc]initWithFrame:CGRectMake(but_X,but_Y, BUTTON_VIEW_WIDTH, BUTTON_H) WithImageName: (i < iconUrlsOrNames.count ? iconUrlsOrNames[i] : nil) WithTitle:bttTitleArr[i]  withTextColor:textColor ];
                
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

-(void)setPagingRow:(NSInteger)pagingRow {
    _pagingRow = pagingRow;
}

-(void)setPagingColumn:(NSInteger)pagingColumn {
    _pagingColumn = pagingColumn;
}

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
