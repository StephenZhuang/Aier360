//
//  ZXReleaseMyDynamicViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/25.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXReleaseMyDynamicViewController.h"
#import "ZXMenuCell.h"
#import "ZXPopPicker.h"
#import "ZXFile.h"
#import "ZXZipHelper.h"
#import "ZXUpDownLoadManager.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXManagedUser.h"

@interface ZXReleaseMyDynamicViewController ()
@property (nonatomic , assign) NSInteger selectedIndex;
@property (nonatomic , strong) NSArray *contents;

@end

@implementation ZXReleaseMyDynamicViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXReleaseMyDynamicViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_isRepost) {
        self.title = @"转发";
        if (_dynamic.original == 1) {            
            [self.contentTextView setText:[NSString stringWithFormat:@"//%@:%@",_dynamic.user.nickname,_dynamic.content]];
            self.contentTextView.selectedRange = NSMakeRange(0 ,0);
            [self.contentTextView becomeFirstResponder];
        }
    }
}

- (void)releaseAction
{
    [self.view endEditing:YES];
    NSString *content = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0 || content.length > self.maxLetter) {
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
    
    [ZXUpDownLoadManager uploadImages:array type:1 completion:^(BOOL success, NSString *imagesString) {
        if (success) {
            long relativeid = 0;
            if (_isRepost) {
                relativeid = _dynamic.original==1?_dynamic.dynamic.did:_dynamic.did;
            }
            
            [ZXPersonalDynamic addDynamicWithUid:GLOBAL_UID content:content img:imagesString relativeid:relativeid authority:self.selectedIndex+1 block:^(BOOL success, NSString *errorInfo) {
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


- (void)confiureCell:(ZXMenuCell *)cell
{
    [cell.titleLabel setText:@"谁可以看"];
    [cell.hasNewLabel setText:self.contents[self.selectedIndex]];
}

- (void)selectCellWithIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(&*self)weakSelf = self;
    ZXPopPicker *popPicker = [[ZXPopPicker alloc] initWithTitle:@"添加微信好友" contents:self.contents];
    popPicker.ZXPopPickerBlock = ^(NSInteger selectedIndex) {
        weakSelf.selectedIndex = selectedIndex;
        [self.tableView reloadData];
    };
    [self.navigationController.view addSubview:popPicker];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isRepost && section == 0) {
        return 0;
    }
    return 1;
}

#pragma mark- setters and getters

- (NSArray *)contents
{
    if (!_contents) {
        _contents = @[@"所有人可见",@"仅好友可见",@"仅自己可见"];
    }
    return _contents;
}
@end
