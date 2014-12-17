//
//  ZXProvinceViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXProvinceViewController.h"
#import "ZXCity+ZXclient.h"
#import "ZXCityViewController.h"
#import "ZXSearchSchoolViewController.h"

@interface ZXProvinceViewController ()

@end

@implementation ZXProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择地区";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)addFooter
{
    
}

- (void)loadData
{
    NSArray *array = [ZXCity where:@"subCid == 0"];
    if (array.count > 0) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Cities" ofType:@"plist"];
            NSArray *arr = [[NSArray alloc] initWithContentsOfFile:path];
            for (NSDictionary *dic in arr) {
                ZXCity *city = [ZXCity insertWithAttribute:@"cid" value:[dic objectForKey:@"cid"]];
                [city update:dic];
                [city save];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                NSArray *array = [ZXCity where:@"subCid == 0"];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView headerEndRefreshing];
            });
        });
        
    }
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
    ZXCity *city = [self.dataArray objectAtIndex:indexPath.row];
    if ([city.name hasSuffix:@"市"]) {
        ZXSearchSchoolViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZXSearchSchoolViewController"];
        vc.cityid = [NSString stringWithFormat:@"%i",city.cid];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZXCityViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZXCityViewController"];
        vc.cityid = [NSString stringWithFormat:@"%i",city.cid];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
