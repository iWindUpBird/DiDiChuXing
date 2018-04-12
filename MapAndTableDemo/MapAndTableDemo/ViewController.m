//
//  ViewController.m
//  MapAndTableDemo
//
//  Created by cdj on 2018/4/11.
//  Copyright © 2018年 itiis. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#define cellH 150                       //cell高度
#define cellCount 6                     //cell高度
#import "XDSTableView.h"

/* 屏幕的尺寸 */
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    // 地图部分界面
    MKMapView *mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    mapView.delegate = self;
    mapView.mapType = MKMapTypeStandard;
    self.mapView = mapView;
    [self.view addSubview:mapView];
    
    
    // 表格部分

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
    tableView.contentInset = UIEdgeInsetsMake(500, 0, 0, 0);
    
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.001)];//去掉头部空白
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.sectionHeaderHeight = 0.0;//消除底部空白
    tableView.sectionFooterHeight = 0.0;//消除底部空白
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
}



#pragma mark - 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell");
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
    
    UITableViewCell *cell = [UITableViewCell new];
    //cell颜色（红蓝循环）
    if(indexPath.row%2==0){
        cell.backgroundColor = [UIColor blueColor];
    }else{
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}



@end
