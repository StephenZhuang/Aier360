//
//  ZXUserMailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUserMailViewController.h"
#import "ZXSchoolMasterEmail+ZXclient.h"
#import "ZXMailCell.h"
#import "ZXMailCommentCell.h"
#import "ZXAddMailViewController.h"

@implementation ZXUserMailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster) {
        self.title = @"更多留言";
    } else {
        _uid = GLOBAL_UID;
        self.title = @"校长信箱";
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_release"] style:UIBarButtonItemStyleBordered target:self action:@selector(addMail)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)addMail
{
    [self performSegueWithIdentifier:@"add" sender:nil];
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXSchoolMasterEmail getEmailDetailListWithSid:appStateInfo.sid uid:_uid block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (void)configureArray:(NSArray *)array
{
    [self.dataArray removeAllObjects];
    if (array) {
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    [self.tableView headerEndRefreshing];
}

- (void)addFooter{}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZXSchoolMasterEmail *email = self.dataArray[section];
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster) {
        return email.smeList.count + 2;
    } else {
        return email.smeList.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXSchoolMasterEmail *email = self.dataArray[indexPath.section];
    if (indexPath.row == 0) {
        return [ZXMailCell heightByText:email.content];
    } else if (indexPath.row > email.smeList.count) {
        return 44;
    } else {
        ZXSchoolMasterEmailDetail *detail = email.smeList[indexPath.row - 1];
        NSString *emojiText = [NSString stringWithFormat:@"%@:%@",[ZXUtils sharedInstance].currentSchool.name,detail.content];
        return [ZXMailCommentCell heightByText:emojiText];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXSchoolMasterEmail *email = self.dataArray[indexPath.section];
    if (indexPath.row == 0) {
        ZXMailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMailCell"];
        [cell configureUIWithSchoolMasterEmail:email indexPath:indexPath];
        return cell;
    } else if (indexPath.row > email.smeList.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell.textLabel setText:@"回复"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        return cell;
    } else {
        ZXMailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMailCommentCell"];
        ZXSchoolMasterEmailDetail *detail = email.smeList[indexPath.row - 1];
        [cell configureUIWithSchoolMasterEmail:detail];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)deleteAction:(UIButton *)sender
{
    ZXSchoolMasterEmail *email = self.dataArray[sender.tag];
    [self.dataArray removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
    [ZXSchoolMasterEmail deleteEmailWithSmeid:email.smeid block:^(BOOL success, NSString *errorInfo) {
        if (success) {
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"comment"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ZXSchoolMasterEmail *email = self.dataArray[indexPath.section];
        ZXAddMailViewController *vc = [segue destinationViewController];
        vc.email = email;
        vc.commentSuccess = ^(void) {
            [self.tableView headerBeginRefreshing];
        };
    } else if ([segue.identifier isEqualToString:@"add"]) {
        ZXAddMailViewController *vc = [segue destinationViewController];
        vc.commentSuccess = ^(void) {
            [self.tableView headerBeginRefreshing];
        };
    }
}
@end
