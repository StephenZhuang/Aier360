//
//  ZXMessageTaskViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/14.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMessageTaskViewController.h"
#import "MagicalMacro.h"
#import "ZXMessageTask.h"

@interface ZXMessageTaskViewController ()

@end

@implementation ZXMessageTaskViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MessageAccount" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXMessageTaskViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setExtrueLineHidden];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:237/255.0 green:235/255.0 blue:229/255.0 alpha:1.0]];
    
    self.title = @"短信账户";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(recordAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.messageNumLabel.format = @"%.0f";
    [self loadData];
}

- (void)recordAction
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)loadData
{
    [ZXMessageTask getMessageTaskWithSid:[ZXUtils sharedInstance].currentSchool.sid block:^(NSArray *array,NSInteger mesCount, NSError *error) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        
        [self.messageNumLabel countFrom:self.mesCount to:mesCount];
        self.mesCount = mesCount;
        [self configureHeader];
    }];
}

- (void)configureHeader
{
    NSInteger memberNum = [ZXUtils sharedInstance].currentSchool.num_parent + [ZXUtils sharedInstance].currentSchool.num_teacher;
    NSInteger messageNum = self.mesCount / memberNum;
    [self.messageTipLabel setText:[NSString stringWithFormat:@"(可供您给全校师生发%@条通知短信)",@(messageNum)]];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.dataArray.count;
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - setters and getters
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
