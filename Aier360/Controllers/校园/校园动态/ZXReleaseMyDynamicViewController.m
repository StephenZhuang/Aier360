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

#pragma mark- setters and getters

- (NSArray *)contents
{
    if (!_contents) {
        _contents = @[@"所有人可见",@"仅好友可见",@"仅自己可见"];
    }
    return _contents;
}
@end
