//
//  UIView+Frame.m
//  HCDriver
//
//  Created by cdj on 2018/4/14.
//  Copyright © 2018年 UEH. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

-(CGFloat)xds_x{
    
    return self.frame.origin.x;
}

-(CGFloat)xds_y{
    
    return self.frame.origin.y;
    
}

-(CGFloat)xds_width{
    
    return self.frame.size.width;
}

-(CGFloat)xds_height{
    
    return self.frame.size.height;
}
-(CGFloat)xds_centerX{
    
    return self.center.x;
}
-(CGFloat)xds_centerY{
    
    return self.center.y;
}
-(void)setXds_x:(CGFloat)xds_x{
    
    CGRect frame = self.frame;
    frame.origin.x = xds_x;
    self.frame = frame;
}
-(void)setXds_y:(CGFloat)xds_y{
    
    CGRect frame = self.frame;
    frame.origin.y = xds_y;
    self.frame = frame;
}
-(void)setXds_width:(CGFloat)xds_width{
    
    CGRect frame = self.frame;
    frame.size.width = xds_width;
    self.frame = frame;
}
-(void)setXds_height:(CGFloat)xds_height{
    
    CGRect frame = self.frame;
    frame.size.height = xds_height;
    self.frame = frame;
}
- (void)setXds_centerX:(CGFloat)xds_centerX{
    
    CGPoint center = self.center;
    center.x = xds_centerX;
    self.center = center;
}
- (void)setXds_centerY:(CGFloat)xds_centerY{
    
    CGPoint center = self.center;
    center.y = xds_centerY;
    self.center = center;
}
@end











