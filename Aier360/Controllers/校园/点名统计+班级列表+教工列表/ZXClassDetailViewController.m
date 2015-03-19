//
//  ZXClassDetailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClassDetailViewController.h"
#import "ZXTeacherNew+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXClassTeacherCell.h"
#import "ZXContactHeader.h"
#import "ZXStudent.h"
#import "ZXStudentInfoViewController.h"
#import "ZXTeacherInfoViewController.h"
#import "ZXAddStudentViewController.h"

@interface ZXClassDetailViewController ()

@end

@implementation ZXClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _zxclass.cname;
    _studentArray = [[NSMutableArray alloc] init];
    
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster || CURRENT_IDENTITY == ZXIdentityClassMaster) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加学生" style:UIBarButtonItemStylePlain target:self action:@selector(addStudent)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    [self.tableView registerClass:[ZXContactHeader class] forHeaderFooterViewReuseIdentifier:@"contactHeader"];
}

- (void)addStudent
{
    [self performSegueWithIdentifier:@"addStudent" sender:nil];
}

- (void)addFooter{}

- (void)loadData
{
    [ZXTeacherNew getTeacherAndStudentListWithCid:_zxclass.cid block:^(NSArray *teachers, NSArray *students, NSError *error) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:teachers];
        
        [_studentArray removeAllObjects];
        [_studentArray addObjectsFromArray:students];
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

#pragma -mark
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    } else {
        return _studentArray.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZXContactHeader *contactHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"contactHeader"];
    if (section == 0) {
        [contactHeader.titleLabel setText:@"教工"];
    } else {
        [contactHeader.titleLabel setText:@"学生"];
    }
    return contactHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        ZXStudent *student = [self.studentArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:student.sname];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"家长%li",(long)student.num_parent]];
        return cell;
    } else {
        ZXClassTeacherCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXClassTeacherCell"];
        ZXTeacherNew *teacher = [self.dataArray objectAtIndex:indexPath.row];
        
        [cell.titleLabel setText:teacher.tname];
        if (teacher.lastLogon) {
            [cell.hasNewLabel setText:@""];
            if ([teacher.sex isEqualToString:@"男"]) {
                [cell.logoImage setImage:[UIImage imageNamed:@"contact_male"]];
            } else {
                [cell.logoImage setImage:[UIImage imageNamed:@"contact_female"]];
            }
            
        } else {
            [cell.logoImage setImage:[UIImage imageNamed:@"contact_sexnone"]];
            [cell.hasNewLabel setText:@"还未登录过"];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXTeacherInfoViewController *vc = [ZXTeacherInfoViewController viewControllerFromStoryboard];
        ZXTeacherNew *teacher = [self.dataArray objectAtIndex:indexPath.row];
        vc.teacher = teacher;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    if ([segue.identifier isEqualToString:@"studentInfo"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ZXStudent *student = [self.studentArray objectAtIndex:indexPath.row];
        ZXStudentInfoViewController *vc = segue.destinationViewController;
        vc.student = student;
    } else if ([segue.identifier isEqualToString:@"addStudent"]) {
        ZXAddStudentViewController *vc = segue.destinationViewController;
        vc.zxclass = _zxclass;
    }
}


@end
