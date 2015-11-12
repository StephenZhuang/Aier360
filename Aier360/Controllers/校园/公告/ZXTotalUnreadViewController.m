//
//  ZXTotalUnreadViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/11.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTotalUnreadViewController.h"
#import "ZXTimeHelper.h"
#import "ZXClass+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXMessageEditViewController.h"

@implementation ZXTotalUnreadViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXTotalUnreadViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"未阅列表";
    
    NSString *time = [ZXTimeHelper DayHourMinSinceNow:self.announcement.ctime
                      ];
    
    [self.unreadLabel setText:[NSString stringWithFormat:@"公告已经发布了%@，还有%@位成员未阅读，发个短信通知一下吧？",time,@(self.announcement.shouldReaderNumber - self.announcement.reading)]];
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [ZXClass getUnreadClassListWithSid:self.announcement.sid mid:self.announcement.mid type:self.announcement.type block:^(NSArray *array, NSInteger unReaderTeacherNum, NSError *error) {
        [hud hide:YES];
        [self.dataArray addObjectsFromArray:array];
        self.teacherNum = unReaderTeacherNum;
        [self.tablView reloadData];
    }];
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataArray.count > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    } else {
        return @"家长";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = [UIColor colorWithRed:247 green:245 blue:237];
    [headerView.textLabel setFont:[UIFont systemFontOfSize:13]];
    [headerView.textLabel setTextColor:[UIColor colorWithRed:179/255.0 green:176/255.0 blue:168/255.0 alpha:1.0]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        [cell.textLabel setText:@"教师"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",@(self.teacherNum)]];
    } else {
        ZXClass *zxclass = [self.dataArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:zxclass.cname];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",@(zxclass.num_parent)]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)sendMessageAction:(id)sender
{
    
    ZXMessageEditViewController *vc = [ZXMessageEditViewController viewControllerFromStoryboard];
    ZXAnnounceMessage *am = [[ZXAnnounceMessage alloc] init];
    am.sid = self.announcement.sid;
    am.mid = self.announcement.mid;
    am.content = self.announcement.message;
    am.needSendPeopleNum = self.announcement.shouldReaderNumber - self.announcement.reading;
    am.type = ZXSendMessageTypeUnread;
    vc.announceMessage = am;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setters and getters
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
