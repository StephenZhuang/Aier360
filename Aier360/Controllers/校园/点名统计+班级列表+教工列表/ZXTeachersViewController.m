//
//  ZXTeachersViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeachersViewController.h"
#import "ZXPosition+ZXclient.h"
#import "ZXPositionTeacherViewController.h"

@interface ZXTeachersViewController ()

@end

@implementation ZXTeachersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"教工列表";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"成员审核" style:UIBarButtonItemStylePlain target:self action:@selector(joinCheck)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)joinCheck
{
    
}

- (void)addFooter{}

- (void)loadData
{
    [ZXPosition getPositionListWithSid:[ZXUtils sharedInstance].currentAppStateInfo.sid block:^(NSArray *array ,NSError *error) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXPosition *position = [self.dataArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:position.name];
    [cell.detailTextLabel setText:[NSString stringWithIntger:position.typeNumber]];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"positionTeacher"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ZXPosition *position = [self.dataArray objectAtIndex:indexPath.row];
        ZXPositionTeacherViewController *vc = segue.destinationViewController;
        vc.position = position;
    }
}


@end
