//
//  ZXMyDynamicViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/16.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMyDynamicViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXZipHelper.h"
#import "ZXUpDownLoadManager.h"
#import "ZXMailBoxViewController.h"
#import "ZXUserMailViewController.h"
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
#import "ZXMyInfoViewController.h"
#import "UIViewController+ZXPhotoBrowser.h"

@interface ZXMyDynamicViewController () {
    NSArray *babyList;
}
@property (nonatomic , weak) IBOutlet UIImageView *logoImage;
@property (nonatomic , weak) IBOutlet UIImageView *sexImage;
@property (nonatomic , weak) IBOutlet UILabel *memberLabel;
@property (nonatomic , weak) IBOutlet UILabel *addressLabel;
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@end

@implementation ZXMyDynamicViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXMyDynamicViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-44, 0, 0, 0)];
    _logoImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _logoImage.layer.borderWidth = 2;
    
    
//    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"school_message"] style:UIBarButtonItemStyleBordered target:self action:@selector(goToMessage)];
//    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_release"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreAction)];
//    self.navigationItem.rightBarButtonItems = @[more,message];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLogo)];
    [_logoImage addGestureRecognizer:tap];
    _logoImage.userInteractionEnabled = YES;
    
    _user = [ZXUtils sharedInstance].user;
    [self updateUI];
    
    [self getUserInfo];
}

- (void)getUserInfo
{
    [ZXUser getUserInfoAndBabyListWithUid:GLOBAL_UID in_uid:GLOBAL_UID block:^(ZXUser *user, NSArray *array, BOOL isFocus, NSError *error) {
        if (user) {            
            _user = user;
            [ZXUtils sharedInstance].user = _user;
            if (_changeLogoBlock) {
                _changeLogoBlock();
            }
            [self updateUI];
            babyList = array;
        }
    }];
}

- (void)updateUI
{
//    self.title = _user.nickname;
    [self.titleLabel setText:_user.nickname];
    [_logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:_user.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    NSDate *date = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthday = [formatter dateFromString:[[_user.birthday componentsSeparatedByString:@"T"] firstObject]];
    NSTimeInterval time = [date timeIntervalSinceDate:birthday];
    NSInteger age = (NSInteger)(time / (365.4 * 24 * 3600));
    [_memberLabel setText:[NSString stringWithIntger:age]];
    
    
    if ([_user.sex isEqualToString:@"女"]) {
        [_sexImage setImage:[UIImage imageNamed:@"user_sex_female"]];
    } else {
        [_sexImage setImage:[UIImage imageNamed:@"user_sex_male"]];
    }
    
//    [_addressLabel setText:_user.address];
}

 - (IBAction)goToMessage
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    ZXSchoolMessageListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ZXSchoolMessageListViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
 
 - (IBAction)moreAction
{
    ZXAddDynamicViewController *vc = [[UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXAddDynamicViewController"];
    vc.type = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeLogo
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"kong"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTranslucent:YES];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setHidden:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:26 green:30 blue:33]];
//    [self.navigationController.navigationBar setTranslucent:NO];
//    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXDynamic getDynamicListWithSid:appStateInfo.sid uid:GLOBAL_UID cid:appStateInfo.cid fuid:0 type:ZXDynamicListTypeUser page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
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
    __weak __typeof(&*self)weakSelf = self;
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
        return cell;
    }
    
    else if (indexPath.row > 0 && indexPath.row < commentInset) {
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
    vc.type = 3;
    vc.did = dynamic.did;
    vc.dynamic = dynamic;
    vc.deleteBlock = ^(void) {
        [weakSelf.dataArray removeObject:dynamic];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y > 64) {
//        if ([[self.navigationController viewControllers] lastObject] == self) {
//            [self.navigationController.navigationBar setHidden:YES];
//        }
//    } else {
//        [self.navigationController.navigationBar setHidden:NO];
//    }
//}

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

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:
                    // 取消
                    return;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_logoImage setImage:image];
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:nil];
    NSURL *url = [NSURL URLWithString:@"nxadminjs/image_updateUserHeadImg.shtml?" relativeToURL:[ZXApiClient sharedClient].baseURL];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *path = [ZXZipHelper saveImage:image withName:@"image0.png"];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            
            [parameters setObject:@"image0.png" forKey:@"photoName"];
            [parameters setObject:[NSNumber numberWithInt:GLOBAL_UID] forKey:@"uid"];
            
            //上传用户头像
            [ZXUpDownLoadManager uploadTaskWithUrl:url.absoluteString path:path parameters:parameters progress:nil name:@"file" fileName:@"image0.png" mimeType:@"application/octet-stream" completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
                if (error) {
                    [hud turnToError:@"提交失败"];
                } else {
                    NSString *img = [responseObject objectForKey:@"headimg"];
                    _user.headimg = img;
                    [ZXUtils sharedInstance].currentSchool.slogo = img;
                    if (_changeLogoBlock) {
                        _changeLogoBlock();
                    }
                    [hud turnToSuccess:@""];
                }
            }];
        });
    });
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

- (IBAction)infoAction:(id)sender
{
    if (babyList == nil) {
        
//        do {
//            sleep(1);
//        } while (babyList == nil);
        return;
    }
    
    [self performSegueWithIdentifier:@"info" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"info"]) {
//        ZXMyInfoViewController *vc = [segue destinationViewController];
//        vc.user = _user;
//        vc.babyList = babyList;
//        vc.editSuccess = ^(void) {
//            [self getUserInfo];
//        };
//    }
}
@end
