//
//  ZXBabyListViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/30.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBabyListViewController.h"
#import "ZXMenuCell.h"
#import "ZXAddBabyViewController.h"

@interface ZXBabyListViewController ()

@end

@implementation ZXBabyListViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXBabyListViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"宝宝资料";
    if (_isMine) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加宝宝" style:UIBarButtonItemStylePlain target:self action:@selector(addBaby)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark tableview datasoruce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXBaby *baby = [self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        [cell.titleLabel setText:@"宝宝昵称"];
        [cell.hasNewLabel setText:baby.nickname];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (indexPath.row == 1) {
        [cell.titleLabel setText:@"性别"];
        [cell.hasNewLabel setText:baby.sex];
        if (_isMine) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        [cell.titleLabel setText:@"生日"];
        [cell.hasNewLabel setText:[[baby.birthday componentsSeparatedByString:@"T"] firstObject]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isMine) {
        __weak __typeof(&*self)weakSelf = self;
        ZXBaby *baby = [self.dataArray objectAtIndex:indexPath.section];
        ZXAddBabyViewController *vc = [ZXAddBabyViewController viewControllerFromStoryboard];
        vc.isAdd = NO;
        vc.baby = baby;
        vc.addBlock = ^(ZXBaby *changedbaby) {
            [weakSelf.tableView reloadData];
        };
        vc.deleteBlock = ^(void) {
            [weakSelf.dataArray removeObject:baby];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -mark private
- (void)addBaby
{
    __weak __typeof(&*self)weakSelf = self;
    ZXAddBabyViewController *vc = [ZXAddBabyViewController viewControllerFromStoryboard];
    vc.isAdd = YES;
    vc.addBlock = ^(ZXBaby *baby) {
        [weakSelf.dataArray addObject:baby];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark gettters and setters
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
