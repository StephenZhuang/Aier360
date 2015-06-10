//
//  ZXUserDynamicListViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/20.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUserDynamicListViewController.h"
#import "ZXReleaseMyDynamicViewController.h"
#import "ZXPersonalDynamic+ZXclient.h"
#import "ZXPersonalDynamicCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import "ZXTimeHelper.h"
#import "ZXPersonalDyanmicDetailViewController.h"

@implementation ZXUserDynamicListViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXUserDynamicListViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"动态";
    if (_uid == GLOBAL_UID) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (IBAction)addAction:(id)sender
{
    ZXReleaseMyDynamicViewController *vc = [ZXReleaseMyDynamicViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData
{
    [ZXPersonalDynamic getPersonalDynamicWithUid:_uid fuid:GLOBAL_UID page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_uid == GLOBAL_UID) {
        return self.dataArray.count + 1;
    } else {
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_uid == GLOBAL_UID) {
        if (indexPath.section == 0) {
            return 83;
        } else {
            ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section - 1];
            if ((dynamic.original == 1 && dynamic.dynamic.img.length == 0) || (dynamic.original == 0 && dynamic.img.length == 0)) {
                return [tableView fd_heightForCellWithIdentifier:@"ZXPersonalDynamicTextCell" cacheByIndexPath:indexPath configuration:^(ZXPersonalDynamicCell *cell) {
                    // configurations
                    if (dynamic.original == 1) {
                        cell.contentLabel.fd_collapsed = NO;
                    } else {
                        cell.contentLabel.fd_collapsed = YES;
                    }
                }];
            } else {
                return [tableView fd_heightForCellWithIdentifier:@"ZXPersonalDynamicCell" cacheByIndexPath:indexPath configuration:^(ZXPersonalDynamicCell *cell) {
                    // configurations
                    if (dynamic.original == 1) {
                        cell.repostBackground.fd_collapsed = NO;
                    } else {
                        cell.repostBackground.fd_collapsed = YES;
                    }
                }];
            }
        }
    } else {
        ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section];
        if ((dynamic.original == 1 && dynamic.dynamic.img.length == 0) || (dynamic.original == 0 && dynamic.img.length == 0)) {
            return [tableView fd_heightForCellWithIdentifier:@"ZXPersonalDynamicTextCell" cacheByIndexPath:indexPath configuration:^(ZXPersonalDynamicCell *cell) {
                // configurations
                if (dynamic.original == 1) {
                    cell.contentLabel.fd_collapsed = NO;
                } else {
                    cell.contentLabel.fd_collapsed = YES;
                }
            }];
        } else {
            return [tableView fd_heightForCellWithIdentifier:@"ZXPersonalDynamicCell" cacheByIndexPath:indexPath configuration:^(ZXPersonalDynamicCell *cell) {
                // configurations
                if (dynamic.original == 1) {
                    cell.repostBackground.fd_collapsed = NO;
                } else {
                    cell.repostBackground.fd_collapsed = YES;
                }
            }];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 35;
    } else {
        ZXPersonalDynamic *dynamic = nil;
        ZXPersonalDynamic *previousDynamic = nil;
        if (_uid == GLOBAL_UID) {
            dynamic = [self.dataArray objectAtIndex:section - 1];
            if (section - 2 >= 0) {
                previousDynamic = [self.dataArray objectAtIndex:section - 2];
            }
        } else {
            dynamic = [self.dataArray objectAtIndex:section];
            if (section - 1 >= 0) {
                previousDynamic = [self.dataArray objectAtIndex:section - 1];
            }
        }
        if ([self isOneDay:dynamic previousDynamic:previousDynamic]) {
            return 10;
        } else {
            return 30;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_uid == GLOBAL_UID && indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    } else {
        ZXPersonalDynamic *dynamic = nil;
        ZXPersonalDynamic *previousDynamic = nil;
        if (_uid == GLOBAL_UID) {
            dynamic = [self.dataArray objectAtIndex:indexPath.section - 1];
            if (indexPath.section - 2 >= 0) {
                previousDynamic = [self.dataArray objectAtIndex:indexPath.section - 2];
            }
        } else {
            dynamic = [self.dataArray objectAtIndex:indexPath.section];
            if (indexPath.section - 1 >= 0) {
                previousDynamic = [self.dataArray objectAtIndex:indexPath.section - 1];
            }
        }
        
        if ((dynamic.original == 1 && dynamic.dynamic.img.length == 0) || (dynamic.original == 0 && dynamic.img.length == 0)) {
            ZXPersonalDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXPersonalDynamicTextCell"];
            if ([self isOneDay:dynamic previousDynamic:previousDynamic]) {
                [cell.timeLabel setHidden:YES];
            } else {
                [cell.timeLabel setHidden:NO];
                [cell.timeLabel setText:[self shortTime:dynamic.cdate]];
            }
            if (dynamic.original == 1) {
                cell.contentLabel.fd_collapsed = NO;
                [cell.repostLabel setText:dynamic.content];
                [cell.contentLabel setText:dynamic.dynamic.content];
            } else {
                cell.contentLabel.fd_collapsed = YES;
                [cell.repostLabel setText:dynamic.content];
                [cell.contentLabel setText:nil];
            }
            
            return cell;
        } else {
            ZXPersonalDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXPersonalDynamicCell"];
            if ([self isOneDay:dynamic previousDynamic:previousDynamic]) {
                [cell.timeLabel setHidden:YES];
            } else {
                [cell.timeLabel setHidden:NO];
                [cell.timeLabel setText:[self shortTime:dynamic.cdate]];
            }
            
            NSString *img = @"";
            if (dynamic.original == 1) {
                cell.repostBackground.fd_collapsed = NO;
                [cell.repostLabel setText:dynamic.content];
                [cell.contentLabel setText:dynamic.dynamic.content];
                img = dynamic.dynamic.img;
            } else {
                cell.repostBackground.fd_collapsed = YES;
                [cell.contentLabel setText:dynamic.content];
                img = dynamic.img;
            }
            
            NSArray *array = [img componentsSeparatedByString:@","];
            NSString *imgString = [array firstObject];
            [cell.logoImageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForFresh:imgString] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            [cell.imgNumLabel setText:[NSString stringWithFormat:@"共%@张",@(array.count)]];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_uid == GLOBAL_UID) {
        if (indexPath.section > 0) {
            ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:indexPath.section-1];
            ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
            vc.did = dynamc.did;
            vc.type = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:indexPath.section];
        ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
        vc.did = dynamc.did;
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)isOneDay:(ZXPersonalDynamic *)dynamic previousDynamic:(ZXPersonalDynamic *)previousDynamic
{
    NSString *dateString = [dynamic.cdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dateString = [[dateString componentsSeparatedByString:@" "] firstObject];
    if (previousDynamic) {
        NSString *preiousString = [previousDynamic.cdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        preiousString = [[preiousString componentsSeparatedByString:@" "] firstObject];
        if ([preiousString isEqualToString:dateString]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        if (_uid == GLOBAL_UID) {
            NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
            [fomatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *today = [NSDate new];
            NSString *todayString = [fomatter stringFromDate:today];
            if ([todayString isEqualToString:dateString]) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    }
}

- (NSString *)shortTime:(NSString *)time
{
    time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate *today = [NSDate new];
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [fomatter dateFromString:time];
    
    NSString *todayString = [fomatter stringFromDate:today];
    NSString *dateString = [[time componentsSeparatedByString:@" "] firstObject];
    if ([dateString isEqualToString:[[todayString componentsSeparatedByString:@" "] firstObject]]) {
        return @"今天";
    } else {
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-24*3600];
        NSString *yesterdayString = [fomatter stringFromDate:yesterday];
        if ([dateString isEqualToString:[[yesterdayString componentsSeparatedByString:@" "] firstObject]]) {
            return @"昨天";
        } else {
            return [NSString stringWithFormat:@"%@.%@",@([ZXTimeHelper month:date]),@([ZXTimeHelper day:date])];
        }
    }
}

@end
