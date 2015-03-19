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
    
}

#pragma -mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataArray.count >= 5) {
        return 5;
    } else {
        return dataArray.count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count >= 5) {
        return 2;
    } else {
        if (section < dataArray.count) {
            return 2;
        } else {
            return 1;
        }
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
    if (dataArray.count >= 5) {
        ZXStudentTemp *student = [dataArray objectAtIndexedSubscript:indexPath.section];
        if (indexPath.row == 0) {
            ZXAddTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXAddTeacherCell"];
            [cell.textField setText:student.name];
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
    } else {
        if (indexPath.section < dataArray.count) {
            ZXStudentTemp *student = [dataArray objectAtIndexedSubscript:indexPath.section];
            if (indexPath.row == 0) {
                ZXAddTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXAddTeacherCell"];
                [cell.textField setText:student.name];
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
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataArray.count >= 5) {
        if (indexPath.row == 1) {
            [self.view endEditing:YES];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
            actionSheet.tag = indexPath.section;
            [actionSheet showInView:self.view];
        }
    } else {
        if (indexPath.section < dataArray.count) {
            if (indexPath.row == 1) {
                [self.view endEditing:YES];
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
                actionSheet.tag = indexPath.section;
                [actionSheet showInView:self.view];
            }
        } else {
            [self addStudent];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -mark
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ZXStudentTemp *student = dataArray[textField.tag];
    student.name = textField.text;
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
