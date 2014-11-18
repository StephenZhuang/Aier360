//
//  ZXPositionTeacherViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPositionTeacherViewController.h"
#import "ZXTeacher+ZXclient.h"

@interface ZXPositionTeacherViewController ()

@end

@implementation ZXPositionTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _position.name;
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXTeacher getTeacherListWithSid:appStateInfo.sid gid:_position.gid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        
        if (array) {
            if (page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < pageCount) {
                hasMore = NO;
                [self.tableView setFooterHidden:YES];
            }
        } else {
            hasMore = NO;
            [self.tableView setFooterHidden:YES];
        }
        if (page == 1) {
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXTeacher *teacher = [self.dataArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:teacher.tname];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXTeacher *teacher = [self.dataArray objectAtIndex:indexPath.row];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:teacher.tname delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"呼叫" otherButtonTitles:@"发短信",@"进入TA的主页", nil];
    actionSheet.tag = indexPath.row;
    [actionSheet showInView:self.view];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ZXTeacher *teacher = [self.dataArray objectAtIndex:actionSheet.tag];
    switch (buttonIndex) {
        case 0:
        {
            NSString *telUrl = [NSString stringWithFormat:@"telprompt://%@",teacher.account];
            NSURL *url = [[NSURL alloc] initWithString:telUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 1:
        {
            NSString *telUrl = [NSString stringWithFormat:@"sms://%@",teacher.account];
            NSURL *url = [[NSURL alloc] initWithString:telUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 2:
            //TODO: 进入TA的主页
            break;
        default:
            break;
    }
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
