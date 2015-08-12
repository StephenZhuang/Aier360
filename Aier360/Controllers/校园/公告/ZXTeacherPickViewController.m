//
//  ZXTeacherPickViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherPickViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXTeacherPickCell.h"
#import "ZXTeacherNew.h"
@interface ZXTeacherPickViewController ()

@end

@implementation ZXTeacherPickViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXTeacherPickViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择教工";
    [self.tableView setExtrueLineHidden];
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"加载中..." toView:self.view];
    [ZXPosition getPositionListWithSid:[ZXUtils sharedInstance].currentSchool.sid tids:_tids block:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [hud hide:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                for (ZXPosition *position in self.dataArray) {
                    for (ZXTeacherNew *teacher in position.list) {
                        if (teacher.isSelected) {
                            [self.selectedArray addObject:teacher];
                        }
                    }
                }
            });
        } else {
            [hud turnToError:error.localizedDescription];
        }
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZXPosition *position = self.dataArray[section];
    return position.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXTeacherPickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXTeacherPickCell"];
    ZXPosition *position = self.dataArray[indexPath.section];
    ZXTeacherNew *teacher = position.list[indexPath.row];
    [cell.nameLabel setText:teacher.tname];
    if (teacher.isSelected) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (teacher.lastLogon) {
        if ([teacher.sex isEqualToString:@"男"]) {
            [cell.headImage setImage:[UIImage imageNamed:@"contact_male"]];
        } else {
            [cell.headImage setImage:[UIImage imageNamed:@"contact_female"]];
        }
    } else {
        [cell.headImage setImage:[UIImage imageNamed:@"contact_sexnone"]];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ZXPosition *position = self.dataArray[section];
    return [NSString stringWithFormat:@"%@(%@)",position.name,@(position.list.count)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor: [UIColor colorWithRed:179/255.0 green:176/255.0 blue:168/255.0 alpha:1.0]];
    [header.textLabel setFont:[UIFont systemFontOfSize:13]];
    
    header.contentView.backgroundColor = [UIColor colorWithRed:247 green:245 blue:237];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPosition *position = self.dataArray[indexPath.section];
    ZXTeacherNew *teacher = position.list[indexPath.row];
    teacher.isSelected = YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPosition *position = self.dataArray[indexPath.section];
    ZXTeacherNew *teacher = position.list[indexPath.row];
    teacher.isSelected = NO;
}

#pragma mark - setters and getters
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
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
