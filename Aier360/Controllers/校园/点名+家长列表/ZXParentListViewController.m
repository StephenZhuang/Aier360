//
//  ZXParentListViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXParentListViewController.h"
#import "ZXStudent+ZXclient.h"
#import "ZXCheckCell.h"
#import "ZXUserDynamicViewController.h"
#import "ZXMyDynamicViewController.h"

@interface ZXParentListViewController ()
{
    NSInteger parentTag;
}
@end

@implementation ZXParentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"家长列表";
    if ([ZXUtils sharedInstance].identity == ZXIdentityClassMaster) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"成员审核" style:UIBarButtonItemStylePlain target:self action:@selector(check)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)addFooter{}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXStudent getStudentListWithCid:appStateInfo.cid isGetParent:1 block:^(NSArray *array ,NSError *error) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

- (void)check
{
    [self performSegueWithIdentifier:@"check" sender:nil];
}

#pragma -mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXStudent *student = self.dataArray[indexPath.row];
    [cell.textLabel setText:student.sname];
    cell.rejectButton.tag = indexPath.row;
    cell.agreeButton.tag = indexPath.row;
    if (student.cpList) {
        switch (student.cpList.count) {
            case 0:
            {
                [cell.agreeButton setHidden:YES];
                [cell.rejectButton setHidden:YES];
            }
                break;
            case 1:
            {
                [cell.agreeButton setHidden:NO];
                [cell.rejectButton setHidden:YES];
                ZXParent *parent1 = student.cpList[0];
                [cell.agreeButton setTitle:parent1.relation forState:UIControlStateNormal];
            }
                break;
                
            default:
            {
                [cell.agreeButton setHidden:NO];
                [cell.rejectButton setHidden:NO];
                ZXParent *parent1 = student.cpList[0];
                [cell.agreeButton setTitle:parent1.relation forState:UIControlStateNormal];
                ZXParent *parent2 = student.cpList[1];
                [cell.rejectButton setTitle:parent2.relation forState:UIControlStateNormal];
            }
                break;
        }
    } else {
        [cell.agreeButton setHidden:YES];
        [cell.rejectButton setHidden:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)parent1Action:(UIButton *)sender
{
    parentTag = 0;
    ZXStudent *student = self.dataArray[sender.tag];
    ZXParent *parent1 = student.cpList[0];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:parent1.pname delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"呼叫" otherButtonTitles:@"发短信",@"进入TA的主页", nil];
    actionSheet.tag = sender.tag;
    [actionSheet showInView:self.view];
}

- (IBAction)parent2Action:(UIButton *)sender
{
    parentTag = 1;
    ZXStudent *student = self.dataArray[sender.tag];
    ZXParent *parent1 = student.cpList[1];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:parent1.pname delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"呼叫" otherButtonTitles:@"发短信",@"进入TA的主页", nil];
    actionSheet.tag = sender.tag;
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ZXStudent *student = self.dataArray[actionSheet.tag];
    ZXParent *parent = student.cpList[parentTag];
    switch (buttonIndex) {
        case 0:
        {
            NSString *telUrl = [NSString stringWithFormat:@"telprompt://%@",parent.account];
            NSURL *url = [[NSURL alloc] initWithString:telUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 1:
        {
            NSString *telUrl = [NSString stringWithFormat:@"sms://%@",parent.account];
            NSURL *url = [[NSURL alloc] initWithString:telUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 2:
        {
            if (parent.uid == GLOBAL_UID) {
                ZXMyDynamicViewController *vc = [ZXMyDynamicViewController viewControllerFromStoryboard];
                [self.navigationController pushViewController:vc animated:YES];
            } else {                
                ZXUserDynamicViewController *vc = [ZXUserDynamicViewController viewControllerFromStoryboard];
                vc.uid = parent.uid;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
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
