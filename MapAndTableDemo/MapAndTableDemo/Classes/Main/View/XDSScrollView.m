//
//  XDSScrollView.m
//  HCDriver
//
//  Created by cdj on 2018/6/13.
//  Copyright © 2018年 UEH. All rights reserved.
//

#import "XDSScrollView.h"
#import "XDSTableView.h"
#import "XDSTaxiView.h"
#import "XDSTableView.h"

@implementation XDSScrollView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    //注意，这里是判断现在是在ScrollView的哪一个部分上
    int count = self.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = self.subviews[count];
    
    CGPoint viewPoint = [self convertPoint:point toView:view];
    
    if (viewPoint.y<0) {
        return nil;
    }
    
    return [super hitTest:point withEvent:event];
    
}

@end
