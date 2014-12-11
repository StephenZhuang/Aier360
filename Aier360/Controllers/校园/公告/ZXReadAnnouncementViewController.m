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

@interface ZXReadAnnouncementViewController ()

@end

@implementation ZXReadAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"阅读";
    self.unreadDataArray = [[NSMutableArray alloc] init];
    
    __weak ZXReadAnnouncementViewController *vc = self;
    
    _readHeader = [[[NSBundle mainBundle] loadNibNamed:@"ZXReadHeader" owner:self options:nil] firstObject];
    [_readHeader.titleLabel setText:@"已阅"];
    _readHeader.toggleBlock = ^(ZXReadHeaderState state) {
        [vc.tableView reloadData];
    };
    _unreadHeader = [[[NSBundle mainBundle] loadNibNamed:@"ZXReadHeader" owner:self options:nil] firstObject];
    [_unreadHeader.titleLabel setText:@"未阅"];
    _unreadHeader.toggleBlock = ^(ZXReadHeaderState state) {
        [vc.tableView reloadData];
    };
}

-(void)addFooter{}

- (void)loadData
{
    [ZXAnnounceRead getReaderListWithMid:_mid block:^(ZXAnnounceRead *announceRead, NSError *error) {
        
        if (announceRead) {
            [self.unreadDataArray removeAllObjects];
            [self.dataArray removeAllObjects];
            
            if (announceRead.unreadingList.length > 0) {
                NSArray *array = [announceRead.unreadingList componentsSeparatedByString:@","];
                [self.unreadDataArray addObjectsFromArray:array];
            }
            
            if (announceRead.unReadTeacherList.length > 0) {
                NSArray *array = [announceRead.unReadTeacherList componentsSeparatedByString:@","];
                [self.unreadDataArray addObjectsFromArray:array];
            }
            
            [self.dataArray addObjectsFromArray:announceRead.readedParentList];
            [self.dataArray addObjectsFromArray:announceRead.readedTeacherList];
            
            [_unreadHeader.contentLabel setText:[NSString stringWithFormat:@"(%i/%i)",self.unreadDataArray.count , self.unreadDataArray.count + self.dataArray.count]];
            [_readHeader.contentLabel setText:[NSString stringWithFormat:@"(%i/%i)",self.dataArray.count , self.unreadDataArray.count + self.dataArray.count]];
            [self.tableView reloadData];
        }
        [self.tableView headerEndRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_unreadHeader.state == ZXReadHeaderStateOn) {
            return self.unreadDataArray.count;
        } else {
            return 0;
        }
    } else {
        if (_readHeader.state == ZXReadHeaderStateOn) {
            return self.dataArray.count;
        } else {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return _unreadHeader;
    } else {
        return _readHeader;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell.textLabel setText:self.unreadDataArray[indexPath.row]];
        return cell;
    } else {
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
