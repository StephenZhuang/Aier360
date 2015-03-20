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
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXAddParentViewController.h"

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
    
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster || (CURRENT_IDENTITY == ZXIdentityClassMaster && _cid == [ZXUtils sharedInstance].currentAppStateInfo.cid)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加家长" style:UIBarButtonItemStylePlain target:self action:@selector(addParent)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)addParent
{
    if (self.dataArray.count >= 3) {
        [MBProgressHUD showError:@"最多添加三个家长，如需继续添加请先删除" toView:self.view];
        return;
    }
    [self performSegueWithIdentifier:@"addParent" sender:nil];
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
    ZXParent *parent = [self.dataArray objectAtIndex:indexPath.section];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster || (CURRENT_IDENTITY == ZXIdentityClassMaster && _cid == [ZXUtils sharedInstance].currentAppStateInfo.cid)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZXParent *parent = [self.dataArray objectAtIndex:indexPath.section];
        [ZXStudent deleteParentWithCsid:_student.csid uid:parent.uid block:^(BOOL success, NSString *errorInfo) {
            
        }];
        [self.dataArray removeObject:parent];
        [self.tableView reloadData];
    }
}

#pragma -mark
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addParent"]) {
        ZXAddParentViewController *vc = segue.destinationViewController;
        vc.csid = _student.csid;
    }
}
@end
