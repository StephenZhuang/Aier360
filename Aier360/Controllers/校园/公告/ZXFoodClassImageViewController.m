//
//  ZXFoodClassImageViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/23.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFoodClassImageViewController.h"
#import "ZXClass+ZXclient.h"
#import "ZXImageCell.h"
#import "UIViewController+ZXPhotoBrowser.h"

@implementation ZXFoodClassImageViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXFoodClassImageViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"餐饮图片";
}

- (void)loadData
{
    [ZXClass getClassImageListWithDfid:_dfid page:page page_size:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZXClass *class = [self.dataArray objectAtIndex:section];
    if (class.dailyFoodImgs.length > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    } else {
        ZXClass *class = [self.dataArray objectAtIndex:indexPath.section];
        NSArray *arr = [class.dailyFoodImgs componentsSeparatedByString:@","];
        return [ZXImageCell heightByImageArray:arr];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXClass *class = [self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        NSInteger imageNum = 0;
        if (class.dailyFoodImgs.length > 0) {
            NSArray *arr = [class.dailyFoodImgs componentsSeparatedByString:@","];
            imageNum = arr.count;
        }
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:class.cname attributes:@{NSForegroundColorAttributeName : [UIColor blackColor],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%i)",imageNum] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:91 green:91 blue:91],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
        [string appendAttributedString:string2];
        [cell.textLabel setAttributedText:string];
        
        return cell;
    } else {
        __weak __typeof(&*self)weakSelf = self;
        ZXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImageCell"];
        __block NSArray *arr = [class.dailyFoodImgs componentsSeparatedByString:@","];
        cell.type = ZXImageTypeEat;
        [cell setImageArray:arr];
        cell.imageClickBlock = ^(NSInteger index) {
            [weakSelf browseImage:arr type:ZXImageTypeEat index:index];
        };
        return cell;
    }
    
}
@end
