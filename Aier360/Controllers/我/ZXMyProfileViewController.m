//
//  ZXMyProfileViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/14.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMyProfileViewController.h"
#import "ZXMenuCell.h"
#import "MagicalMacro.h"
#import "ZXUser+ZXclient.h"
#import "ZXProfileDynamicCell.h"
#import "ZXTimeHelper.h"
#import "ZXBabyShownCell.h"
#import "ZXMyInfoViewController.h"
#import "ZXProfileInfoCell.h"
#import "ZXBabyListViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXZipHelper.h"
#import "ZXUserDynamicListViewController.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>

@implementation ZXMyProfileViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXMyProfileViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dynamicCount = 0;
    self.headButton.layer.borderWidth = 2;
    self.headButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headButton.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.headButton.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.headButton.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    self.headButton.layer.shadowRadius = 2;//阴影半径，默认3
    [self updateUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)loadData
{
    [ZXUser getUserInfoAndBabyListWithUid:GLOBAL_UID fuid:GLOBAL_UID block:^(ZXUser *user, NSArray *array, BOOL isFriend, ZXDynamic *dynamic, NSInteger dynamicCount, NSError *error) {
        if (user) {
            _user = user;
        }
        _dynamic = dynamic;
        _dynamicCount = dynamicCount;
        _babyList = array?array:@[];
        [self updateUI];
    }];
}

- (void)updateUI
{
    [self.headButton sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:_user.headimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.nameLabel setText:_user.nickname];
    [self.tableView reloadData];
}

#pragma mark- tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 45;
        } else if (indexPath.row == 1) {
            if (_user.city.length == 0 && _user.desinfo.length == 0) {
                return 45;
            } else {
                return 115;
            }
        } else {
            if (_babyList.count > 0) {
                return _babyList.count * 20 + 25;
            } else {
                return 45;
            }
        }
    } else {
        return 90;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            [cell.titleLabel setText:@"爱儿号"];
            [cell.hasNewLabel setText:[ZXUtils sharedInstance].user.aier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        } else if (indexPath.row == 1) {
            if (_user.city.length == 0 && _user.desinfo.length == 0) {
                ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeholderCell"];
                [cell.titleLabel setText:@"个人资料"];
                [cell.hasNewLabel setText:@"赶快来完善自己的资料吧"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else {
                ZXProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXProfileInfoCell"];
                if ([_user.sex isEqualToString:@"男"]) {
                    [cell.sexButton setBackgroundImage:[UIImage imageNamed:@"mine_sexage_male"] forState:UIControlStateNormal];
                } else {
                    [cell.sexButton setBackgroundImage:[UIImage imageNamed:@"mine_sexage_female"] forState:UIControlStateNormal];
                }
                [cell.sexButton setTitle:[NSString stringWithIntger:[ZXTimeHelper ageFromBirthday:_user.birthday]] forState:UIControlStateNormal];
                NSString *imageName = [_user.industry stringByReplacingOccurrencesOfString:@"/" withString:@":"];
                [cell.logoImage setImage:[UIImage imageNamed:imageName]];
                [cell.loacationLabel setText:_user.city.length > 0?_user.city:@"不详"];
                [cell.titleLabel setText:_user.desinfo.length > 0?_user.desinfo:@"这个家伙很懒，什么都没留下"];
                
                return cell;
            }
        } else {
            if (_babyList.count > 0) {
                ZXBabyShownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXBabyShownCell"];
                cell.babyList = _babyList;
                return cell;
            } else {
                ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeholderCell"];
                [cell.titleLabel setText:@"宝宝资料"];
                [cell.hasNewLabel setText:@"您还没有添加宝宝"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }
    } else {
        ZXProfileDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicCell"];
        BOOL hasDynamic = (_dynamic!=nil);
        [cell.tipLabel setHidden:!hasDynamic];
        [cell.titleLabel setHidden:hasDynamic];
        [cell.timeLabel setHidden:!hasDynamic];
        if (_dynamic) {
            [cell.tipLabel setText:_dynamic.content];
            [cell.timeLabel setText:[ZXTimeHelper intervalSinceNow:_dynamic.cdate]];
            if (_dynamic.img.length > 0) {
                NSString *img = [[_dynamic.img componentsSeparatedByString:@","] firstObject];
                [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForFresh:img]];
                cell.logoImage.fd_collapsed = NO;
            } else {
                cell.logoImage.fd_collapsed = YES;
            }
        } else {
            
        }
        [cell.numLabel setText:[NSString stringWithFormat:@"%@",@(_dynamicCount)]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            ZXMyInfoViewController *vc = [ZXMyInfoViewController viewControllerFromStoryboard];
            vc.user = _user;
            vc.editSuccess = ^(void) {
                [ZXUtils sharedInstance].user = _user;
                [self updateUI];
                if (_changeLogoBlock) {
                    _changeLogoBlock();
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            ZXBabyListViewController *vc = [ZXBabyListViewController viewControllerFromStoryboard];
            vc.isMine = (_user.uid == GLOBAL_UID);
            vc.dataArray = [_babyList mutableCopy];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        ZXUserDynamicListViewController *vc = [ZXUserDynamicListViewController viewControllerFromStoryboard];
        vc.uid = GLOBAL_UID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- private
- (IBAction)changeLogo
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
    [_headButton setImage:image forState:UIControlStateNormal];
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:nil];
    
    [ZXUpDownLoadManager uploadImage:image completion:^(BOOL success, NSString *imageString) {
        //TODO: 上传头像接口
    }];
    
    NSURL *url = [NSURL URLWithString:@"userjs/userInfo_updateUserImgApp.shtml?" relativeToURL:[ZXApiClient sharedClient].baseURL];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *path = [ZXZipHelper saveImage:image withName:@"image0.png"];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            
            [parameters setObject:@"image0.png" forKey:@"photoName"];
            [parameters setObject:[NSNumber numberWithLong:GLOBAL_UID] forKey:@"uid"];
            
            //上传用户头像
            [ZXUpDownLoadManager uploadTaskWithUrl:url.absoluteString path:path parameters:parameters progress:nil name:@"file" fileName:@"image0.png" mimeType:@"application/octet-stream" completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
                if (error) {
                    [hud turnToError:@"提交失败"];
                } else {
                    NSString *img = [responseObject objectForKey:@"headimg"];
                    _user.headimg = img;
                    [ZXUtils sharedInstance].user = _user;
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
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}

@end
