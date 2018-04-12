//
//  XDSTableView.m
//  MapTableViewDemo
//
//  Created by cdj on 2018/4/11.
//  Copyright © 2018年 Felix. All rights reserved.
//

#import "XDSTableView.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@implementation XDSTableView



-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    NSLog(@"point=%@",NSStringFromCGPoint(point));
    
    NSLog(@"y=%f",self.contentOffset.y);
    
    if (point.y<0) {
        return nil;
    }

    return  [super hitTest:point withEvent:event];
}

@end
