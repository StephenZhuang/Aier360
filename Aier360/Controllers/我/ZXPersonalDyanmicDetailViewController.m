//
//  ZXPersonalDyanmicDetailViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPersonalDyanmicDetailViewController.h"
#import "ZXUser+ZXclient.h"
#import "ZXDynamic+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXDynamicDetailView.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import "ZXFavourCell.h"
#import "ZXFavourListViewController.h"
#import "ZXReleaseMyDynamicViewController.h"
#import "ZXCommentCell.h"
#import "UIViewController+ZXPhotoBrowser.h"
#import "ZXPopMenu.h"
#import "ZXCollection+ZXclient.h"
#import "ZXMyProfileViewController.h"
#import "ZXUserProfileViewController.h"
#import "NSManagedObject+ZXRecord.h"
#import "ZXManagedUser.h"
#import "ZXUserProfileViewController.h"
#import "ZXMyProfileViewController.h"
#import "ZXCommentViewController.h"
#import "ZXShareMenuViewController.h"
#import "WXApi.h"
#import "ZXReportViewController.h"
#import "ZXSquareDynamicsViewController.h"

@interface ZXPersonalDyanmicDetailViewController ()
{
    long dcid;
    NSString *rname;
    long touid;
    NSInteger totalPraised;
    NSInteger browseCount;
}
@end

@implementation ZXPersonalDyanmicDetailViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXPersonalDyanmicDetailViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"详情";
    touid = self.dynamic.uid;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dynamic_bt_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
    self.navigationItem.rightBarButtonItem = item;
    
    if (_needShowComment && self.dynamic) {
        [self showCommentVC];
    }
    if (_isCachedDynamic) {
        self.favButton.selected = self.dynamic.hasParise == 1;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (IBAction)moreAction:(id)sender
{
    if (self.dynamic) {
        
        NSMutableArray *contents = [[NSMutableArray alloc] init];

        if (self.dynamic.hasCollection == 1) {
            [contents addObject:@"取消收藏"];
        } else {
            [contents addObject:@"收藏"];
        }
        if (self.dynamic.uid != GLOBAL_UID) {
            [contents addObject:@"举报"];
        }
        __weak __typeof(&*self)weakSelf = self;
        ZXPopMenu *menu = [[ZXPopMenu alloc] initWithContents:contents targetFrame:CGRectMake(0, 0, self.view.frame.size.width - 15, 64)];
        menu.ZXPopPickerBlock = ^(NSInteger index) {
            NSString *string = [contents objectAtIndex:index];
            if ([string isEqualToString:@"举报"]) {
                ZXReportViewController *vc = [ZXReportViewController viewControllerFromStoryboard];
                vc.did = self.dynamic.did;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                BOOL isAdd = weakSelf.dynamic.hasCollection==0;
                if (_isCachedDynamic) {
                    [weakSelf.dynamic save];
                }
                [ZXCollection collectWithUid:GLOBAL_UID did:_did isAdd:isAdd block:^(BOOL success, NSString *errorInfo) {
                    if (success) {
                        if (isAdd) {
                            weakSelf.dynamic.hasCollection = 1;
                            [MBProgressHUD showText:@"收藏成功" toView:self.view];
                        } else {
                            weakSelf.dynamic.hasCollection = 0;
                            [MBProgressHUD showText:@"取消收藏成功" toView:self.view];
                        }
                        if (_isCachedDynamic) {
                            [weakSelf.dynamic save];
                        }
                    } else {
                        [MBProgressHUD showText:errorInfo toView:self.view];
                    }
                }];
            }
        };
        [self.navigationController.view addSubview:menu];
    }
}

- (IBAction)deleteAction:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [ZXPersonalDynamic deleteDynamicWithDid:_did type:self.dynamic.type block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [hud turnToSuccess:@""];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
}

- (void)loadData
{
    if (page == 1) {
        [ZXUser getPrasedUserWithDid:_did limitNumber:5 block:^(NSArray *array, NSInteger total, NSError *error) {
            [self.prasedUserArray removeAllObjects];
            [self.prasedUserArray addObjectsFromArray:array];
            totalPraised = total;
            [self.tableView reloadData];
        }];
        
        [ZXDynamic getBrowseCountWithDid:_did block:^(NSInteger bcount) {
            browseCount = bcount;
            [self.tableView reloadData];
        }];
        
        if (!self.dynamic) {
            [ZXPersonalDynamic getPersonalDynamicDetailWithUid:GLOBAL_UID did:_did block:^(ZXPersonalDynamic *dynamic, NSError *error) {
                if (dynamic) {
                    self.dynamic = dynamic;
                    touid = dynamic.uid;
                    self.favButton.selected = self.dynamic.hasParise == 1;
                    [self.tableView reloadData];
                } else {
                    [MBProgressHUD showText:@"动态已经不存在" toView:self.view];
                }
            }];
        }
    }
    
    [ZXDynamic getDynamicCommentListWithDid:_did page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (IBAction)commentAction:(id)sender
{
    if (self.dynamic) {
        [self showCommentVC];
    }
    
}

- (void)showCommentVC
{
//    __weak __typeof(&*self)weakSelf = self;
    ZXCommentViewController *vc = [ZXCommentViewController viewControllerFromStoryboard];
    vc.type = self.dynamic.type;
    vc.did = self.dynamic.did;
    vc.commentBlock = ^(void) {
//        weakSelf.dynamic.ccount++;
//        [weakSelf.dynamic save];
    };
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
}

- (void)showReplyVC
{
//    __weak __typeof(&*self)weakSelf = self;
    ZXCommentViewController *vc = [ZXCommentViewController viewControllerFromStoryboard];
    vc.type = self.dynamic.type;
    vc.did = self.dynamic.did;
    vc.isReply = YES;
    vc.touid = touid;
    vc.rname = rname;
    vc.dcid = dcid;
    vc.commentBlock = ^(void) {
//        weakSelf.dynamic.ccount++;
//        [weakSelf.dynamic save];
    };
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dynamic) {
        if (section == 3) {
            return self.dataArray.count;
        }
        return 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.dynamic) {
            return [tableView fd_heightForCellWithIdentifier:@"ZXDynamicDetailView" configuration:^(ZXDynamicDetailView *cell) {
                [cell configureWithDynamic:self.dynamic];
            }];
        } else {
            return 0;
        }
    } else if (indexPath.section == 1 || indexPath.section == 2) {
        return 40;
    } else {
        ZXDynamicComment *dynamicComment = [self.dataArray objectAtIndex:indexPath.row];
        return [tableView fd_heightForCellWithIdentifier:@"ZXCommentCell" configuration:^(ZXCommentCell *cell) {
            [cell setDynamicComment:dynamicComment];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXDynamicDetailView *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXDynamicDetailView"];
        if (self.dynamic) {
            __weak __typeof(&*self)weakSelf = self;
            [cell configureWithDynamic:self.dynamic];
            cell.imageClickBlock = ^(NSInteger index) {
                NSString *img = weakSelf.dynamic.original==1?weakSelf.dynamic.dynamic.img:weakSelf.dynamic.img;
                NSArray *array = [img componentsSeparatedByString:@","];
                [weakSelf browseImage:array index:index];
            };
            cell.headClickBlock = ^(void) {
                ZXManagedUser *user = weakSelf.dynamic.user;
                if (user.uid == GLOBAL_UID) {
                    [weakSelf.view endEditing:YES];
                    ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } else {
                    [weakSelf.view endEditing:YES];
                    ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
                    vc.uid = user.uid;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            };
            cell.repostClickBlock = ^(void) {
                if (weakSelf.dynamic.dynamic) {
                    [weakSelf.view endEditing:YES];
                    ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
                    vc.did = weakSelf.dynamic.dynamic.did;
                    vc.type = 2;
                    vc.dynamic = weakSelf.dynamic.dynamic;
                    vc.isCachedDynamic = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            };
            cell.squareLabelBlock = ^(NSInteger oslid) {
                ZXSquareDynamicsViewController *vc = [ZXSquareDynamicsViewController viewControllerFromStoryboard];
                vc.oslid = oslid;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"browseCell"];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@人浏览",@(browseCount)]];
        return cell;
    } else if (indexPath.section == 2) {
        ZXFavourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXFavourCell"];
        [cell configureCellWithUsers:self.prasedUserArray total:totalPraised];
        __weak __typeof(&*self)weakSelf = self;
        cell.userClickBlick = ^(long uid) {
            if (uid == GLOBAL_UID) {
                [weakSelf.view endEditing:YES];
                ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                [weakSelf.view endEditing:YES];
                ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
                vc.uid = uid;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    } else {
        __weak __typeof(&*self)weakSelf = self;
        ZXDynamicComment *dynamicComment = [self.dataArray objectAtIndex:indexPath.row];
        ZXCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCommentCell"];
        cell.dynamicComment = dynamicComment;
        cell.commentIcon.hidden = indexPath.row!=0;
        cell.userBlock = ^(long uid) {
            //进入个人主页
            if (uid == GLOBAL_UID) {
                [weakSelf.view endEditing:YES];
                ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                [weakSelf.view endEditing:YES];
                ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
                vc.uid = uid;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        cell.replyBlock = ^(ZXDynamicCommentReply *reply) {
            if (reply.uid == GLOBAL_UID) {
                [MBProgressHUD showText:@"不能回复自己" toView:self.view];
            } else {
                dcid = reply.dcid;
                rname = reply.nickname;
                touid = reply.uid;
                [weakSelf showReplyVC];
            }
        };
        
        BOOL hasSuperDeleteRule = NO;
        if (self.dynamic.type != 3) {
            if (HASIdentyty(ZXIdentitySchoolMaster) || (self.dynamic.type == 2 && HASIdentytyWithCid(ZXIdentityClassMaster, self.dynamic.cid))) {
                hasSuperDeleteRule = YES;
            }
        }
        cell.hasSuperDeleteRule = hasSuperDeleteRule;
        cell.deleteCommentBlock = ^(BOOL isComment,long relativeId) {
            if (isComment) {
                [ZXDynamic deleteCommentDynamicWithDcid:relativeId block:^(BOOL success, NSString *errorInfo) {
                    if (success) {
                        [MBProgressHUD showSuccess:@"" toView:self.view];
                        [weakSelf.tableView headerBeginRefreshing];
                    } else {
                        [MBProgressHUD showError:errorInfo toView:self.view];
                    }
                }];
            } else {
                [ZXDynamic deleteReplyWithDcrid:relativeId block:^(BOOL success, NSString *errorInfo) {
                    if (success) {
                        [MBProgressHUD showSuccess:@"" toView:self.view];
                        [weakSelf.tableView headerBeginRefreshing];
                    } else {
                        [MBProgressHUD showError:errorInfo toView:self.view];
                    }
                }];
            }
        };
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (self.prasedUserArray.count > 0) {
            [self.view endEditing:YES];
            ZXFavourListViewController *vc = [ZXFavourListViewController viewControllerFromStoryboard];
            vc.did = _did;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 3) {
        ZXDynamicComment *dynamicComment = [self.dataArray objectAtIndex:indexPath.row];
        if (dynamicComment.uid == GLOBAL_UID) {
            [MBProgressHUD showText:@"不能回复自己" toView:self.view];
        } else {
            dcid = dynamicComment.dcid;
            rname = dynamicComment.nickname;
            touid = dynamicComment.uid;
            [self showReplyVC];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - bottom action
- (IBAction)favAction:(UIButton *)sender
{
    if (self.dynamic) {
        if (sender.selected) {
            [MBProgressHUD showText:@"您已经喜欢过了~" toView:self.view];
        } else {
            self.dynamic.hasParise = 1;
            self.dynamic.pcount++;
            if (_isCachedDynamic) {
                [self.dynamic save];
            }
            sender.selected = YES;
            [ZXPersonalDynamic praiseDynamicWithUid:GLOBAL_UID did:self.dynamic.did type:self.dynamic.type block:^(BOOL success, NSString *errorInfo) {
                if (!success) {
                    self.dynamic.hasParise = 0;
                    self.dynamic.pcount = MAX(0, self.dynamic.pcount-1);
                    if (_isCachedDynamic) {
                        [self.dynamic save];
                    }
                    sender.selected = NO;
                    [MBProgressHUD showText:errorInfo toView:self.view];
                }
            }];
        }
    }
}

- (IBAction)shareAction:(id)sender
{
    if (self.dynamic) {
        __weak __typeof(&*self)weakSelf = self;
        ZXShareMenuViewController *vc = [ZXShareMenuViewController viewControllerFromStoryboard];
        vc.shareBlock = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf.view endEditing:YES];
                ZXReleaseMyDynamicViewController *vc = [ZXReleaseMyDynamicViewController viewControllerFromStoryboard];
                vc.isRepost = YES;
                vc.dynamic = weakSelf.dynamic;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                if (index == 0) {
                    req.scene = WXSceneSession;
                } else {
                    req.scene = WXSceneTimeline;
                }
                if (self.dynamic.img.length > 0) {
                    NSURL *imageUrl = [ZXImageUrlHelper imageUrlForSmall:[[self.dynamic.img componentsSeparatedByString:@","] firstObject]];
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imageUrl options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        req.bText = NO;
                        WXMediaMessage *message = [[WXMediaMessage alloc] init];
                        message.title = @"快来看我发现了什么！";
                        message.description = [NSString stringWithFormat:@"%@",self.dynamic.content];
                        message.thumbData = UIImageJPEGRepresentation(image, 0.8);
                        WXWebpageObject *webObject = [[WXWebpageObject alloc] init];
                        webObject.webpageUrl = [NSString stringWithFormat:@"%@share.shtml?did=%@",[ZXApiClient sharedClient].baseURL.absoluteString ,@(self.dynamic.did)];
                        message.mediaObject = webObject;
                        req.message = message;
                        BOOL sendSuccess = [WXApi sendReq:req];
                        if (!sendSuccess) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您没有安装微信" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }];
                    
                } else {
                    req.text = [NSString stringWithFormat:@"快来看我发现了什么！\n%@\n%@share.shtml?did=%@",self.dynamic.content,[ZXApiClient sharedClient].baseURL.absoluteString,@(self.dynamic.did)];
                    req.bText = YES;
                    BOOL sendSuccess = [WXApi sendReq:req];
                    if (!sendSuccess) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您没有安装微信" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                
            }
        };
        vc.view.frame = self.navigationController.view.bounds;
        [self.navigationController addChildViewController:vc];
        [self.navigationController.view addSubview:vc.view];
        [vc showMenu];
    }
}

#pragma -mark setters and getters
- (NSMutableArray *)prasedUserArray
{
    if (!_prasedUserArray) {
        _prasedUserArray = [[NSMutableArray alloc] init];
    }
    return _prasedUserArray;
}
@end
