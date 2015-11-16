//
//  ZXMessageRecordViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/16.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMessageRecordViewController.h"
#import "ZXMessageRecord.h"
#import "ZXMessageRecordHeader.h"
#import "ZXMessageRecordTableViewCell.h"

@interface ZXMessageRecordViewController ()

@end

@implementation ZXMessageRecordViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MessageAccount" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXMessageRecordViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"短信记录";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXMessageRecordHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ZXMessageRecordHeader"];
}

- (void)addFooter{}

- (void)loadData
{
    [ZXMessageRecord getMessageRecordWithSid:[ZXUtils sharedInstance].currentSchool.sid block:^(NSArray *array, NSError *error) {
        [self configureArrayWithNoFooter:array];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZXMonthMessageRecord *mmr = [self.dataArray objectAtIndex:section];
    return mmr.mrList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZXMessageRecordHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZXMessageRecordHeader"];
    ZXMonthMessageRecord *mmr = [self.dataArray objectAtIndex:section];
    [header.monthLabel setText:mmr.month];
    [header.messageLabel setText:[NSString stringWithFormat:@"获取短信%@条 使用%@条",@(mmr.mescount),@(mmr.usecount)]];
    header.contentView.backgroundColor = [UIColor colorWithRed:247 green:245 blue:237];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMessageRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMessageRecordTableViewCell"];
    ZXMonthMessageRecord *mmr = [self.dataArray objectAtIndex:indexPath.section];
    ZXMessageRecord *messageRecord = mmr.mrList[indexPath.row];
    [cell configureUIWithMessageRecord:messageRecord];
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
