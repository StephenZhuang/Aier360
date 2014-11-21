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
@end
