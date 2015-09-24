//
//  ZXSelectLocationViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSelectLocationViewController.h"

@implementation ZXSelectLocationViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dynamic" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSelectLocationViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"在哪?";
    
//    发起反向地理编码检索
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_lat, _lng};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
}

- (void)addHeader{}
- (void)addFooter{}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        [self.dataArray addObjectsFromArray:result.poiList];
        [self.tableView reloadData];
    }
    else {
      NSLog(@"抱歉，未找到结果");
    }
}

//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _searcher.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _searcher.delegate = self;
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BMKPoiInfo *poiInfo = self.dataArray[indexPath.row];
    [cell.textLabel setText:poiInfo.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *poiInfo = self.dataArray[indexPath.row];
    !_addressBlock?:_addressBlock(poiInfo.name);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
