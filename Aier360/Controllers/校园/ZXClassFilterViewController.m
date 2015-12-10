//
//  ZXClassFilterViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/10.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClassFilterViewController.h"
#import "ZXClass+ZXclient.h"
#import "ZXClassFilterTableViewCell.h"

@interface ZXClassFilterViewController ()

@end

@implementation ZXClassFilterViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"School" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"筛选班级";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self loadData];
    [self.tableView setExtrueLineHidden];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData
{
    [ZXClass getCanReleaseClassListWithSid:[ZXUtils sharedInstance].currentSchool.sid uid:GLOBAL_UID block:^(NSArray *array, NSError *error) {
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXClassFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXClassFilterTableViewCell"];
    ZXClass *class = self.dataArray[indexPath.row];
    [cell configureCellWithClass:class];
    if ([GVUserDefaults standardUserDefaults].selectedCid == class.cid) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    } else {

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZXClass *class = [self.dataArray objectAtIndex:indexPath.row];
    if (class.cid != [GVUserDefaults standardUserDefaults].selectedCid) {
        [GVUserDefaults standardUserDefaults].selectedCid = class.cid;
        !_selectClassBlock?:_selectClassBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - setters and getters
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
