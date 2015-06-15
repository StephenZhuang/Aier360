//
//  ZXTeacherGracefulViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherGracefulViewController.h"
#import "ZXCardHistoryCell.h"
#import "ZXTeacherCharisma.h"
#import "ZXTeacherGracefulDetailViewController.h"

@interface ZXTeacherGracefulViewController ()

@end

@implementation ZXTeacherGracefulViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"教师风采";
    
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addTeacher)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)addTeacher
{
    [self performSegueWithIdentifier:@"add" sender:nil];
}

- (void)addHeader{}
- (void)addFooter{}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCardHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXTeacherCharisma *teacher = self.dataArray[indexPath.row];
    [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:teacher.img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.AMLabel setText:teacher.name];
    [cell.PMLabel setText:teacher.desinfo];
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
    if ([segue.identifier isEqualToString:@"detail"]) {
        ZXCardHistoryCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ZXTeacherCharisma *teacher = self.dataArray[indexPath.row];
        ZXTeacherGracefulDetailViewController *vc = segue.destinationViewController;
        vc.teacher = teacher;
    }
}


@end
