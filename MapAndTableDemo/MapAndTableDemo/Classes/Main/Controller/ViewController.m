//
//  ViewController.m
//  MapAndTableDemo
//
//  Created by cdj on 2018/4/11.
//  Copyright © 2018年 itiis. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "XDSTableView.h"
#import "XDSTableViewCell.h"
#import "XDSScrollView.h"
#import "XDSHeaderView.h"
#import "UIView+Frame.h"
#import "XDSTaxiView.h"

#define cellH 150                       //cell高度
#define cellCount 6                     //cell高度
#define headerH 100                     //headerView的高度

/* 屏幕的尺寸 */
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

static NSString *cellID = @"cell";

@interface ViewController ()<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) XDSHeaderView *headerView;

@property (nonatomic, strong)  UIButton *selectedBtn;//选中的车辆按钮（快车还是出租车）
@property (nonatomic, weak)  UIView *line;//按钮下划线

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
    
    [self setupHeaderView];
    
    [self setupScrollView];
    [self setupTableView];
    [self setupTaixView];
    
}

#pragma mark - viewDidLayoutSubviews：调整从xib加载的headerview的尺寸
- (void)viewDidLayoutSubviews{

    self.headerView.frame = CGRectMake(0, 0, ScreenW, headerH);

}


#pragma mark - 地图视图
- (void)setupMapView {
    // 地图部分界面
    MKMapView *mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    mapView.delegate = self;
    mapView.mapType = MKMapTypeStandard;
    self.mapView = mapView;
    
    [self.view addSubview:mapView];

}


#pragma mark - ScrollView视图
- (void)setupScrollView{
    
    XDSScrollView *scrollView = [[XDSScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.contentSize = CGSizeMake(0, 0);
    scrollView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    [self.scrollView addSubview:self.tableView];

}

#pragma mark - tableView视图
- (void)setupTableView{
    
    //20为状态栏高度；tableview设置的大小要和view的大小一致
    XDSTableView *tableView = [[XDSTableView alloc] initWithFrame:CGRectMake(0, 20, ScreenW, ScreenH) style:UITableViewStyleGrouped];
    
    //tableview不延时
    self.tableView.delaysContentTouches = NO;
    for (UIView *subView in self.tableView.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subView).delaysContentTouches = NO;
        }
    }
    
    //tableview下移
    tableView.contentInset = UIEdgeInsetsMake(ScreenH-cellH-20, 0, 0, 0);
    
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.001)];//去掉头部空白
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.sectionHeaderHeight = 0.0;//消除底部空白
    tableView.sectionFooterHeight = 0.0;//消除底部空白
    self.tableView = tableView;
    [self.scrollView addSubview:tableView];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"XDSTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    //添加KVO监听
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark - headerView顶部视图
- (void)setupHeaderView{

    XDSHeaderView *headerView = [XDSHeaderView getHeaderFromXib];

    [headerView.truckBtn setTitleColor:[UIColor colorWithRed:255.0/255 green:160.0/255.0 blue:122/255.0 alpha:1] forState:UIControlStateNormal];

    self.selectedBtn = headerView.truckBtn;
    self.selectedBtn.enabled = NO;
    
    headerView.truckBtn.tag = 0;
    [headerView.truckBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    headerView.taxiBtn.tag = 1;
    [headerView.taxiBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置按钮的下划线
    CGFloat fontSize = [headerView.truckBtn.currentTitle sizeWithAttributes:@{NSFontAttributeName:headerView.truckBtn.titleLabel.font}].width;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-3, fontSize, 3)];
    line.backgroundColor = [UIColor colorWithRed:255.0/255 green:160.0/255.0 blue:122/255.0 alpha:1];
    
//    line.xds_centerX = headerView.truckBtn.xds_centerX;
    line.xds_centerX = ScreenW *0.5 *0.5;//注意，这里因为layoutSubview比viewDidLoad晚，所以改变了headerview的Frame后，按钮的位置会有变化，所以用了ScreenW *0.5 *0.5
    
    [headerView addSubview:line];
    
    [headerView.messageBtn addTarget:self action:@selector(messageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.mineBtn addTarget:self action:@selector(mineBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:headerView];
    
    self.line = line;
    self.headerView = headerView;
    
}

#pragma mark - 出租车视图
- (void)setupTaixView{
    
    XDSTaxiView *taxiView = [XDSTaxiView getTaxiView];
    taxiView.xds_width = ScreenW - 20;
    taxiView.xds_x = ScreenW + 10;
    taxiView.xds_y = ScreenH - taxiView.xds_height - 10;
    
    [self.scrollView addSubview:taxiView];
}


#pragma mark - 快车、出租车点击
- (void)btnTap:(UIButton *)sender{
    
    self.selectedBtn.enabled = YES;
    [sender setTitleColor:[UIColor colorWithRed:255.0/255 green:160.0/255.0 blue:122/255.0 alpha:1] forState:UIControlStateNormal];
    [self.selectedBtn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] forState:UIControlStateNormal];
    self.selectedBtn = sender;
    self.selectedBtn.enabled = NO;
    
    CGFloat fontwidth = [sender.currentTitle sizeWithAttributes:@{NSFontAttributeName:sender.titleLabel.font}].width;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.line.xds_width = fontwidth;
        self.line.xds_centerX = sender.xds_centerX;
    }];
    
    [self.scrollView setContentOffset:CGPointMake(sender.tag*ScreenW, 0) animated:YES];
}

- (void)messageBtn:(UIButton *)sender{
    
    NSLog(@"message按钮");
    
}
- (void)mineBtn:(UIButton *)sender{
    
    NSLog(@"mine按钮");
    
}


#pragma mark - KVO 监听headerView（收缩头部视图）
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGPoint tableContenOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        if (tableContenOffset.y > -ScreenH*0.5) {
            
            if (self.headerView.xds_y == 0) {
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{ //0.15秒内做完改变frame的动画，动画效果匀速
                    self.headerView.xds_y = -headerH;
                } completion:nil];
                
            }
            
        }
        if (tableContenOffset.y < -ScreenH*0.5) {
            
            if (self.headerView.xds_y == -headerH) {
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{ //0.15秒内做完改变frame的动画，动画效果匀速
                    
                    self.headerView.xds_y = 0;;
                } completion:nil];
                
            }
        }
    }
    
}


#pragma mark - 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell");
    
    //点击后消除选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellH;
}

#pragma mark - cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellCount;
}

#pragma mark - 每个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

    cell.lable.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}



@end
