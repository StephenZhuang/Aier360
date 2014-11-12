//
//  ZXChangeIdentyViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXChangeIdentyViewController.h"
#import "ZXMenuCell.h"

@implementation ZXChangeIdentyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择身份";
}

- (void)addHeader{}
- (void)loadData{}
- (void)addFooter{}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXAppStateInfo *appStateInfo = [self.stateArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:appStateInfo.listStr];
    if ([ZXUtils sharedInstance].currentSchool) {
        ZXSchool *currentState = [ZXUtils sharedInstance].currentSchool;
        if (appStateInfo.appState.integerValue == [ZXUtils sharedInstance].identity && appStateInfo.sid == currentState.sid && appStateInfo.cid == currentState.cid) {
            [cell.itemImage setHidden:NO];
        } else {
            [cell.itemImage setHidden:YES];
        }
    } else {
        [cell.itemImage setHidden:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
