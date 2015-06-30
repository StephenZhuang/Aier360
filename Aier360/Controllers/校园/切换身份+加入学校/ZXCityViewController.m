//
//  ZXCityViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCityViewController.h"
#import "ZXCity+ZXclient.h"

@interface ZXCityViewController ()

@end

@implementation ZXCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择地区";
}

- (void)addFooter
{
    
}

- (void)loadData
{
    NSArray *array = [ZXCity where:@"subCid == %@",_cityid];

    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    [self.tableView reloadData];
    [self.tableView headerEndRefreshing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXCity *city = [self.dataArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:city.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
