//
//  ZXAnnouncementTypeViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementTypeViewController.h"
#import "ZXAnnouncementTypeCell.h"
#import "ZXTeacherPickViewController.h"

@interface ZXAnnouncementTypeViewController ()

@end

@implementation ZXAnnouncementTypeViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXAnnouncementTypeViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择收件人";
    if (_type >= 0) {
        NSInteger row = 0;
        switch (_type) {
            case 0:
                row = 0;
                break;
            case 2:
                row = 1;
                break;
            case 3:
                row = 2;
                break;
            default:
                break;
        }
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)addHeader{}
- (void)addFooter{}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXAnnouncementTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXAnnouncementTypeCell"];
    if (indexPath.row == 0) {
        [cell.titleLabel setText:@"所有教工和家长"];
    } else if (indexPath.row == 1) {
        [cell.titleLabel setText:@"所有教工"];
    } else {
        [cell.titleLabel setText:@"部分教工"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        if (indexPath.row == 0) {
            _type = 0;
        } else {
            _type = 2;
        }
        !_selectBlock?:_selectBlock(_type,nil,nil);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        ZXTeacherPickViewController *vc = [ZXTeacherPickViewController viewControllerFromStoryboard];
        vc.tids = _tids;
        vc.selectBlock = ^(NSInteger selectedType,NSString *selectedTids,NSString *selectedTnams) {
            !_selectBlock?:_selectBlock(selectedType,selectedTids,selectedTnams);
        };
        [self.navigationController pushViewController:vc animated:YES];
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
