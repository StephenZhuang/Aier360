//
//  ZXWhoCanSeeViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXWhoCanSeeViewController.h"

@implementation ZXWhoCanSeeViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dynamic" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXWhoCanSeeViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"谁可以看";
}

- (void)addHeader{}
- (void)addFooter{}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contents.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.imageView setImage:[UIImage imageNamed:self.imageNames[indexPath.row]]];
    [cell.textLabel setText:self.contents[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    !_whocanseeBlock?:_whocanseeBlock(indexPath.row);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setters and getters
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
