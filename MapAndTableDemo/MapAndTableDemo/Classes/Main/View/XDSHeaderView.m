//
//  XDSHeaderView.m
//  HCDriver
//
//  Created by cdj on 2018/4/14.
//  Copyright © 2018年 UEH. All rights reserved.
//

#import "XDSHeaderView.h"

@implementation XDSHeaderView

+(instancetype)getHeaderFromXib{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XDSHeaderView class]) owner:self options:nil].firstObject;
    
}

@end
