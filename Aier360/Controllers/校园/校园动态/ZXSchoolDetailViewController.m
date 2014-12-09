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

@interface ZXSchoolDetailViewController ()

@end

@implementation ZXSchoolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-64, 0, 0, 0)];
    ZXAppStateInfo *stateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXSchool schoolInfoWithSid:stateInfo.sid block:^(ZXSchool *school, ZXSchoolDetail *schoolDetail, NSArray *array, NSError *error) {
        _school = school;
        _schoolDetail = schoolDetail;
        _teacherArray = array;
        self.title = _school.name;
        [_logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSchoolLogo:_school.slogo]];
        [_memberLabel setText:[NSString stringWithFormat:@"成员:%i",_school.memberNum]];
        [_addressLabel setText:_school.address];
    }];
    
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"school_message"] style:UIBarButtonItemStyleBordered target:self action:@selector(goToMessage)];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItems = @[more,message];
    
    if (CURRENT_IDENTITY(ZXIdentitySchoolMaster)) {
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
    ZXJoinChooseIdenty *vc = [[UIStoryboard storyboardWithName:@"School" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXJoinChooseIdenty"];
    vc.school = _school;
    [self.navigationController pushViewController:vc animated:YES];
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
