//
//  ZXReadAnnouncementViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXReadAnnouncementViewController.h"
#import "ZXAnnounceRead+ZXclient.h"
#import "ZXBaseCell.h"
#import "ZXMyDynamicViewController.h"
#import "ZXUserDynamicViewController.h"

@interface ZXReadAnnouncementViewController ()

@end

@implementation ZXReadAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"阅读";
    
    __weak ZXReadAnnouncementViewController *vc = self;
    
    _readHeader = [[[NSBundle mainBundle] loadNibNamed:@"ZXReadHeader" owner:self options:nil] firstObject];
    [_readHeader.titleLabel setText:@"已阅"];
    _readHeader.toggleBlock = ^(ZXReadHeaderState state) {
        [vc.tableView reloadData];
    };
}

-(void)addFooter{}

- (void)loadData
{
    [ZXAnnounceRead getReaderListWithMid:_mid block:^(ZXAnnounceRead *announceRead, NSError *error) {
        
        if (announceRead) {
            [self.dataArray removeAllObjects];
            
            [self.dataArray addObjectsFromArray:announceRead.readedParentList];
            [self.dataArray addObjectsFromArray:announceRead.readedTeacherList];
            [_readHeader.contentLabel setText:[NSString stringWithFormat:@"(%i)",self.dataArray.count]];
            [self.tableView reloadData];
        }
        [self.tableView headerEndRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_readHeader.state == ZXReadHeaderStateOn) {
        return self.dataArray.count;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _readHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
    if ([self.dataArray[indexPath.row] isKindOfClass:[ZXParent class]]) {
        ZXParent *parent = self.dataArray[indexPath.row];
        [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:parent.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [cell.titleLabel setText:parent.pname];
    } else if ([self.dataArray[indexPath.row] isKindOfClass:[ZXTeacher class]]) {
        ZXTeacher *teacher = self.dataArray[indexPath.row];
        [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:teacher.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [cell.titleLabel setText:teacher.tname];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger uid = 0;
    if ([self.dataArray[indexPath.row] isKindOfClass:[ZXParent class]]) {
        ZXParent *parent = self.dataArray[indexPath.row];
        uid = parent.uid;
    } else if ([self.dataArray[indexPath.row] isKindOfClass:[ZXTeacher class]]) {
        ZXTeacher *teacher = self.dataArray[indexPath.row];
        uid = teacher.uid;
    }
    if (uid == GLOBAL_UID) {
        ZXMyDynamicViewController *vc = [ZXMyDynamicViewController viewControllerFromStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZXUserDynamicViewController *vc = [ZXUserDynamicViewController viewControllerFromStoryboard];
        vc.uid = uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
