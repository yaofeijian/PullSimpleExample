//
//  UIPullView.m
//  BusinessTrips
//
//  Created by 姚飞剑 on 16/9/2.
//  Copyright © 2016年 mamahome. All rights reserved.
//

#import "UIPullView.h"

@interface UIPullView()


@property (nonatomic, strong) UILabel *contentLabel;


@property (nonatomic, strong) UIImageView *pullImageView;


@property (nonatomic) BOOL isUnfold;    //是否已经展开，默认NO，没有展开
@end

@implementation UIPullView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.contentLabel];
        [self addSubview:self.pullImageView];
        [self addSubview:self.arrowBtn];
        
    }
    return self;
}
#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentLabel.frame = CGRectMake(0, 0, self.frame.size.width, 100);
    self.pullImageView.frame = CGRectMake(0, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height, self.frame.size.width, [UIPullView heightForBottomPullView]);
    UIImage* btnImg = [self.arrowBtn imageForState:UIControlStateNormal];
    self.arrowBtn.frame = CGRectMake((self.frame.size.width - btnImg.size.width)/2, self.pullImageView.frame.origin.y + 25, btnImg.size.width, btnImg.size.height);
}

#pragma mark - 懒加载
- (UILabel*)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor colorWithRed:0xff/255. green:0xfb/255. blue:0xf4/255. alpha:1.0];
        _contentLabel.text = @"PullSimple/ViewController/UIPullView/contentLabel";
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}
- (UIImageView*)pullImageView {
    if (!_pullImageView) {
        _pullImageView = [[UIImageView alloc] init];
        _pullImageView.image = [UIImage imageNamed:@"sawtooth"];
    }
    return _pullImageView;
}
- (UIButton*)arrowBtn {
    if (!_arrowBtn) {
        _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowBtn addTarget:self action:@selector(onClickArrowBtn) forControlEvents:UIControlEventTouchUpInside];
        [_arrowBtn setImage:[UIImage imageNamed:@"search_btn_down"] forState:UIControlStateNormal];
    }
    return _arrowBtn;
}

#pragma mark event
- (void)onClickArrowBtn {
    if (self.isUnfold) {
        if ([self.delegate respondsToSelector:@selector(viewDidFold:)]) {
            [self.delegate viewDidFold:self];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(viewDidUnfold:)]) {
            [self.delegate viewDidUnfold:self];
        }
    }
    self.isUnfold = !self.isUnfold;
}
#pragma mark - 类方法
+ (CGFloat)heightForBottomPullView {
    return [UIImage imageNamed:@"sawtooth"].size.height;
}
+ (CGFloat)heightForContentView {
    return 100;
}
+ (CGFloat)heightForView {
    return [UIPullView heightForBottomPullView] + [UIPullView heightForContentView];
}
@end
