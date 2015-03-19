//
//  ZXAddStudentViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/18.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddStudentViewController.h"
#import "ZXMenuCell.h"
#import "ZXAddTeacherCell.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXStudent+ZXclient.h"

@implementation ZXStudentTemp

@end

@implementation ZXAddStudentViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加学生";
    [_tipLabel setText:[NSString stringWithFormat:@"当前班级为%@,一次最多添加5个学生",_zxclass.cname]];
    
    dataArray = [[NSMutableArray alloc] init];
    ZXStudentTemp *student = [[ZXStudentTemp alloc] init];
    [dataArray addObject:student];
}

- (void)addStudent
{
    [self.view endEditing:YES];
    ZXStudentTemp *student = [[ZXStudentTemp alloc] init];
    [dataArray addObject:student];
    [self.tableView reloadData];
}

- (IBAction)doneAction:(id)sender
{
    [self.view endEditing:YES];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *snames = @"";
    NSString *sexs = @"";
    for (ZXStudentTemp *student in dataArray) {
        if (student.name.length > 0 && student.sex) {
            [array addObject:student];
            snames = [snames stringByAppendingFormat:@"%@,",student.name];
            sexs = [sexs stringByAppendingFormat:@"%@,",student.sex];
        }
    }
    
    if (array.count == 0) {
        [MBProgressHUD showText:@"请将资料填写完整" toView:self.view];
        return;
    }
    
    if ([snames hasSuffix:@","]) {
        snames = [snames substringToIndex:snames.length - 1];
    }
    
    if ([sexs hasSuffix:@","]) {
        sexs = [sexs substringToIndex:sexs.length - 1];
    }
    
    MBProgressHUD *hud= [MBProgressHUD showWaiting:@"添加中" toView:self.view];
    [ZXStudent addStudentWithCid:_zxclass.cid snames:snames sexs:sexs block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [hud turnToSuccess:@""];
            for (ZXStudentTemp *student in array) {
                [dataArray removeObject:student];
            }
            if (dataArray.count == 0) {
                ZXStudentTemp *student = [[ZXStudentTemp alloc] init];
                [dataArray addObject:student];
            }
            [self.tableView reloadData];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
}

#pragma -mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MIN(5, dataArray.count + 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == dataArray.count) {
        return 1;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == dataArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    } else {
        ZXStudentTemp *student = [dataArray objectAtIndexedSubscript:indexPath.section];
        if (indexPath.row == 0) {
            ZXAddTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXAddTeacherCell"];
            [cell.textField setText:student.name];
            cell.textField.tag = indexPath.section;
            return cell;
        } else {
            ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMenuCell"];
            if (student.sex) {
                [cell.hasNewLabel setText:student.sex];
            } else {
                [cell.hasNewLabel setText:@"请选择学生性别"];
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == dataArray.count) {
        [self addStudent];
    } else {
        if (indexPath.row == 1) {
            [self.view endEditing:YES];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
            actionSheet.tag = indexPath.section;
            [actionSheet showInView:self.view];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -mark
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ZXStudentTemp *student = dataArray[textField.tag];
    student.name = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma -mark actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ZXStudentTemp *student = dataArray[actionSheet.tag];
    if (buttonIndex == 0) {
        student.sex = @"男";
        [self.tableView reloadData];
    } else if (buttonIndex == 1) {
        student.sex = @"女";
        [self.tableView reloadData];
    }
}

@end
