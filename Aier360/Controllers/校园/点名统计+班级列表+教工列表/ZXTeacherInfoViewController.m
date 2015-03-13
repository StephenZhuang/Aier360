//
//  ZXTeacherInfoViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherInfoViewController.h"
#import "ZXUserDynamicViewController.h"
#import "ZXMyDynamicViewController.h"
#import "ChatViewController.h"
#import "NSString+ZXMD5.h"
#import "ZXMenuCell.h"

@implementation ZXTeacherInfoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"资料";
    
    [_nameLabel setText:_teacher.tname];
    if (_teacher.lastLogon) {
        if ([_teacher.sex isEqualToString:@"男"]) {
            [_sexImageView setImage:[UIImage imageNamed:@"contact_male"]];
        } else {
            [_sexImageView setImage:[UIImage imageNamed:@"contact_female"]];
        }
        [_tipLabel setText:@""];
    } else {
        [_tipLabel setText:@"还未登录过"];
        [_sexImageView setImage:[UIImage imageNamed:@"contact_sexnone"]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0) {
        [cell.titleLabel setText:@"手机号"];
        [cell.hasNewLabel setText:_teacher.account];
    } else if (indexPath.row == 1) {
        [cell.titleLabel setText:@"职  务"];
        [cell.hasNewLabel setText:_teacher.gname];
    } else {
        [cell.titleLabel setText:@"班  级"];
        [cell.hasNewLabel setText:_teacher.cnames];
    }
    return cell;
}

- (IBAction)buttonAction:(UIButton *)button
{
    ZXTeacherNew *teacher = _teacher;
    switch (button.tag) {
        case 0:
        {
            NSString *telUrl = [NSString stringWithFormat:@"telprompt://%@",teacher.account];
            NSURL *url = [[NSURL alloc] initWithString:telUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 1:
        {
            NSString *telUrl = [NSString stringWithFormat:@"sms://%@",teacher.account];
            NSURL *url = [[NSURL alloc] initWithString:telUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 2:
        {
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:[teacher.account md5] isGroup:NO];
            chatVC.nickName = teacher.nickname;
            chatVC.headImage = teacher.headimg;
            [self.navigationController pushViewController:chatVC animated:YES];
        }
            break;
        case 3:
        {
            if (teacher.uid == GLOBAL_UID) {
                ZXMyDynamicViewController *vc = [ZXMyDynamicViewController viewControllerFromStoryboard];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                ZXUserDynamicViewController *vc = [ZXUserDynamicViewController viewControllerFromStoryboard];
                vc.uid = teacher.uid;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
@end
