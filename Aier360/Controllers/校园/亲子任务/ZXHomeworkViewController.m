//
//  ZXHomeworkViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomeworkViewController.h"
#import "ZXHomework+ZXclient.h"
#import "ZXHomeworkDetailViewController.h"
#import "ZXAddHomeworkViewController.h"
#import "ZXImageCell.h"
#import "ZXHomeworkCell.h"
#import "ZXHomeworkToolCell.h"

@interface ZXHomeworkViewController ()

@end

@implementation ZXHomeworkViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Homework" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXHomeworkViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"亲子任务";
    
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"school_message"] style:UIBarButtonItemStyleBordered target:self action:@selector(goToMessage)];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_release"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItems = @[more,message];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)goToMessage
{
    [self performSegueWithIdentifier:@"message" sender:nil];
}

- (void)moreAction
{
    ZXAddHomeworkViewController *vc = [ZXAddHomeworkViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXHomework getClassHomeworkListWithUid:GLOBAL_UID sid:appStateInfo.sid cid:appStateInfo.cid page:page page_size:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZXHomework *homework = self.dataArray[section];
    if (homework.img.length > 0) {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXHomework *homework = [self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        return [ZXHomeworkCell heightByText:homework.content];
    }
    else {
        if (homework.img.length > 0) {
            NSArray *arr = [homework.img componentsSeparatedByString:@","];
            return [ZXImageCell heightByImageArray:arr];
        }
    }
    //工具栏
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXHomework *homework = [self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        ZXHomeworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXHomeworkCell"];
        [cell configureUIWithHomework:homework indexPath:indexPath];
        if (CURRENT_IDENTITY == ZXIdentityClassMaster) {
            [cell.deleteButton setHidden:NO];
        } else {
            [cell.deleteButton setHidden:YES];
            [cell removeDeleteButton];
        }
        return cell;
    }
    else {
        if (homework.img.length > 0) {
            NSArray *arr = [homework.img componentsSeparatedByString:@","];
            ZXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImageCell"];
            [cell setImageArray:arr];
            return cell;
        }
    }
    //工具栏
    ZXHomeworkToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXHomeworkToolCell"];
    [cell configureUIWithHomework:homework indexPath:indexPath];
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
