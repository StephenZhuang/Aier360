//
//  ZXAddStudentViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/18.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddStudentViewController.h"

@implementation ZXStudentTemp

@end

@implementation ZXAddStudentViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加学生";
    
    dataArray = [[NSMutableArray alloc] init];
    ZXStudentTemp *student = [[ZXStudentTemp alloc] init];
    [dataArray addObject:student];
}

- (IBAction)addStudent:(id)sender
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

@end
