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
    if (imageUrlArray.count > 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docspath = [paths objectAtIndex:0];
        
        NSString *zipFile = [docspath stringByAppendingPathComponent:@"newzipfile.zip"];
        
        ZipArchive *za = [[ZipArchive alloc] init];
        [za CreateZipFile2:zipFile];
        
        for (int i = 0; i < imageUrlArray.count; i++) {
            [za addFileToZip:[imageUrlArray[i] absoluteString] newname:[NSString stringWithFormat:@"%i.png",i]];
        }
        
        BOOL success = [za CloseZipFile2];
        
        NSLog(@"Zipped file with result %d",success);
        NSLog(@"filePath = %@", zipFile);
        return zipFile;
    } else {
        return @"";
    }
}
@end
