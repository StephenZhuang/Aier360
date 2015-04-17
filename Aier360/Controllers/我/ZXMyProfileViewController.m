//
//  ZXMyProfileViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/14.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMyProfileViewController.h"
#import "ZXMenuCell.h"
#import "MagicalMacro.h"
#import "ZXUser+ZXclient.h"
#import "ZXProfileDynamicCell.h"
#import "ZXTimeHelper.h"

@implementation ZXMyProfileViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dynamicCount = 0;
    self.headButton.layer.borderWidth = 2;
    self.headButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headButton.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.headButton.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.headButton.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    self.headButton.layer.shadowRadius = 2;//阴影半径，默认3
    [self updateUI];
    [self loadData];
}

- (void)loadData
{
    [ZXUser getUserInfoAndBabyListWithUid:GLOBAL_UID fuid:GLOBAL_UID block:^(ZXUser *user, NSArray *array, BOOL isFriend, ZXDynamic *dynamic, NSInteger dynamicCount, NSError *error) {
        if (!user) {
            _user = user;
        }
        _dynamic = dynamic;
        _dynamicCount = dynamicCount;
        [self updateUI];
    }];
}

- (void)updateUI
{
    [self.headButton sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:_user.headimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.nameLabel setText:_user.nickname];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45;
    } else {
        return 90;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            [cell.titleLabel setText:@"爱儿号"];
            [cell.hasNewLabel setText:[ZXUtils sharedInstance].user.aier];
            return cell;
        } else if (indexPath.row == 1) {
            ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeholderCell"];
            [cell.titleLabel setText:@"个人资料"];
            [cell.hasNewLabel setText:@"赶快来编辑吧"];
            return cell;
        } else {
            ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeholderCell"];
            [cell.titleLabel setText:@"宝宝资料"];
            [cell.hasNewLabel setText:@"您还没有添加宝宝资料"];
            return cell;
        }
    } else {
        ZXProfileDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicCell"];
        BOOL hasDynamic = (_dynamic!=nil);
        [cell.tipLabel setHidden:hasDynamic];
        [cell.titleLabel setHidden:!hasDynamic];
        [cell.timeLabel setHidden:!hasDynamic];
        if (_dynamic) {
            [cell.titleLabel setText:_dynamic.content];
            [cell.timeLabel setText:[ZXTimeHelper intervalSinceNow:_dynamic.cdate]];
            if (_dynamic.img.length > 0) {
                NSString *img = [[_dynamic.img componentsSeparatedByString:@","] firstObject];
                [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForFresh:img]];
            }
        } else {
            
        }
        [cell.numLabel setText:[NSString stringWithFormat:@"%@",@(_dynamicCount)]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        _bottomView.backgroundColor = [UIColor redColor];
    }
    return _bottomView;
}
@end
