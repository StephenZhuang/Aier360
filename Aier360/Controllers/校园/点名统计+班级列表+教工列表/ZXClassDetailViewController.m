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
#import "ZXStudent.h"
#import "ZXStudentInfoViewController.h"
#import "ZXTeacherInfoViewController.h"
#import "ZXAddStudentViewController.h"
#import "ZXUnactiveParentViewController.h"

@interface ZXClassDetailViewController ()
@property (nonatomic , strong) NSMutableArray *studentArray;
@end

@implementation ZXClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _zxclass.cname;
    _studentArray = [[NSMutableArray alloc] init];
    
    if (HASIdentyty(ZXIdentitySchoolMaster) || HASIdentytyWithCid(ZXIdentityClassMaster, _zxclass.cid)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加学生" style:UIBarButtonItemStylePlain target:self action:@selector(addStudent)];
        self.navigationItem.rightBarButtonItem = item;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotToUnactive)];
        [self.tableView.tableHeaderView addGestureRecognizer:tap];
        self.tableView.tableHeaderView.userInteractionEnabled = YES;
    } else {
        self.tableView.tableHeaderView = nil;
    }
}

- (void)gotToUnactive
{
    ZXUnactiveParentViewController *vc = [ZXUnactiveParentViewController viewControllerFromStoryboard];
    vc.cid = self.zxclass.cid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addStudent
{
    [self performSegueWithIdentifier:@"addStudent" sender:nil];
}

- (void)addFooter{}

- (void)loadData
{
    [ZXTeacherNew getTeacherAndStudentListWithCid:_zxclass.cid block:^(NSArray *teachers, NSArray *students,NSInteger num_nologin_parent, NSError *error) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:teachers];
        
        [_studentArray removeAllObjects];
        [_studentArray addObjectsFromArray:students];
        
        self.num_nologin_parent = num_nologin_parent;
        [self configureHeader];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

- (void)configureHeader
{
    if (self.unactiveLabel) {
        [self.unactiveLabel setText:[NSString stringWithFormat:@"%@",@(self.num_nologin_parent)]];
    }
}

#pragma mark-
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
    if ([[ZXUtils sharedInstance] getHigherIdentity] == ZXIdentityParent) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    } else {
        return _studentArray.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"教师";
    } else {
        return @"学生";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:HEADER_TITLE_COLOR];
    
    header.contentView.backgroundColor = HEADER_BG_COLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        ZXStudent *student = [self.studentArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:student.sname];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@/%@",@(student.num_login_parent),@(student.num_parent)]];
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
        
        if (teacher.isClassAdmin) {
            [cell.masterLabel setHidden:NO];
        } else {
            [cell.masterLabel setHidden:YES];
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
        vc.canEdit = YES;
        vc.cid = _zxclass.cid;
    } else if ([segue.identifier isEqualToString:@"addStudent"]) {
        ZXAddStudentViewController *vc = segue.destinationViewController;
        vc.zxclass = _zxclass;
    }
}


@end
