//
//  ZXCheckParentViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCheckParentViewController.h"
#import "ZXCheckCell.h"
#import "ZXRequestParent+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXCheckParentViewController ()

@end

@implementation ZXCheckParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"成员审核";
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXRequestParent getRequestParentListWithCid:appStateInfo.cid tid:appStateInfo.tid state:0 page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        
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

- (void)check
{
    [self performSegueWithIdentifier:@"check" sender:nil];
}

#pragma -mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXRequestParent *parent = self.dataArray[indexPath.row];
    [cell.titleLabel setText:[NSString stringWithFormat:@"%@的%@",parent.name_student,parent.relation]];
    [cell.contentLabel setText:[NSString stringWithFormat:@"%@申请加入%@",parent.name_parent,parent.cname]];
    cell.rejectButton.tag = indexPath.row;
    cell.agreeButton.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)agreeAction:(UIButton *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"提交中" toView:self.view];
    ZXRequestParent *parent = self.dataArray[sender.tag];
    [ZXRequestParent checkParentWithRpid:parent.rpid state:1 cid:parent.cid block:^(BaseModel *baseModel ,NSError *error) {
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
    ZXRequestParent *parent = self.dataArray[sender.tag];
    [ZXRequestParent checkParentWithRpid:parent.rpid state:2 cid:parent.cid block:^(BaseModel *baseModel ,NSError *error) {
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
