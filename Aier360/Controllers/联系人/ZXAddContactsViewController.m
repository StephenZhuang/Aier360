//
//  ZXAddContactsViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 14/12/29.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddContactsViewController.h"
#import "ZXUser+ZXclient.h"
#import "ZXContactsCell.h"
#import "ZXTimeHelper.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXQRCodeViewController.h"
#import "WXApi.h"
#import "ZXPopPicker.h"
#import "ZXQrcodeView.h"
#import "ZXContactsCell.h"
#import "ZXMyProfileViewController.h"
#import "ZXUserProfileViewController.h"
#import "ZXTimeHelper.h"
#import "MagicalMacro.h"
#import "UIScrollView+MJRefresh.h"

@implementation ZXAddContactsViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contacts" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXAddContactsViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加好友";
    [self.tableView setExtrueLineHidden];
    [self.searchDisplayController.searchResultsTableView setExtrueLineHidden];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    self.searchDisplayController.searchResultsTableView.tableHeaderView = view;
    
    page = 1;
    pageCount = 10;
    hasMore = YES;
    [self addFooter];
    
    _searchResultArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)addHeader
{
        if (!hasMore) {
            [self.searchDisplayController.searchResultsTableView setFooterHidden:NO];
        }
        page = 1;
        hasMore = YES;
        [self loadData];
}

- (void)addFooter
{
    [self.searchDisplayController.searchResultsTableView addFooterWithCallback:^{
        page ++;
        [self loadData];
    }];
}

- (void)loadData
{
    NSString *searchText = [self.searchDisplayController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchText.length > 0) {
        [ZXUser searchPeopleWithAierOrPhoneOrNickname:searchText page:page page_size:pageCount block:^(NSArray *array, NSError *error) {
            if (page == 1) {
                [self.searchResultArray removeAllObjects];
            }
            if (array) {
                [self.searchResultArray addObjectsFromArray:array];
                if (array.count < pageCount) {
                    hasMore = NO;
                    [self.searchDisplayController.searchResultsTableView setFooterHidden:YES];
                }
            } else {
                hasMore = NO;
                [self.searchDisplayController.searchResultsTableView setFooterHidden:YES];
            }
            [self.searchDisplayController.searchResultsTableView reloadData];
            if (page == 1) {
                if (array.count == 0) {
                    for(UIView *subview in self.searchDisplayController.searchResultsTableView.subviews) {
                        
                        if([subview isKindOfClass:[UILabel class]]) {
                            
                            [(UILabel*)subview setText:@"啊哦，没有找到这个人！"];
                            
                        }
                        
                    }
                }
            } else {
                [self.searchDisplayController.searchResultsTableView footerEndRefreshing];
            }
        }];
    } else {
        if (page == 1) {
            [self.searchResultArray removeAllObjects];
            [self.searchDisplayController.searchResultsTableView reloadData];
        } else {
            [self.searchDisplayController.searchResultsTableView footerEndRefreshing];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return 1;
        } else {
            return 3;
        }
    } else {
        return self.searchResultArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            return 60;
        } else {
            return 52;
        }
    } else {
        return 55;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            [cell.titleLabel setText:[NSString stringWithFormat:@"我的爱儿号：%@",[ZXUtils sharedInstance].user.aier]];
            return cell;
        } else {
            ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXBaseCell"];
            if (indexPath.row == 0) {
                [cell.titleLabel setText:@"扫一扫"];
                [cell.logoImage setImage:[UIImage imageNamed:@"contact_scan"]];
            } else if (indexPath.row == 1) {
                [cell.titleLabel setText:@"添加微信好友"];
                [cell.logoImage setImage:[UIImage imageNamed:@"contact_weixin"]];
            } else {
                [cell.titleLabel setText:@"添加通讯录好友"];
                [cell.logoImage setImage:[UIImage imageNamed:@"contact_address"]];
            }
            return cell;
        }
    } else {
        ZXContactsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXContactsCell"];
        ZXUser *user = [self.searchResultArray objectAtIndex:indexPath.row];
        [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [cell.titleLabel setText:user.nickname];
        NSArray *birthArray = [user.babyBirthdays componentsSeparatedByString:@","];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSString *birth in birthArray) {
            NSString *babyStr = [NSString stringWithFormat:@"宝宝%@",[ZXTimeHelper yearAndMonthSinceNow:birth]];
            [arr addObject:babyStr];
        }
        NSString *str = [arr componentsJoinedByString:@"&"];
        [cell.addressLabel setText:str];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            ZXQrcodeView *qrcodeView = [[ZXQrcodeView alloc] init];
            [self.navigationController.view addSubview:qrcodeView];
        } else {
            if (indexPath.row == 0) {
                if ([self.navigationController.viewControllers lastObject] == self) {
                    ZXQRCodeViewController *vc = [[ZXQRCodeViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else if (indexPath.row == 1) {
                __weak __typeof(&*self)weakSelf = self;
                NSArray *contents = @[@"微信好友",@"微信朋友圈"];
                ZXPopPicker *popPicker = [[ZXPopPicker alloc] initWithTitle:@"添加微信好友" contents:contents];
                popPicker.ZXPopPickerBlock = ^(NSInteger selectedIndex) {
                    [weakSelf sendTextContentWithIndex:selectedIndex];
                };
                [self.navigationController.view addSubview:popPicker];
            } else {
                [self performSegueWithIdentifier:@"addAbFriend" sender:nil];
            }
        }
    } else {
        ZXUser *user = [self.searchResultArray objectAtIndex:indexPath.row];
        if (user.uid == GLOBAL_UID) {
            ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
            vc.uid = user.uid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sendTextContentWithIndex:(NSInteger)index
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = [NSString stringWithFormat:@"我在爱儿邦，爱儿号%@，#免费的幼儿园家校沟通平台#，快来和我一起记录分享宝宝的成长吧！http://phone.aierbon.com",[ZXUtils sharedInstance].user.aier];
    req.bText = YES;
    if (index == 0) {
        req.scene = WXSceneSession;
    } else {
        req.scene = WXSceneTimeline;
    }
    
    BOOL sendSuccess = [WXApi sendReq:req];
    if (!sendSuccess) {
        [MBProgressHUD showError:@"您没有安装微信" toView:self.view];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self addHeader];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    for(UIView *subview in self.searchDisplayController.searchResultsTableView.subviews) {
        
        if([subview isKindOfClass:[UILabel class]]) {
            
            [(UILabel*)subview setText:@""];
            
        }
        
    }
    return YES;
}


@end
