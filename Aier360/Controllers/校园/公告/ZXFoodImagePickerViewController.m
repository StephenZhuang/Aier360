//
//  ZXFoodImagePickerViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/27.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFoodImagePickerViewController.h"
#import "ZXImagePickCell.h"

@implementation ZXFoodImagePickerViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.imageArray = [[NSMutableArray alloc] init];
    [self.pickView setHidden:YES];
    self.pickView.transform = CGAffineTransformTranslate(self.pickView.transform, 0, CGRectGetHeight(self.pickView.frame));
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self show];
//}

- (void)showOnViewControlelr:(UIViewController *)viewController
{
    [viewController addChildViewController:self];
    self.view.frame = viewController.view.bounds;
    [viewController.view addSubview:self.view];
    [self show];
}

- (void)show
{
    [self.pickView setHidden:NO];
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.pickView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.pickView.transform = CGAffineTransformTranslate(self.pickView.transform, 0, CGRectGetHeight(self.pickView.frame));
    } completion:^(BOOL isFinished) {
        [self.pickView setHidden:YES];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)cancelAction:(id)sender
{
    [self hide];
}

- (IBAction)doneAction:(id)sender
{
    [self hide];
}

- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    CGFloat height = 44 + [ZXImagePickCell heightByImageArray:imageArray];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZXImagePickCell heightByImageArray:_imageArray];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXImagePickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImagePickCell"];
    [cell setImageArray:_imageArray];
    cell.clickBlock = ^(NSIndexPath *indexPath) {
        [self.view endEditing:YES];
        if (indexPath.row == _imageArray.count) {
//                [self showActionSheet];
        } else {
//                [self showDeleteActionSheet:indexPath.row];
        }
    };
    return cell;
}
@end
