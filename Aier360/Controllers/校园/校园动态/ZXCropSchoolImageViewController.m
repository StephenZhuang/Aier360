//
//  ZXCropSchoolImageViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/29.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCropSchoolImageViewController.h"
#import "MagicalMacro.h"
#import "ZXCropImageView.h"
#import "ZXSchool+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXUpDownLoadManager.h"
#import "ZXNotificationHelper.h"

#define Small_Proportion (190/750.0)
#define Big_Proportion (375/750.0)

@interface ZXCropSchoolImageViewController ()<UIScrollViewDelegate>

@end

@implementation ZXCropSchoolImageViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"School" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    
    [self.contentView addSubview:self.smallImageView];
    [self.contentView addSubview:self.bigImageView];
    [self.bigImageView setHidden:YES];
    
    
    self.alphaLayer = [CALayer layer];
    self.alphaLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7].CGColor;

    CGFloat height = self.big?SCREEN_WIDTH*Big_Proportion:SCREEN_WIDTH*Small_Proportion;
    self.alphaLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 52);
    [self.view.layer addSublayer:self.alphaLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-52)];
    
    
    // MARK: roundRectanglePath
    [path appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(0, (SCREEN_HEIGHT - height - 52) / 2, SCREEN_WIDTH, height)] bezierPathByReversingPath]];
    
    self.shapeLayer = [CAShapeLayer layer];
    
    self.shapeLayer.path = path.CGPath;
    self.shapeLayer.lineWidth = 2;
    self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.shapeLayer.lineCap = kCALineCapSquare;
        
    [self.alphaLayer setMask:self.shapeLayer];
}

- (IBAction)smallAcion:(id)sender
{
    if (self.big) {
        [self.smallButton setSelected:YES];
        [self.bigButton setSelected:NO];
        self.big = NO;
        [self.smallImageView setHidden:NO];
        [self.bigImageView setHidden:YES];
        [self changeMask];
    }
}

- (IBAction)bigAction:(id)sender
{
    if (!self.big) {
        [self.bigButton setSelected:YES];
        [self.smallButton setSelected:NO];
        self.big = YES;
        [self.smallImageView setHidden:YES];
        [self.bigImageView setHidden:NO];
        [self changeMask];
    }
}

- (void)changeMask
{
    CGFloat height = self.big?SCREEN_WIDTH*Big_Proportion:SCREEN_WIDTH*Small_Proportion;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-52)];

    // MARK: roundRectanglePath
    [path appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(0, (SCREEN_HEIGHT - height - 52) / 2, SCREEN_WIDTH, height)] bezierPathByReversingPath]];
    self.shapeLayer.path = path.CGPath;
    
}

- (IBAction)cancelAction:(id)sender
{
    [self hide];
}

- (IBAction)submitAction:(id)sender
{
    UIImage *bigImage = [self.bigImageView cropImage];
    UIImage *smallImage = [self.smallImageView cropImage];
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"上传中" toView:nil];
    
    dispatch_group_t group = dispatch_group_create();
    
    __block NSString *smallString = @"";
    __block NSString *bigString = @"";
    
    dispatch_group_enter(group);
    
    [ZXUpDownLoadManager uploadImage:smallImage completion:^(BOOL success, NSString *imageString) {
        if (success) {
            smallString = imageString;
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    
    [ZXUpDownLoadManager uploadImage:bigImage completion:^(BOOL success, NSString *imageString) {
        if (success) {
            bigString = imageString;
        }
        dispatch_group_leave(group);
    }];

    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (smallString.length > 0 && bigString.length > 0) {
            [ZXSchool updateSchoolImageWithSid:[ZXUtils sharedInstance].currentSchool.sid simg:smallString simgBig:bigString block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [hud turnToSuccess:@"上传成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:updateSchoolNotification
                                                                        object:nil];
                    [self hide];
                } else {
                    [hud turnToError:errorInfo];
                }
            }];
        } else {
            [hud turnToError:@"上传出错，请重试"];
        }
    });
}

- (void)hide
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setters and getters
- (ZXCropImageView *)smallImageView
{
    if (!_smallImageView) {
        _smallImageView = [[ZXCropImageView alloc] initWithImageUrl:self.imageUrl];
        _smallImageView.cropHeight = SCREEN_WIDTH*Small_Proportion;
    }
    return _smallImageView;
}

- (ZXCropImageView *)bigImageView
{
    if (!_bigImageView) {
        _bigImageView = [[ZXCropImageView alloc] initWithImageUrl:self.imageUrl];
        _bigImageView.cropHeight = SCREEN_WIDTH*Big_Proportion;
    }
    return _bigImageView;
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
