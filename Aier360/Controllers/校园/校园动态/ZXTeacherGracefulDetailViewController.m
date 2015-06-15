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

@interface ZXTeacherGracefulDetailViewController ()
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *imageHeight;
@end

@implementation ZXTeacherGracefulDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"教师风采";
    [self configureUI];
    
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTeacher)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)editTeacher
{
    [self performSegueWithIdentifier:@"edit" sender:nil];
}

- (void)configureUI
{
    [_nameLabel setText:_teacher.name];
    [_contentLabel setText:_teacher.desinfo];
    [_photoImageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:_teacher.img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
