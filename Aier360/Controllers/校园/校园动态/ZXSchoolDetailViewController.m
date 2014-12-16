//
//  ZXSchoolDetailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/4.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolDetailViewController.h"
#import "ZXSchoolSummaryViewController.h"
#import "ZXTeacherGracefulViewController.h"
#import "ZXJoinChooseIdenty.h"
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

@interface ZXSchoolDetailViewController ()

@end

@implementation ZXSchoolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-64, 0, 0, 0)];
    _logoImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _logoImage.layer.borderWidth = 2;
    
    ZXAppStateInfo *stateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXSchool schoolInfoWithSid:stateInfo.sid block:^(ZXSchool *school, ZXSchoolDetail *schoolDetail, NSArray *array, NSError *error) {
        _school = school;
        _schoolDetail = schoolDetail;
        _teacherArray = array;
        self.title = _school.name;
        [_logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSchoolLogo:_school.slogo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [_memberLabel setText:[NSString stringWithFormat:@"成员:%i",_school.memberNum]];
        [_addressLabel setText:_school.address];
    }];
    
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"school_message"] style:UIBarButtonItemStyleBordered target:self action:@selector(goToMessage)];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItems = @[more,message];
    
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLogo)];
        [_logoImage addGestureRecognizer:tap];
        _logoImage.userInteractionEnabled = YES;
    }
}

- (void)goToMessage
{
    [self performSegueWithIdentifier:@"dynamic" sender:nil];
}

- (void)moreAction
{
    UIActionSheet *actionSheet;
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"加入学校",@"发布动态", nil];
        
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"加入学校", nil];
    }
    actionSheet.tag = 256;
    [actionSheet showInView:self.view];
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
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"kong"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:26 green:30 blue:33]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setHidden:NO];
}

- (IBAction)gotoMailbox:(id)sender
{
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster) {
        ZXMailBoxViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZXMailBoxViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZXUserMailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZXUserMailViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXDynamic getDynamicListWithSid:appStateInfo.sid uid:GLOBAL_UID cid:appStateInfo.cid fuid:0 type:ZXDynamicListTypeSchool page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
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
        if (CURRENT_IDENTITY == ZXIdentitySchoolMaster) {
            [cell.deleteButton setHidden:NO];
        } else {
            [cell.deleteButton setHidden:YES];
        }
        return cell;
    }
    
    else if (indexPath.row > 0 && indexPath.row < commentInset) {
        if (dynamic.original) {
            //转发
            ZXOriginDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXOriginDynamicCell"];
            [cell configureUIWithDynamic:dynamic.dynamic];
            if (!dynamic.dynamic) {
                [cell.titleLabel setText:@"抱歉，该条内容已被删除"];
            }
            return cell;
        } else {
            //图片
            ZXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImageCell"];
            NSArray *arr = [dynamic.img componentsSeparatedByString:@","];
            [cell setImageArray:arr];
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
    ZXDynamic *dynamic = self.dataArray[indexPath.section];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    ZXDynamicDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ZXDynamicDetailViewController"];
    vc.type = 1;
    vc.dynamic = dynamic;
    vc.deleteBlock = ^(void) {
        [self.dataArray removeObject:dynamic];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 64) {
        if ([[self.navigationController viewControllers] lastObject] == self) {
            [self.navigationController.navigationBar setHidden:YES];
        }
    } else {
        [self.navigationController.navigationBar setHidden:NO];
    }
}

#pragma -mark button action
- (IBAction)deleteAction:(UIButton *)sender
{
    ZXDynamic *dynamic = self.dataArray[sender.tag];
    [self.dataArray removeObject:dynamic];
    [self.tableView reloadData];
    [ZXDynamic deleteDynamicWithDid:dynamic.did block:^(BOOL success, NSString *errorInfo) {
        if (!success) {
            [MBProgressHUD showError:@"操作失败" toView:self.view];
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
    
    [ZXDynamic praiseDynamicWithUid:GLOBAL_UID ptype:ptype did:dynamic.did block:^(BOOL success, NSString *errorInfo) {
        if (!success) {
            [MBProgressHUD showError:@"操作失败" toView:self.view];
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
    } else if (actionSheet.tag == 256) {
        switch (buttonIndex) {
            case 0:
            {
                ZXJoinChooseIdenty *vc = [[UIStoryboard storyboardWithName:@"School" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXJoinChooseIdenty"];
                vc.school = _school;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                ZXAddDynamicViewController *vc = [[UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXAddDynamicViewController"];
                vc.type = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_logoImage setImage:image];
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:nil];
    NSURL *url = [NSURL URLWithString:@"schooljs/sbinfo_updateSchoollogo.shtml?" relativeToURL:[ZXApiClient sharedClient].baseURL];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *path = [ZXZipHelper saveImage:image withName:@"image0.png"];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            
            [parameters setObject:@"image0.png" forKey:@"photoName"];
            [parameters setObject:[NSNumber numberWithInt:appStateInfo.sid] forKey:@"sid"];
            
            //上传学校头像
            [ZXUpDownLoadManager uploadTaskWithUrl:url.absoluteString path:path parameters:parameters progress:nil name:@"file" fileName:@"image0.png" mimeType:@"application/octet-stream" completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
                if (error) {
                    [hud turnToError:@"提交失败"];
                } else {
                    NSString *img = [responseObject objectForKey:@"slogo"];
                    _school.slogo = img;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"summary"]) {
        ZXSchoolSummaryViewController *vc = segue.destinationViewController;
        vc.schoolDetail = _schoolDetail;
    } else if ([segue.identifier isEqualToString:@"teacher"]) {
        ZXTeacherGracefulViewController *vc = segue.destinationViewController;
        vc.dataArray = [_teacherArray mutableCopy];
    }
}


@end
