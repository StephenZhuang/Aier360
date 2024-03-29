//
//  ZXAddTeacherGracefulViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddTeacherGracefulViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXUpDownLoadManager.h"
#import "ZXZipHelper.h"

@interface ZXAddTeacherGracefulViewController ()
@property (nonatomic , weak) IBOutlet UIButton *imageButton;
@property (nonatomic , weak) IBOutlet UITextField *nameTextField;
@property (nonatomic , weak) IBOutlet UITextField *infoTextField;
@property (nonatomic , strong) UIImage *image;
@end

@implementation ZXAddTeacherGracefulViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
    
    _imageButton.imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    _imageButton.clipsToBounds = YES;
    
    if (_teacher) {
        [_imageButton sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:_teacher.img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"btn_image_add"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _image = image;
        }];
        [_nameTextField setText:_teacher.name];
        [_infoTextField setText:_teacher.desinfo];
        self.title = @"编辑教师";
    } else {
        self.title = @"添加教师";
    }
}

- (void)submit
{
    if (!_image) {
        [MBProgressHUD showText:@"请添加照片" toView:self.view];
        return;
    }
    
    NSString *name = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *info = [_infoTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (name.length == 0 || info.length == 0) {
        [MBProgressHUD showText:@"请填写完整" toView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:nil];
    ZXSchool *school = [ZXUtils sharedInstance].currentSchool;
            
    //上传教师风采头像
    
    [ZXUpDownLoadManager uploadImage:_image completion:^(BOOL success, NSString *imageString) {
        if (success) {
            if (_teacher) {
                //修改
                [ZXTeacherCharisma updateTeacherCharismalWithStcid:_teacher.stcid stcImg:imageString stcname:name stcDesinfo:info block:^(BOOL success, NSString *img, NSError *error) {
                    if (success) {
                        [hud turnToSuccess:@""];
                        if (img.length > 0) {
                            [_teacher setImg:img];
                        }
                        [_teacher setName:name];
                        [_teacher setDesinfo:info];
                        if (_editBlock) {
                            _editBlock();
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } else {
                        
                        [hud turnToError:@"提交失败"];
                    }
                }];
            } else {
                //新增
                [ZXTeacherCharisma addTeacherCharismalWithSid:school.sid stcImg:imageString stcname:name stcDesinfo:info block:^(ZXBaseModel *baseModel, NSError *error) {
                    if (!baseModel || baseModel.s == 0) {
                        [hud turnToError:@"提交失败"];
                    } else {
                        [hud turnToSuccess:@""];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        } else {
            [hud turnToError:@"提交失败"];
        }
    }];
}

#pragma mark- textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)showActionSheet
{
    [self.view endEditing:YES];
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

- (void)showDeleteActionSheet:(NSInteger)index
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    actionSheet.tag = index;
    [actionSheet showInView:self.view];
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
        
        imagePickerController.allowsEditing = NO;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
//    else if (actionSheet.tag == 256) {
//        if (buttonIndex != 2) {
//            _receiver = _receiverArray[buttonIndex];
//            [self.tableView reloadData];
//            
//            ZXAppStateInfo *appstateinfo = [ZXUtils sharedInstance].currentAppStateInfo;
//            [ZXAnnouncement getSmsCountWithSid:appstateinfo.sid cid:appstateinfo.cid sendType:buttonIndex+1 block:^(NSInteger totalMessage , NSInteger mesCount, NSError *error) {
//                _people = totalMessage;
//                _mesLeft = mesCount;
//                [self tipLabelChangeText:totalMessage mesCount:mesCount];
//            }];
//        }
//    } else {
//        if (buttonIndex == 0) {
//            [_imageUrlArray removeObjectAtIndex:actionSheet.tag];
//            [_imageArray removeObjectAtIndex:actionSheet.tag];
//            [self.tableView reloadData];
//        }
//    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _image = image;
    [_imageButton setImage:image forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
