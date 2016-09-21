//
//  UIPullView.h
//  BusinessTrips
//
//  Created by 姚飞剑 on 16/9/2.
//  Copyright © 2016年 mamahome. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UIPullView;

@protocol UIPullViewDelegate <NSObject>

@optional

/**
 *  展开pullview
 *
 *  @param view 回传UIPullView
 */
- (void)viewDidUnfold:(UIPullView*)view;

/**
 *  收起pullview
 *
 *  @param view 回传UIPullView
 */
- (void)viewDidFold:(UIPullView*)view;
@end


@interface UIPullView : UIView

@property (nonatomic, strong) UIButton* arrowBtn;
@property (nonatomic, weak) id<UIPullViewDelegate> delegate;
@property (nonatomic, assign) BOOL isUnfold;    //是否已经展开，默认NO，没有展开

+ (CGFloat)heightForBottomPullView;
+ (CGFloat)heightForContentView;
+ (CGFloat)heightForView;
@end
