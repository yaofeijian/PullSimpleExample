# PullSimpleExample
模仿Agoda订单详情实现，拖拽按钮抽出订单详情功能

示例代码：
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
