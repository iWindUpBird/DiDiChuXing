//
//  XDSHeaderView.h
//  HCDriver
//
//  Created by cdj on 2018/4/14.
//  Copyright © 2018年 UEH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDSHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *mineBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *truckBtn;
@property (weak, nonatomic) IBOutlet UIButton *taxiBtn;

+(instancetype)getHeaderFromXib;
@end
