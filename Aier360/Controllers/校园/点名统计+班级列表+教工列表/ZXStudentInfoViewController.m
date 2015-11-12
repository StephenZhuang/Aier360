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
#import "ZXMyProfileViewController.h"
#import "ZXUserProfileViewController.h"
#import "NSString+ZXMD5.h"
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
    
    if (HASIdentyty(ZXIdentitySchoolMaster) || HASIdentytyWithCid(ZXIdentityClassMaster, _cid)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加家长" style:UIBarButtonItemStylePlain target:self action:@selector(addParent)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)addParent
{
    if (self.dataArray.count >= 3) {
        [MBProgressHUD showError:@"最多添加三个家长" toView:self.view];
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

#pragma mark-
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"家长";
    } else {
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:HEADER_TITLE_COLOR];
    
    header.contentView.backgroundColor = HEADER_BG_COLOR;
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
    if (HASIdentyty(ZXIdentitySchoolMaster) || HASIdentytyWithCid(ZXIdentityClassMaster, self.cid)) {
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

#pragma mark-
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
                ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
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
