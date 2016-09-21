# PullSimpleExample
模仿Agoda订单详情实现，拖拽按钮抽出订单详情功能

#####效果动态图展示：
![image](https://raw.githubusercontent.com/yaofeijian/PullSimpleExample/master/gif/1.gif)

#####说明图：
![image](https://raw.githubusercontent.com/yaofeijian/PullSimpleExample/master/gif/2.png)

#####原图1：
![image](https://raw.githubusercontent.com/yaofeijian/PullSimpleExample/master/gif/3.png)


#####原图2：
![image](https://raw.githubusercontent.com/yaofeijian/PullSimpleExample/master/gif/4.png)



###使用方法
1.引入头文件#import "UIViewController+PullView.h"

2.实现需要抽拽的视图pullView

3.设置抽拽视图View的frame以及中间内容部分的高度

    [self insertPullView:self.pullView belowView:self.headLable contentViewHeight:[UIPullView heightForContentView] presentCallBack:^{
            NSLog(@"present");
        } dimissedCallBack:^{
    }];
    
4.完成调用
