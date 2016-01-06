//
//  ZXCropImageView.m
//  Aierbon
//
//  Created by Stephen Zhuang on 16/1/6.
//  Copyright © 2016年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCropImageView.h"
#import "MagicalMacro.h"

@interface ZXCropImageView ()
{
    CGPoint orginCenter;
}
@property (nonatomic , assign) CGFloat height;
@end

@implementation ZXCropImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithImageUrl:(NSString *)imageUrl
{
    self = [super init];
    if (self) {
        [self configureUIWithImageUrl:imageUrl];
    }
    return self;
}


- (void)configureUIWithImageUrl:(NSString *)imageUrl
{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForOrigin:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.height = image.size.height * SCREEN_WIDTH / image.size.width;
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        [self.imageView setFrame:rect];
        [self.scrollView setFrame:rect];
        [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.height)];
        [self setBounds:rect];
        
        [self setCenter:CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT - 52)/2)];
        self.clipsToBounds = NO;
        self.scrollView.clipsToBounds = NO;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
        self.userInteractionEnabled = YES;
    }];
}

#pragma mark - handle pan
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        orginCenter = self.center;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat centerY = (SCREEN_HEIGHT - 52)/2;
        
        CGPoint point = [pan translationInView:self];
        if (orginCenter.y+point.y + self.height/2 >= centerY + self.cropHeight/2 - 20 && orginCenter.y+point.y - self.height/2 <= centerY - self.cropHeight/2 - 20) {
            [self setCenter:CGPointMake(orginCenter.x, orginCenter.y+point.y)];
        }
    }
}

#pragma mark - crop image
- (UIImage *)cropImage
{
    CGFloat centerY = (SCREEN_HEIGHT - 52)/2;
    CGFloat deltaY = MAX(0, (centerY - self.cropHeight/2 - 20) - self.frame.origin.y);
    
    float zoomScale = 1.0 / [self.scrollView zoomScale];
    
    UIImage *image = self.imageView.image;
    
    CGRect rect;
    rect.origin.x = [self.scrollView contentOffset].x * zoomScale;
    rect.origin.y = ([self.scrollView contentOffset].y * zoomScale + deltaY) * image.size.height / self.height;
    rect.size.width = image.size.width * zoomScale;
    rect.size.height = self.cropHeight * image.size.height * zoomScale / self.height;

    CGImageRef cr = CGImageCreateWithImageInRect([[self.imageView image] CGImage], rect);
    
    UIImage *cropped = [UIImage imageWithCGImage:cr];
    
    CGImageRelease(cr);
    return cropped;
}

#pragma mark - scrollview delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - setters and getters
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.maximumZoomScale = 2;
        _scrollView.minimumZoomScale = 1;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
@end
