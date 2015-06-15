//
//  ZXClassMultiPickerViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/17.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClassMultiPickerViewController.h"
#import "ZXClass+ZXclient.h"
#import "ZXClassPickCell.h"

@implementation ZXClassMultiPickerViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择班级";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    
}

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Teachers" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXClassMultiPickerViewController"];
}

- (void)doneAction
{
    NSArray *arr = [self.tableView indexPathsForSelectedRows];
    
    NSString *classids = @"";
    NSString *classNames = @"";
    
    for (NSIndexPath *indexPath in arr) {
        ZXClass *zxclass = [self.dataArray objectAtIndex:indexPath.row];
        classids = [classids stringByAppendingFormat:@"%li,",zxclass.cid];
        classNames = [classNames stringByAppendingFormat:@"%@,",zxclass.cname];
    }
    
    if ([classNames hasSuffix:@","]) {
        classNames = [classNames substringToIndex:classNames.length - 1];
    }
    
    if ([classids hasSuffix:@","]) {
        classids = [classids substringToIndex:classids.length - 1];
    }
    
    
    if (_ClassPickBlock) {
        _ClassPickBlock(classNames ,classids);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addFooter{}

- (void)loadData
{
    ZXSchool *school = [ZXUtils sharedInstance].currentSchool;
    [ZXClass getClassListWithSid:school.sid block:^(NSArray *array, NSError *error) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
        if (_classids.length > 0) {
            NSArray *arr = [_classids componentsSeparatedByString:@","];
            for (NSString *cid in arr) {
                for (int i = 0; i < self.dataArray.count; i++) {
                    ZXClass *zxclass = self.dataArray[i];
                    if (cid.longLongValue == zxclass.cid) {
                        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                        
                        break;
                    }
                }
            }
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXClassPickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXClassPickCell"];
    ZXClass *zxclass = [self.dataArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:zxclass.cname];
    return cell;
}
@end
