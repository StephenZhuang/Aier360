//
//  ZXStudentInfoViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/18.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXStudentInfoViewController.h"
#import "ZXClassTeacherCell.h"
#import "ChatViewController.h"
#import "ZXMyDynamicViewController.h"
#import "ZXUserDynamicViewController.h"
#import "NSString+ZXMD5.h"
#import "ZXContactHeader.h"
#import "ZXStudent+ZXclient.h"

@implementation ZXStudentInfoViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Teachers" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXStudentInfoViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _student.sname;
    [self.tableView registerClass:[ZXContactHeader class] forHeaderFooterViewReuseIdentifier:@"contactHeader"];
}

- (void)addFooter{}

- (void)loadData
{
    [ZXStudent getParentListWithCsid:_student.csid block:^(NSArray *array, NSError *error) {
        [self configureArrayWithNoFooter:array];
    }];
}

#pragma -mark
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZXContactHeader *contactHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"contactHeader"];
    if (section == 0) {
        [contactHeader.titleLabel setText:@"家长"];
    } else {
        [contactHeader.titleLabel setText:@""];
    }
    return contactHeader;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXClassTeacherCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXClassTeacherCell"];
    ZXParent *parent = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell.titleLabel setText:parent.relation];
    if (parent.lastLogon) {
        [cell.hasNewLabel setText:@""];
        if ([parent.sex isEqualToString:@"男"]) {
            [cell.logoImage setImage:[UIImage imageNamed:@"contact_male"]];
        } else {
            [cell.logoImage setImage:[UIImage imageNamed:@"contact_female"]];
        }
        
    } else {
        [cell.logoImage setImage:[UIImage imageNamed:@"contact_sexnone"]];
        [cell.hasNewLabel setText:@"还未登录过"];
    }
    
    [cell.masterLabel setText:parent.account];
    
    return cell;
}

- (IBAction)buttonAction:(UIButton *)button
{
    CGRect rect = [button.superview convertRect:button.frame toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rect.origin];
    
    ZXParent *parent = self.dataArray[indexPath.section];
    switch (button.tag) {
        case 0:
        {
            NSString *telUrl = [NSString stringWithFormat:@"telprompt://%@",parent.account];
            NSURL *url = [[NSURL alloc] initWithString:telUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 1:
        {
            NSString *telUrl = [NSString stringWithFormat:@"sms://%@",parent.account];
            NSURL *url = [[NSURL alloc] initWithString:telUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 2:
        {
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:[parent.account md5] isGroup:NO];
            chatVC.nickName = parent.nickname;
            chatVC.headImage = parent.headimg;
            [self.navigationController pushViewController:chatVC animated:YES];
        }
            break;
        case 3:
        {
            if (parent.uid == GLOBAL_UID) {
                ZXMyDynamicViewController *vc = [ZXMyDynamicViewController viewControllerFromStoryboard];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                ZXUserDynamicViewController *vc = [ZXUserDynamicViewController viewControllerFromStoryboard];
                vc.uid = parent.uid;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
@end
