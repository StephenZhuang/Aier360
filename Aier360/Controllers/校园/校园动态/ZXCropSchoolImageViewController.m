//
//  ZXCropSchoolImageViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/29.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCropSchoolImageViewController.h"
#import "MagicalMacro.h"

#define Small_Proportion (190/750.0)
#define Big_Proportion (375/750.0)

@interface ZXCropSchoolImageViewController ()

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
    
    [self.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForOrigin:self.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.imageHeight.constant = image.size.height * SCREEN_WIDTH / image.size.width;
        
        self.alphaLayer = [CALayer layer];
        self.alphaLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7].CGColor;

        CGFloat height = self.big?SCREEN_WIDTH*Big_Proportion:SCREEN_WIDTH*Small_Proportion;
        self.alphaLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.imageHeight.constant);
        [self.imageView.layer addSublayer:self.alphaLayer];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        // MARK: circlePath
//        [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH / 2, 200) radius:100 startAngle:0 endAngle:2*M_PI clockwise:NO]];
        
        // MARK: roundRectanglePath
        [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, (self.imageHeight.constant - height) / 2, SCREEN_WIDTH, height) cornerRadius:0] bezierPathByReversingPath]];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.path = path.CGPath;
        shapeLayer.borderWidth = 1;
        shapeLayer.borderColor = [UIColor whiteColor].CGColor;
        
        [self.alphaLayer setMask:shapeLayer];
    }];
}

- (IBAction)smallAcion:(id)sender
{
    if (self.big) {
        [self.smallButton setSelected:YES];
        [self.bigButton setSelected:NO];
        self.big = NO;
        [self changeMask];
    }
}

- (IBAction)bigAction:(id)sender
{
    if (!self.big) {
        [self.bigButton setSelected:YES];
        [self.smallButton setSelected:NO];
        self.big = YES;
        [self changeMask];
    }
}

- (void)changeMask
{
//    CGFloat height = self.big?SCREEN_WIDTH*Big_Proportion:SCREEN_WIDTH*Small_Proportion;
//    
//    self.mask.frame = CGRectMake(0, (self.imageHeight.constant - height) / 2, SCREEN_WIDTH, height);
}

- (IBAction)cancelAction:(id)sender
{
    [self hide];
}

- (IBAction)submitAction:(id)sender
{
    [self hide];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
