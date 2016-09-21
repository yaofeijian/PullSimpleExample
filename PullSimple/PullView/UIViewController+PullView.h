//
//  UIViewController+PullView.h
//  BusinessTrips
//
//  Created by 姚飞剑 on 16/9/5.
//  Copyright © 2016年 mamahome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PullView)


/**
 *  将需要拖拽的view插入到belowview的视图下面
 *
 *  @param pullView          拖拽移动视图
 *  @param belowView         覆盖在拖拽视图之上的view
 *  @param contentHeight     指定拖拽视图的可移动内容高度
 *  @param presentCallBack   出现回调
 *  @param dismissedCallBack 消失回调
 *  调用示例：
     self.pullView.frame = CGRectMake(0, [UIBookingInfoHeadView heightForView:self.view.width order:self.order] - [UIPullView heightForContentView], self.view.width, [UIPullView heightForView]);
     [self insertPullView:self.pullView belowView:self.headView contentViewHeight:[UIBookingPullContentView heightForContentView] presentCallBack:^{
        NSLog(@"present");
     } dimissedCallBack:^{
        NSLog(@"dimiss");
     }];
 */
- (void)insertPullView:(UIView*)pullView belowView:(UIView*)belowView contentViewHeight:(CGFloat)contentHeight presentCallBack:(void(^)(void))presentCallBack dimissedCallBack:(void(^)(void))dismissedCallBack;

/**
 *  手动将视图显示
 */
- (void)presentPullView;

/**
 *  手动将视图隐藏
 */
- (void)dismissPullView;

@end
