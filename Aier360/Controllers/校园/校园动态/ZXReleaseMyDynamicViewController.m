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
#import "ZXSquareLabel+CoreDataProperties.h"
#import "ZXWhoCanSeeViewController.h"

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
        self.title = @"分享动态";
        if (_dynamic.original == 1) {            
            [self.contentTextView setText:[NSString stringWithFormat:@"//%@:%@",_dynamic.user.nickname,_dynamic.content]];
            self.contentTextView.selectedRange = NSMakeRange(0 ,0);
            [self.contentTextView becomeFirstResponder];
        }
    }
    self.contentTextView.placeholder = @"分享宝宝身上发生的趣事…";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)releaseAction
{
    [self.view endEditing:YES];
    NSString *content = self.contentTextView.text;
    for (ZXSquareLabel *squareLabel in self.squareLabelArray) {
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"#%@#",squareLabel.name] withString:@""];
    }
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0 || content.length > self.maxLetter) {
        return;
    }
    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (UIImage *image in self.imageArray) {
//        ZXFile *file = [[ZXFile alloc] init];
//        NSInteger index = [self.imageArray indexOfObject:image];
//        NSString *name = [NSString stringWithFormat:@"image%@.jpg",@(index)];
//        file.path = [ZXZipHelper saveImage:image withName:name];
//        file.name = @"file";
//        file.fileName = name;
//        [array addObject:file];
//    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"发布中" toView:self.view];
    
    [ZXUpDownLoadManager uploadImagesWithImageArray:self.imageArray completion:^(BOOL success, NSString *imagesString) {
        if (success) {
            long relativeid = 0;
            if (_isRepost) {
                relativeid = _dynamic.original==1?_dynamic.dynamic.did:_dynamic.did;
            }
            NSMutableArray *oslidArray = [[NSMutableArray alloc] init];
            for (ZXSquareLabel *squareLabel in self.squareLabelArray) {
                [oslidArray addObject:[NSString stringWithFormat:@"%@",@(squareLabel.id)]];
            }
            NSString *oslids = [oslidArray componentsJoinedByString:@","];
            [ZXPersonalDynamic addDynamicWithUid:GLOBAL_UID content:content img:imagesString relativeid:relativeid authority:self.selectedIndex+1 oslids:oslids address:self.address lat:self.lat lng:self.lng  block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [hud turnToSuccess:@""];
                    [super releaseAction];
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
    [cell.hasNewLabel setText:[NSString stringWithFormat:@"       %@",self.contents[self.selectedIndex]]];
    [cell.itemImage setImage:[UIImage imageNamed:self.imageNames[self.selectedIndex]]];
    cell.hasNewLabel.layer.borderColor = [UIColor colorWithRed:232/255.0 green:229/255.0 blue:226/255.0 alpha:1.0].CGColor;
    cell.hasNewLabel.layer.borderWidth = 1;
}

- (void)selectCellWithIndexPath:(NSIndexPath *)indexPath
{
    [super selectCellWithIndexPath:indexPath];
    __weak __typeof(&*self)weakSelf = self;
    ZXWhoCanSeeViewController *vc = [ZXWhoCanSeeViewController viewControllerFromStoryboard];
    vc.whocanseeBlock = ^(NSInteger index) {
        weakSelf.selectedIndex = index;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
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

- (NSArray *)imageNames
{
    if (!_imageNames) {
        _imageNames = @[@"dynamic_ic_whocansee",@"dynamic_ic_friendcansee",@"dynamic_ic_myselfcansee"];
    }
    return _imageNames;
}
@end
