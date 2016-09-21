//
//  UIView+Extension.m
//  RSChatView
//
//  Created by redstar on 15/4/24.
//  Copyright (c) 2015年 redstar. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setMinX:(CGFloat)minX{
    self.minX = self.x;
}

- (CGFloat)minX{
    return CGRectGetMinX(self.frame);
}

- (void)setMinY:(CGFloat)minY{
    self.maxY = self.y;
}

- (CGFloat)minY{
    return CGRectGetMinY(self.frame);
}

- (void)setMaxX:(CGFloat)maxX{
    self.maxX = self.x +self.width;
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY{
    self.maxY = self.y + self.height;
}

- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

-(void)setMaskRadius:(float)radius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

@end
