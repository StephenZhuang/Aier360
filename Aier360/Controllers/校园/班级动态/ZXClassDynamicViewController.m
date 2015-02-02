//
//  ZXClassDynamicViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/15.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClassDynamicViewController.h"
#import "ZXJoinChooseIdenty.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXDynamic+ZXclient.h"
#import "ZXDynamicToolCell.h"
#import "ZXSChoolDynamicCell.h"
#import "ZXMailCommentCell.h"
#import "ZXImageCell.h"
#import "ZXOriginDynamicCell.h"
#import "ZXAddDynamicViewController.h"
#import "ZXRepostViewController.h"
#import "ZXRepostActionSheet.h"
#import "ZXDynamicDetailViewController.h"
#import "ZXSchoolMessageListViewController.h"
#import "UIViewController+ZXPhotoBrowser.h"

@interface ZXClassDynamicViewController ()

@end

@implementation ZXClassDynamicViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Class" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXClassDynamicViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_type == 3) {
        self.title = @"好友动态";
    } else if (_type == 2) {
        self.title = @"班级动态";
    }
    
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"school_message"] style:UIBarButtonItemStyleBordered target:self action:@selector(goToMessage)];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_release"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItems = @[more,message];
}

- (void)goToMessage
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    ZXSchoolMessageListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ZXSchoolMessageListViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreAction
{
    ZXAddDynamicViewController *vc = [[UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXAddDynamicViewController"];
    vc.type = _type;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    
    if (_type == 2) {
        [ZXDynamic getDynamicListWithSid:appStateInfo.sid uid:GLOBAL_UID cid:appStateInfo.cid fuid:0 type:ZXDynamicListTypeClass page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
            [self configureArray:array];
        }];
    } else if (_type == 3) {
        [ZXDynamic getDynamicListWithSid:appStateInfo.sid uid:GLOBAL_UID cid:appStateInfo.cid fuid:GLOBAL_UID type:ZXDynamicListTypeFriend page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
            [self configureArray:array];
        }];
    }
}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZXDynamic *dynamic = [self.dataArray objectAtIndex:section];
    NSInteger commentCount = dynamic.ccount;
    if (commentCount > 2) {
        commentCount = 3;
    }
    if (dynamic.original) {
        //转发
        return 3 + commentCount;
    } else {
        //原创
        if (dynamic.img.length > 0) {
            return 3 + commentCount;
        } else {
            return 2 + commentCount;
        }
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section];
    NSInteger commentInset = 2;
    NSInteger commentCount = dynamic.ccount;
    if (commentCount > 2) {
        commentCount = 3;
    }
    if (!dynamic.original && dynamic.img.length == 0) {
        commentInset = 1;
    }
    if (indexPath.row == 0) {
        return [ZXSchoolDynamicCell heightByText:dynamic.content];
    }
    
    else if (indexPath.row > 0 && indexPath.row < commentInset) {
        if (dynamic.original) {
            //转发
            return [ZXOriginDynamicCell heightByDynamic:dynamic.dynamic];
        } else {
            //图片
            NSArray *arr = [dynamic.img componentsSeparatedByString:@","];
            return [ZXImageCell heightByImageArray:arr];
        }
    }
    
    else if (indexPath.row >= commentInset && indexPath.row < commentInset+ commentCount) {
        //评论
        NSString *emojiText = @"";
        if (commentCount == 3) {
            if (indexPath.row == commentInset) {
                emojiText = [NSString stringWithFormat:@"查看所有%i条评论",dynamic.ccount];
            } else {
                ZXDynamicComment *dynamicComment = [dynamic.dcList objectAtIndex:(indexPath.row - commentInset - 1)];
                emojiText = [NSString stringWithFormat:@"%@:%@",dynamicComment.nickname , dynamicComment.content];
            }
        } else {
            ZXDynamicComment *dynamicComment = [dynamic.dcList objectAtIndex:(indexPath.row - commentInset)];
            emojiText = [NSString stringWithFormat:@"%@:%@",dynamicComment.nickname , dynamicComment.content];
        }
        return [ZXMailCommentCell heightByText:emojiText];
    }
    else {
        //工具栏
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section];
    NSInteger commentCount = dynamic.ccount;
    if (commentCount > 2) {
        commentCount = 3;
    }
    NSInteger commentInset = 2;
    if (!dynamic.original && dynamic.img.length == 0) {
        commentInset = 1;
    }
    if (indexPath.row == 0) {
        //头
        ZXSchoolDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXSchoolDynamicCell"];
        [cell configureUIWithDynamic:dynamic indexPath:indexPath];
        if (CURRENT_IDENTITY == ZXIdentityClassMaster && _type == 2) {
            [cell.deleteButton setHidden:NO];
        } else {
            [cell.deleteButton setHidden:YES];
            [cell removeDeleteButton];
        }
        return cell;
    }
    
    else if (indexPath.row > 0 && indexPath.row < commentInset) {
        __weak __typeof(&*self)weakSelf = self;
        if (dynamic.original) {
            //转发
            ZXOriginDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXOriginDynamicCell"];
            [cell configureUIWithDynamic:dynamic.dynamic];
            
            if (!dynamic.dynamic) {
                [cell.titleLabel setText:@"抱歉，该条内容已被删除"];
            } else {
                if (dynamic.dynamic.img.length > 0) {
                    __block NSArray *arr = [dynamic.dynamic.img componentsSeparatedByString:@","];
                    cell.imageClickBlock = ^(NSInteger index) {
                        [weakSelf browseImage:arr type:ZXImageTypeFresh index:index];
                    };
                }
            }
            return cell;
        } else {
            //图片
            ZXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImageCell"];
            __block NSArray *arr = [dynamic.img componentsSeparatedByString:@","];
            cell.type = ZXImageTypeFresh;
            [cell setImageArray:arr];
            cell.imageClickBlock = ^(NSInteger index) {
                [weakSelf browseImage:arr type:ZXImageTypeFresh index:index];
            };
            return cell;
        }
    }
    
    else if (indexPath.row >= commentInset && indexPath.row < commentInset+ commentCount) {
        //评论
        ZXMailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMailCommentCell"];
        cell.emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        cell.emojiLabel.customEmojiPlistName = @"expressionImage";
        [cell.emojiLabel setTextColor:[UIColor colorWithRed:102 green:199 blue:169]];
        if (commentCount == 3) {
            if (indexPath.row == commentInset) {
                [cell.logoImage setHidden:NO];
                [cell.emojiLabel setText:[NSString stringWithFormat:@"查看所有%i条评论",dynamic.ccount]];
            } else {
                [cell.logoImage setHidden:YES];
                ZXDynamicComment *dynamicComment = [dynamic.dcList objectAtIndex:(indexPath.row - commentInset - 1)];
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",dynamicComment.nickname] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:102 green:199 blue:169],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
                NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:dynamicComment.content attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:131 green:131 blue:132],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
                [string appendAttributedString:string2];
                [cell.emojiLabel setText:string];
            }
        } else {
            if (indexPath.row == commentInset) {
                [cell.logoImage setHidden:NO];
            } else {
                [cell.logoImage setHidden:YES];
            }
            ZXDynamicComment *dynamicComment = [dynamic.dcList objectAtIndex:(indexPath.row - commentInset)];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",dynamicComment.nickname] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:102 green:199 blue:169],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:dynamicComment.content attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:131 green:131 blue:132],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
            [string appendAttributedString:string2];
            [cell.emojiLabel setText:string];
        }
        return cell;
    }
    
    else {
    }
    //底部三个按钮
    ZXDynamicToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXDynamicToolCell"];
    [cell configureUIWithDynamic:dynamic indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(&*self)weakSelf = self;
    ZXDynamic *dynamic = self.dataArray[indexPath.section];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    ZXDynamicDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ZXDynamicDetailViewController"];
    vc.type = 2;
    vc.did = dynamic.did;
    vc.dynamic = dynamic;
    vc.deleteBlock = ^(void) {
        [weakSelf.dataArray removeObject:dynamic];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark button action
- (IBAction)deleteAction:(UIButton *)sender
{
    ZXDynamic *dynamic = self.dataArray[sender.tag];
    [self.dataArray removeObject:dynamic];
    [self.tableView reloadData];
    [ZXDynamic deleteDynamicWithDid:dynamic.did block:^(BOOL success, NSString *errorInfo) {
        if (!success) {
            [MBProgressHUD showError:ZXFailedString toView:self.view];
        }
    }];
}

- (IBAction)praiseAction:(UIButton *)sender
{
    ZXDynamic *dynamic = self.dataArray[sender.tag];
    sender.selected = !sender.selected;
    NSInteger ptype = 0;
    if (sender.selected) {
        ptype = 0;
        dynamic.pcount++;
    } else {
        ptype = 1;
        dynamic.pcount = MAX(0, dynamic.pcount - 1);
    }
    [sender setTitle:[NSString stringWithIntger:dynamic.pcount] forState:UIControlStateNormal];
    
    [ZXDynamic praiseDynamicWithUid:GLOBAL_UID ptype:ptype did:dynamic.did touid:dynamic.uid block:^(BOOL success, NSString *errorInfo) {
        if (!success) {
            [MBProgressHUD showError:ZXFailedString toView:self.view];
        }
    }];
}

- (IBAction)repostAction:(UIButton *)sender
{
    
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster) {
        [ZXRepostActionSheet showInView:self.view type:ZXIdentitySchoolMaster block:^(NSInteger index) {
            if (index == 0) {
                [self goToRepost:ZXDynamicListTypeUser index:sender.tag];
            } else {
                [self goToRepost:ZXDynamicListTypeSchool index:sender.tag];
            }
        }];
    } else if (CURRENT_IDENTITY == ZXIdentityClassMaster) {
        [ZXRepostActionSheet showInView:self.view type:ZXIdentityClassMaster block:^(NSInteger index) {
            if (index == 0) {
                [self goToRepost:ZXDynamicListTypeUser index:sender.tag];
            } else {
                [self goToRepost:ZXDynamicListTypeClass index:sender.tag];
            }
        }];
    } else {
        [self goToRepost:ZXDynamicListTypeUser index:sender.tag];
    }
    
    
    
}

- (void)goToRepost:(ZXDynamicListType)type index:(NSInteger)index
{
    ZXDynamic *dynamic = self.dataArray[index];
    if (dynamic.original) {
        if (!dynamic.dynamic) {
            [MBProgressHUD showError:@"原动态已被删除，不能转发" toView:self.view];
            return;
        }
    }
    ZXRepostViewController *vc = [[UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXRepostViewController"];
    vc.dynamic = dynamic;
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];
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
    
}

@end
