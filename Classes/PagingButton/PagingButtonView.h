//
//  PagingButtonView.h
//  PagingButton
//
//  Created by Mingo on 2017/7/20.
//  Copyright © 2017年 袁凤鸣. All rights reserved.
//
//  联系邮箱： yfmingo@163.com
//  个人主页： https://www.yfmingo.cn
//  项目地址： https://github.com/yfming93/PagingButton

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PagingButtonView;
@protocol PagingButtonViewDelegate <NSObject>

/**
 PagingButtonView 协议方法
 @param actionView PagingButtonView
 @param index 按钮位于数据源中的下标位置
 */
- (void)PagingButtonView:(PagingButtonView *)actionView clickButtonWithIndex:(NSInteger)index;

@end

@interface ActionButtonView: UIButton
@end

typedef NS_ENUM(NSInteger, PageControlStyle) {
    PageControlStyleHiden = 1,      //隐藏
    PageControlStyleLongImage = 2,  //长图片
    PageControlStyleGrayDot = 3     //小灰点
    
};

@interface PagingButtonView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) id <PagingButtonViewDelegate> delegate;

@property (nonatomic, assign) PageControlStyle pageControlStyle; //pageControlStyle样式
@property (nonatomic, strong) UIColor   *pageControlCurrentPageColor; //当前page颜色
@property (nonatomic, strong) UIColor   *pageControlOtherPageColor;  //其他page颜色
@property (nonatomic, assign) NSInteger pagingRow; //行数
@property (nonatomic, assign) NSInteger pagingColumn; //列数
@property (nonatomic, strong) UILabel   *mainTitleLab; //标题 【不赋值默认无标题】
@property (nonatomic, assign) BOOL      hasClickAnimation; //是否有点击动画【默认开启】

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
- (CGRect )yfm_createPagingButtonViewWithFrame:(CGRect)frame showToSuperView:(UIView *)superView delegate:(id)delegate iconUrlsOrNamesArr:(NSArray *)iconUrlsOrNames  buttonTextColorArrOrOneColor:(id)textColorArrOrOne buttonTitleArray:(NSArray *)bttTitleArr;

@end
