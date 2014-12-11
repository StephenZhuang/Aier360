//
//  ZXChangeIdentyViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXChangeIdentyViewController.h"
#import "ZXMenuCell.h"
#import "BaseModel+ZXJoinSchool.h"

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
    if ([ZXUtils sharedInstance].account.appStateInfolist.count > 0) {
        ZXAppStateInfo *currentState = [[ZXUtils sharedInstance].account.appStateInfolist firstObject];
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
    ZXAppStateInfo *appStateInfo = [self.stateArray objectAtIndex:indexPath.row];
    [ZXBaseModel changeIdentyWithSchoolId:appStateInfo.sid appstatus:appStateInfo.appState cid:appStateInfo.cid uid:[ZXUtils sharedInstance].user.uid block:^(ZXBaseModel *baseModel, NSError *error){
        if (!error) {
            [ZXUtils sharedInstance].identity = appStateInfo.appState.integerValue;
            [ZXUtils sharedInstance].currentAppStateInfo = appStateInfo;
            [ZXUtils sharedInstance].currentSchool = _school;
            [self saveIdentity];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSuccess" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];            
        }
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)saveIdentity
{
    NSMutableSet *set  = [NSMutableSet set];
    for (ZXAppStateInfo *appStateInfo in self.stateArray) {
        [set addObject:appStateInfo.appState];
    }
    [ZXUtils sharedInstance].infoSet = set;

}
@end
