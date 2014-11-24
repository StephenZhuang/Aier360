//
//  ZXZipHelper.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/21.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"

@interface ZXZipHelper : NSObject
/**
 *  压缩图片
 *
 *  @param imageUrlArray 图片地址数组
 *
 *  @return zip文件路径
 */
+ (NSString *)archiveImagesWithImageUrls:(NSArray *)imageUrlArray;
/**
 *  获取统一的文件路径
 *
 *  @return 文件路径
 */
+ (NSString *)docspath;
/**
 *  将图片保存到目录下
 *
 *  @param currentImage 原图
 *  @param imageName    图片名
 *
 *  @return 路径
 */
+ (NSString *)saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
/**
 *  压缩图片
 *
 *  @param image 原图片
 *
 *  @return 压缩过后的图片
 */
+ (UIImage *)compressImage:(UIImage *)image;
@end
