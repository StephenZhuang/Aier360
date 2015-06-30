//
//  UIImage+SZBundleImage.m
//  SZShareKit
//
//  Created by Stephen Zhuang on 14/10/27.
//  Copyright (c) 2014年 udows. All rights reserved.
//

#import "UIImage+SZBundleImage.h"

@implementation UIImage (SZBundleImage)
+ (UIImage *)imagesNamedFromCustomBundle:(NSString *)name
{
    NSString *customBundleName = @"ProgressHUD";
    return [self imagesNamed:name fromBundle:customBundleName];
}

+ (UIImage *)imagesNamed:(NSString *)name fromBundle:(NSString *)bundleName
{
    NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@.bundle",bundleName];
    NSString *image_path = [main_images_dir_path stringByAppendingPathComponent:name];
    if (!IOS8_OR_LATER) {
        image_path = [image_path stringByAppendingString:@"@2x.png"];
    }
    return [UIImage imageWithContentsOfFile:image_path];
}

+ (UIImage *)screenShot
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)blureImage:(UIImage *)originImage withInputRadius:(CGFloat)inputRadius
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:originImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(inputRadius) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = CGRectInset(filter.outputImage.extent, 10, 10);
    CGImageRef outImage = [context createCGImage: result fromRect:extent];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
}
@end
