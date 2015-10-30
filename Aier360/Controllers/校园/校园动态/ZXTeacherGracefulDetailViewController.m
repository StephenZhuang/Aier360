//
//  ZXTeacherGracefulDetailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/8.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherGracefulDetailViewController.h"
#import "MagicalMacro.h"
#import "ZXAddTeacherGracefulViewController.h"
#import "ZXPopMenu.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "UIViewController+ZXPhotoBrowser.h"

@interface ZXTeacherGracefulDetailViewController ()
@property (nonatomic , weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *imageHeight;
@end

@implementation ZXTeacherGracefulDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
    
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dynamic_bt_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browse)];
    [self.photoImageView addGestureRecognizer:tap];
    self.photoImageView.userInteractionEnabled = YES;
}

- (void)browse
{
    [self browseImage:@[_teacher.img] index:0];
}

- (void)moreAction
{
    NSArray *contents = @[@"编辑",@"删除"];
    __weak __typeof(&*self)weakSelf = self;
    ZXPopMenu *menu = [[ZXPopMenu alloc] initWithContents:contents targetFrame:CGRectMake(0, 0, self.view.frame.size.width - 15, 64)];
    menu.ZXPopPickerBlock = ^(NSInteger index) {
        if (index == 0) {
            [weakSelf editTeacher];
        } else {
            [weakSelf deleteTeacher];
        }
    };
    [self.navigationController.view addSubview:menu];
}

- (void)editTeacher
{
    [self performSegueWithIdentifier:@"edit" sender:nil];
}

- (void)deleteTeacher
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [ZXTeacherCharisma deleteTeacherCharismalWithStcid:_teacher.stcid block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [hud turnToSuccess:@""];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
}

- (void)configureUI
{
    self.title = _teacher.name;
    [_contentLabel setText:_teacher.desinfo];
    [_photoImageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForOrigin:_teacher.img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGFloat height = 0;
        if (image) {
            height = (SCREEN_WIDTH - 16) * image.size.height / image.size.width;
        }
        [UIView animateWithDuration:0.25 animations:^{
            _imageHeight.constant = height;
            [self updateViewConstraints];
        }];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;
    if ([segue.identifier isEqualToString:@"edit"]) {
        ZXAddTeacherGracefulViewController *vc = [segue destinationViewController];
        vc.teacher = _teacher;
        vc.editBlock = ^(void) {
            [weakSelf configureUI];
        };
    }
}

@end
