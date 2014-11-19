//
//  ZXTeacherCheckViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherCheckViewController.h"
#import "ZXRequestTeacher+ZXclient.h"
#import "ZXCheckCell.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXTeacherCheckViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"成员审核";
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXRequestTeacher getRequestTeacherListWithSid:appStateInfo.sid uid:[ZXUtils sharedInstance].user.uid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        
        if (array) {
            if (page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < pageCount) {
                hasMore = NO;
                [self.tableView setFooterHidden:YES];
            }
        } else {
            hasMore = NO;
            [self.tableView setFooterHidden:YES];
        }
        if (page == 1) {
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXRequestTeacher *teacher = [self.dataArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:teacher.tname];
    [cell.contentLabel setText:[NSString stringWithFormat:@"%@%@",teacher.cname,teacher.gname]];
    cell.agreeButton.tag = indexPath.row;
    cell.rejectButton.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)agreeAction:(UIButton *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"提交中" toView:self.view];
    ZXRequestTeacher *teacher = [self.dataArray objectAtIndex:sender.tag];
    [ZXRequestTeacher checkTeacherWithRtid:teacher.rtid state:1 tid:teacher.tid block:^(BaseModel *baseModel ,NSError *error) {
        if (baseModel) {
            if (baseModel.s) {
                [hud turnToSuccess:@""];
                [self.dataArray removeObjectAtIndex:sender.tag];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [hud turnToError:baseModel.error_info];
            }
        }
    }];
}

- (IBAction)rejectAction:(UIButton *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"提交中" toView:self.view];
    ZXRequestTeacher *teacher = [self.dataArray objectAtIndex:sender.tag];
    [ZXRequestTeacher checkTeacherWithRtid:teacher.rtid state:2 tid:teacher.tid block:^(BaseModel *baseModel ,NSError *error) {
        if (baseModel) {
            if (baseModel.s) {
                [hud turnToSuccess:@""];
                [self.dataArray removeObjectAtIndex:sender.tag];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [hud turnToError:baseModel.error_info];
            }
        }
    }];
}
@end
