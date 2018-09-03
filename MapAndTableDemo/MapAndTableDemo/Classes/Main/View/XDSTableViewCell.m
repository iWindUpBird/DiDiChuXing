//
//  XDSTableViewCell.m
//  MapAndTableDemo
//
//  Created by cdj on 2018/9/2.
//  Copyright © 2018年 itiis. All rights reserved.
//

#import "XDSTableViewCell.h"

@implementation XDSTableViewCell

- (void)setFrame:(CGRect)frame{

    frame.size.height -= 3;
    //必不可少。真正给cell的frame赋值
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
