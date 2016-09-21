//
//  UIViewController+PullView.m
//  BusinessTrips
//
//  Created by 姚飞剑 on 16/9/5.
//  Copyright © 2016年 mamahome. All rights reserved.
//

#import "UIViewController+PullView.h"
#import "UIView+Extension.h"
#import <objc/runtime.h>

#define kPullBGView @"kPullBGView"
#define kPullView @"kPullView"
#define kSourcePullViewCGRect @"kSourcePullViewCGRect"
#define kBelowView @"kBelowView"
#define kTapGestureRecognizer @"kTapGestureRecognizer"
#define kPanGestureRecognizer @"kPanGestureRecognizer"
#define kPullViewContentHeight @"kPullViewContentHeight"
#define kPullViewIsUnfold   @"kPullViewIsUnfold"
#define kPullViewScrollY  @"kPullViewScrollY"
#define kPullViewPanDown  @"kPullViewPanDown"
#define kDimissedPullViewCallBack @"kDimissedPullViewCallBack"
#define kPrensentedPullViewCallBack @"kPrensentedPullViewCallBack"

@interface UIViewController (PullViewControllerPrivate)
@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UIView *belowView;
@property (nonatomic, retain) UIView *pullView;
@property (nonatomic, retain) NSString *pullViewSrouceRect;
@property (nonatomic, retain) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, retain) NSString *contentHeight;
@property (nonatomic, retain) NSNumber *isUnfold; //是否已经展开
@property (nonatomic, retain) NSNumber *scrollY; //不停变换的Y，用来判断手势方向
@property (nonatomic, retain) NSNumber *isPanDwon;  //是否是向下手势
@property (nonatomic, copy) void (^dimissedPullViewCallBack)();
@property (nonatomic, copy) void (^prensentedPullViewCallBack)();
@end

@implementation UIViewController (PullView)

#define kFloatIsEqual(f1,f2) (ABS(f1 - f2) < 0.000001)

- (void)insertPullView:(UIView*)pullView belowView:(UIView*)belowView contentViewHeight:(CGFloat)contentHeight presentCallBack:(void(^)(void))presentCallBack dimissedCallBack:(void(^)(void))dismissedCallBack {
    self.isUnfold = @(NO);
    self.prensentedPullViewCallBack = presentCallBack;
    self.dimissedPullViewCallBack = dismissedCallBack;
    self.pullView = pullView;
    self.belowView = belowView;
    
    self.pullViewSrouceRect = NSStringFromCGRect(pullView.frame);
    self.contentHeight = [NSString stringWithFormat:@"%0.2f",contentHeight];
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0;
    
    
    [self.view insertSubview:self.pullView belowSubview:belowView];
    [self.view insertSubview:self.bgView belowSubview:self.pullView];
    
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapBgView)];
    [self.bgView addGestureRecognizer:self.tapGestureRecognizer];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onPanBgView)];
    [self.pullView addGestureRecognizer:self.panGestureRecognizer];
    
    
}
- (void)presentPullView{
    [self show:YES];
}

- (void)dismissPullView {
    [self dismiss:YES];
}

- (void)show:(BOOL)animation{
    CGFloat x = self.pullView.width / 2.0;
    int y = 0;
    
    CGRect sourceRect = CGRectFromString(self.pullViewSrouceRect);
    
    CGFloat top = sourceRect.origin.y + [self.contentHeight floatValue];
    CGFloat bottom = sourceRect.origin.y + [self.contentHeight floatValue] + sourceRect.size.height;
    y = (top + bottom)/2;
    
    CGFloat velocityX = (0.2 *self.pullView.center.x);
    if (animation) {
        [UIView animateWithDuration:ABS(velocityX * 0.00002 + 0.2) delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bgView.alpha = 0.3;
            self.pullView.frame = CGRectMake(self.pullView.x, self.belowView.maxY, self.pullView.width, self.pullView.height);
        } completion:^(BOOL finished) {
            if (![self.isUnfold boolValue]) {
                if (self.prensentedPullViewCallBack) {
                    self.prensentedPullViewCallBack();
                }
            }
            self.isUnfold = @(YES);
        }];
    }else {
        self.bgView.alpha = 0.3;
        self.pullView.frame = CGRectMake(self.pullView.x, self.belowView.maxY, self.pullView.width, self.pullView.height);
        self.pullView.center = CGPointMake(x, y);
        if (![self.isUnfold boolValue]) {
            if (self.prensentedPullViewCallBack) {
                self.prensentedPullViewCallBack();
            }
        }
        self.isUnfold = @(YES);
    }
    
}
- (void)dismiss:(BOOL)animation {
    CGFloat x = self.pullView.width / 2.0;
    int y = 0;
    
    CGRect sourceRect = CGRectFromString(self.pullViewSrouceRect);
    y = (sourceRect.origin.y + sourceRect.size.height + sourceRect.origin.y)/2;
    
    CGFloat velocityX = (0.2 *self.pullView.center.x);
    
    if (animation) {
        [UIView animateWithDuration:ABS(velocityX * 0.00002 + 0.2) delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bgView.alpha = 0;
            self.pullView.frame = CGRectFromString(self.pullViewSrouceRect);
            self.pullView.center = CGPointMake(x, y);
        } completion:^(BOOL finished) {
            if ([self.isUnfold boolValue]) {
                if (self.dimissedPullViewCallBack) {
                    self.dimissedPullViewCallBack();
                }
            }
            self.isUnfold = @(NO);
        }];
    }else {
        self.bgView.alpha = 0;
        self.pullView.frame = CGRectFromString(self.pullViewSrouceRect);
        self.pullView.center = CGPointMake(x, y);
        if ([self.isUnfold boolValue]) {
            if (self.dimissedPullViewCallBack) {
                self.dimissedPullViewCallBack();
            }
        }
        self.isUnfold = @(NO);
    }
}

#pragma mark - private property


- (UIView *)bgView {
    return objc_getAssociatedObject(self, kPullBGView);
}
- (void)setBgView:(UIView *)bgView {
    objc_setAssociatedObject(self, kPullBGView, bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)pullView {
    return objc_getAssociatedObject(self, kPullView);
}
- (void)setPullView:(UIView *)pullView {
    objc_setAssociatedObject(self, kPullView, pullView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView*)belowView {
    return objc_getAssociatedObject(self, kBelowView);
}
- (void)setBelowView:(UIView *)belowView {
    return objc_setAssociatedObject(self, kBelowView, belowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UITapGestureRecognizer*)tapGestureRecognizer {
    return objc_getAssociatedObject(self, kTapGestureRecognizer);
}
- (void)setTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    return objc_setAssociatedObject(self, kTapGestureRecognizer, tapGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UITapGestureRecognizer*)panGestureRecognizer {
    return objc_getAssociatedObject(self, kPanGestureRecognizer);
}
- (void)setPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    return objc_setAssociatedObject(self, kPanGestureRecognizer, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString*)pullViewSrouceRect {
    return objc_getAssociatedObject(self, kSourcePullViewCGRect);
}
- (void)setPullViewSrouceRect:(NSString *)pullViewSrouceRect {
    return objc_setAssociatedObject(self, kSourcePullViewCGRect, pullViewSrouceRect, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString*)contentHeight {
    return objc_getAssociatedObject(self, kPullViewContentHeight);
}
- (void)setContentHeight:(NSString *)contentHeight {
    return objc_setAssociatedObject(self, kPullViewContentHeight, contentHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber*)isUnfold {
    return objc_getAssociatedObject(self, kPullViewIsUnfold);
}
- (void)setIsUnfold:(NSNumber *)isUnfold {
    return objc_setAssociatedObject(self, kPullViewIsUnfold, isUnfold, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber*)scrollY {
    return objc_getAssociatedObject(self, kPullViewScrollY);
}
- (void)setScrollY:(NSNumber *)scrollY {
    return objc_setAssociatedObject(self, kPullViewScrollY, scrollY, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber*)isPanDwon {
    return objc_getAssociatedObject(self, kPullViewPanDown);
}
- (void)setIsPanDwon:(NSNumber *)isPanDwon {
    return objc_setAssociatedObject(self, kPullViewPanDown, isPanDwon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)())dimissedPullViewCallBack {
    return objc_getAssociatedObject(self, kDimissedPullViewCallBack);
}
- (void)setDimissedPullViewCallBack:(void (^)())dimissedPullViewCallBack {
    objc_setAssociatedObject(self, kDimissedPullViewCallBack, dimissedPullViewCallBack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)())prensentedPullViewCallBack {
    return objc_getAssociatedObject(self, kPrensentedPullViewCallBack);
}
- (void)setPrensentedPullViewCallBack:(void (^)())prensentedPullViewCallBack {
    objc_setAssociatedObject(self, kPrensentedPullViewCallBack, prensentedPullViewCallBack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - private Methods

#pragma mark action
- (void)onTapBgView {
    [self dismissPullView];
}
- (void)onPanBgView {
    
    UIPanGestureRecognizer* recognizer = self.panGestureRecognizer;
    CGPoint translatedPoint = [recognizer translationInView:self.view];
    
    if ([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateBegan) {
    }
    
    if ([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateChanged) {
        CGFloat targetY = 0;
        if (![self.isUnfold boolValue]) {
            targetY = CGRectFromString(self.pullViewSrouceRect).origin.y + translatedPoint.y;
        }else {
            targetY = CGRectFromString(self.pullViewSrouceRect).origin.y +  [self.contentHeight floatValue] + translatedPoint.y;
            
        }
        if (targetY < CGRectFromString(self.pullViewSrouceRect).origin.y) {
            targetY = MAX(targetY, CGRectFromString(self.pullViewSrouceRect).origin.y);
        }else if(targetY > [self.contentHeight floatValue] + CGRectFromString(self.pullViewSrouceRect).origin.y){
            targetY = MIN(targetY, [self.contentHeight floatValue] + CGRectFromString(self.pullViewSrouceRect).origin.y);
        }
        if ([self.scrollY floatValue] - translatedPoint.y < 0) {    //向下滑动
            self.isPanDwon = @(YES);
        }else if ([self.scrollY floatValue] - translatedPoint.y > 0) {
            self.isPanDwon = @(NO);
        }
        if (![self.isUnfold boolValue]) {
            self.bgView.alpha = 0.3*(targetY-CGRectFromString(self.pullViewSrouceRect).origin.y)/[self.contentHeight floatValue];
        }else {
            self.bgView.alpha = 0.3*(targetY-CGRectFromString(self.pullViewSrouceRect).origin.y)/[self.contentHeight floatValue];
        }
        self.pullView.frame = CGRectMake(self.pullView.x, targetY, self.pullView.width, self.pullView.height);
    }
    
    if (([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateEnded) || ([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateCancelled)) {
        
        CGFloat offset = self.pullView.y - CGRectFromString(self.pullViewSrouceRect).origin.y;
        if ([self.isUnfold boolValue]) {
            offset = self.contentHeight.floatValue - offset;
            if (offset > self.contentHeight.floatValue/3) {
                [self dismiss:YES];
            }else {
                [self show:YES];
            }
        }else {
            if (offset > self.contentHeight.floatValue/3) {
                [self show:YES];
            }else {
                [self dismiss:YES];
            }
        }
        
        //        if ([self.isPanDwon boolValue]) {    //向下滑动
        //            [self show:YES];
        //        }else {
        //            [self dismiss:YES];
        //        }
        
        
    }
    self.scrollY = @(translatedPoint.y);
    
}
@end
