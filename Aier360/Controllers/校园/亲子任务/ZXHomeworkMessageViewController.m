//
//  ZXHomeworkMessageViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomeworkMessageViewController.h"
#import "ZXHomeworkMessage+ZXclient.h"
#import "ZXCardHistoryCell.h"

@interface ZXHomeworkMessageViewController ()

@end

@implementation ZXHomeworkMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"亲子任务消息";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCardHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXHomeworkMessage *message = self.dataArray[indexPath.row];
    [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:message.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.AMLabel setText:message.nickname];
    if (message.type == 1) {
        [cell.PMLabel setText:@"评论了我的动态"];
    } else {
        [cell.PMLabel setText:@"回复了我的动态"];
    }
    return cell;
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXHomeworkMessage getHomeworkMessageListWithUid:GLOBAL_UID sid:appStateInfo.sid block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
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
