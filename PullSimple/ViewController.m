//
//  ViewController.m
//  PullSimple
//
//  Created by 姚飞剑 on 16/9/21.
//  Copyright © 2016年 姚飞剑. All rights reserved.
//

#import "ViewController.h"
#import "UIPullView.h"
#import "UIViewController+PullView.h"

@interface ViewController ()<UIPullViewDelegate>
@property (nonatomic, strong) UIPullView* pullView;
@property (nonatomic, strong) UILabel *headLable;
@end

@implementation ViewController

#define kHeightHeadLabel (100)
#define kTopHeadLabel (0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.headLable];
    
    self.pullView.frame = CGRectMake(0,kTopHeadLabel + kHeightHeadLabel - [UIPullView heightForContentView], self.view.frame.size.width, [UIPullView heightForView]);
    [self insertPullView:self.pullView belowView:self.headLable contentViewHeight:[UIPullView heightForContentView] presentCallBack:^{
        NSLog(@"present");
        [UIView animateWithDuration:0.5 animations:^{
            self.pullView.arrowBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } dimissedCallBack:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.pullView.arrowBtn.imageView.transform = CGAffineTransformMakeRotation(0);
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.headLable.frame = CGRectMake(0, kTopHeadLabel, self.view.frame.size.width, kHeightHeadLabel);
}

#pragma mark - getter
- (UILabel*)headLable {
    if (!_headLable) {
        _headLable = [[UILabel alloc] init];
        _headLable.backgroundColor = [UIColor whiteColor];
        
        _headLable.text = @"SimpleExample/ViewController/headLabel";
        _headLable.numberOfLines = 0;
        _headLable.textAlignment = NSTextAlignmentCenter;
    }
    return _headLable;
}
- (UIPullView*)pullView {
    if (!_pullView) {
        _pullView = [[UIPullView alloc] init];
        _pullView.delegate = self;
    }
    return _pullView;
}

#pragma mark - UIPullViewDelegate
- (void)viewDidFold:(UIPullView *)view {
    [self dismissPullView];
}
- (void)viewDidUnfold:(UIPullView *)view {
    [self presentPullView];
}
@end
