//
//  ZXReleaseSchoolImageViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXReleaseSchoolImageViewController.h"
#import "ZXFile.h"
#import "ZXZipHelper.h"
#import "ZXUpDownLoadManager.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXSchoolImg+ZXclient.h"

@implementation ZXReleaseSchoolImageViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXReleaseSchoolImageViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"上传照片";
    [self.contentTextView setPlaceholder:@"添加照片描述"];
    [self.emojiButton setHidden:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)releaseAction
{
    [self.view endEditing:YES];
    NSString *content = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length > self.maxLetter) {
        return;
    }
    
    if (self.imageArray.count == 0) {
        [MBProgressHUD showText:@"请选择要发布的图片" toView:self.view];
        return;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (UIImage *image in self.imageArray) {
        ZXFile *file = [[ZXFile alloc] init];
        NSInteger index = [self.imageArray indexOfObject:image];
        NSString *name = [NSString stringWithFormat:@"image%@.jpg",@(index)];
        file.path = [ZXZipHelper saveImage:image withName:name];
        file.name = @"file";
        file.fileName = name;
        [array addObject:file];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"发布中" toView:self.view];
    
    [ZXUpDownLoadManager uploadImages:array type:3 completion:^(BOOL success, NSString *imagesString) {
        if (success) {
            [ZXSchoolImg addSchoolImageWithSid:[ZXUtils sharedInstance].currentSchool.sid simg:imagesString info:content block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [hud turnToSuccess:@""];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [hud turnToError:errorInfo];
                }
            }];
        } else {
            [hud turnToError:imagesString];
        }
    }];
}

- (NSInteger)maxLetter
{
    return 100;
}
@end
