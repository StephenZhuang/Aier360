//
//  ZXDayViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDayHistoryViewController.h"
#import "ZXCardHistoryCell.h"

@interface ZXDayHistoryViewController ()

@end

@implementation ZXDayHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_identity == ZXIdentityTeacher) {
        self.title = [NSString stringWithFormat:@"%@的打卡",_history.name];
    } else if (_identity == ZXIdentitySchoolMaster) {
        self.title = _history.day;
    }
}

- (void)addFooter{}

- (void)loadData
{
    [ZXCardHistory getDayDetailCardHistoryWithTid:_history.tid yearAndMonthStr:_history.day block:^(NSArray *array, NSError *error) {
        
        [self.dataArray removeAllObjects];
        if (array) {
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }
        [self.tableView headerEndRefreshing];
        if (self.dataArray.count > 0) {
            [_tipView setHidden:YES];
        } else {
            [_tipView setHidden:NO];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCardHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXCardHistory *history = self.dataArray[indexPath.row];
    [cell.titleLabel setText:[NSString stringWithFormat:@"打卡记录%i",indexPath.row+1]];
    [cell.AMLabel setText:history.time];
    if (history.type == 1) {
        [cell.PMLabel setText:@"进"];
        [cell.PMLabel setBackgroundColor:[UIColor colorWithRed:32 green:196 blue:138]];
    } else {
        [cell.PMLabel setText:@"出"];
        [cell.PMLabel setBackgroundColor:[UIColor colorWithRed:250 green:107 blue:20]];
    }
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
