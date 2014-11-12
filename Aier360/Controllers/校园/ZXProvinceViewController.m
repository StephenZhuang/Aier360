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

@interface ZXProvinceViewController ()

@end

@implementation ZXProvinceViewController

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
    NSArray *array = [ZXCity where:@"subCid == 0"];
    if (array.count > 0) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } else {
        [ZXCity getCities:@"-1" block:^(NSArray *cityArray ,NSError *error) {
            if (cityArray && cityArray.count > 0) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:cityArray];
                [self.tableView reloadData];
            }
            [self.tableView headerEndRefreshing];
        }];
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
