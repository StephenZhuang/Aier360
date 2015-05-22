//
//  ZXZipHelper.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/21.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXZipHelper.h"

@implementation ZXZipHelper
+ (NSString *)archiveImagesWithImageUrls:(NSArray *)imageUrlArray
{
    NSString *docspath = [self docspath];
    
    NSString *zipFile = [docspath stringByAppendingPathComponent:@"newzipfile.zip"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:zipFile]) {
        [fileManager removeItemAtPath:zipFile error:nil];
    }
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFile];
    
    for (int i = 0; i < imageUrlArray.count; i++) {
        if ([imageUrlArray[i] isKindOfClass:[NSURL class]]) {
            [za addFileToZip:[imageUrlArray[i] absoluteString] newname:[NSString stringWithFormat:@"%i.png",i]];
        } else {
            [za addFileToZip:imageUrlArray[i] newname:[NSString stringWithFormat:@"%i.png",i]];
        }
    }
    
    BOOL success = [za CloseZipFile2];
    
    NSLog(@"Zipped file with result %d",success);
    NSLog(@"filePath = %@", zipFile);
    return zipFile;
}

+ (NSString *)docspath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docspath = [paths objectAtIndex:0];
    return docspath;
}

#pragma mark - 保存图片至沙盒
+ (NSString *)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    UIImage *image = [ZXZipHelper compressImage:currentImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    // 获取沙盒目录
    NSString *docsPath = [ZXZipHelper docspath];
    NSString *fullPath = [docsPath stringByAppendingPathComponent:imageName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fullPath]) {
        [fileManager createFileAtPath:fullPath contents:nil attributes:nil];
    }
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
    return fullPath;
}

+ (UIImage *)compressImage:(UIImage *)image
{
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Create a graphics image context
//    CGSize newSize = CGSizeMake(1080, 1080 * image.size.height / image.size.width);
    //TODO: 降低图片大小，可能会失真
    CGSize newSize;
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake(640 * image.size.width / image.size.height, 640);
    } else {
        newSize = CGSizeMake(640, 640 * image.size.height / image.size.width);
    }
    
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    
    //    [pool release];
    return newImage;
}

+ (NSString *)archiveImages:(NSArray *)imageArray
{
    NSMutableArray *imageUrlArray = [[NSMutableArray alloc] init];
    for (UIImage *image in imageArray) {
        NSInteger i = [imageArray indexOfObject:image];
        NSString *string = [self saveImage:image withName:[NSString stringWithFormat:@"image%i.png",i]];
        [imageUrlArray addObject:string];
    }
    NSString *filePath = [self archiveImagesWithImageUrls:imageUrlArray];
    return filePath;
}
@end
