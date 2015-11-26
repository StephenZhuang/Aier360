//
//  ZXMessageRecordDetailViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/25.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMessageRecordDetailViewController.h"
#import "ZXOriderContentTableViewCell.h"

@implementation ZXMessageRecordDetailViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MessageAccount" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXMessageRecordDetailViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单详情";
    [self.tableView setExtrueLineHidden];
    [self configureHeader];
    [self loadData];
}

- (void)loadData
{
    [self.messageRecord getMessageDetailWithBlock:^(ZXMessageRecord *messageRecord, NSError *error) {
        self.messageRecord = messageRecord;
        [self.tableView reloadData];
        [self configureHeader];
    }];
}

- (void)configureHeader
{
    [self.moneyLabel setText:[NSString stringWithFormat:@"%.2f",self.messageRecord.money]];
    [self.numLabel setText:[NSString stringWithFormat:@"购买短信数量：%@条",@(self.messageRecord.num)]];
    [self.stateLabel setText:self.messageRecord.payState];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"详细信息";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:HEADER_TITLE_COLOR];
    [header.textLabel setFont:[UIFont systemFontOfSize:13]];
    header.contentView.backgroundColor = HEADER_BG_COLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXOriderContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXOriderContentTableViewCell"];
    NSString *title = @"";
    NSString *content = @"";
    if (indexPath.row == 0) {
        title = @"购买人";
        content = self.messageRecord.nickname;
    } else if (indexPath.row == 1) {
        title = @"短信单价";
        content = [NSString stringWithFormat:@"%@",self.messageRecord.price];
    } else if (indexPath.row == 2) {
        title = @"支付方式";
        content = self.messageRecord.pay;
    } else {
        title = @"订单日期";
        content = self.messageRecord.cdateStr;
    }
    [cell.titleLabel setText:title];
    [cell.contentLabel setText:content];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
