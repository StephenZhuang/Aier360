//
//  ZXFile.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFile.h"

@implementation ZXFile
- (NSString *)mimeType
{
    if (!_mimeType) {
        _mimeType = @"application/octet-stream";
    }
    return _mimeType;
}

- (NSString *)name
{
    if (!_name) {
        _name = @"file";
    }
    return _name;
}

- (NSString *)fileName
{
    if (!_fileName) {
        _fileName = @"newzipfile.zip";
    }
    return _fileName;
}
@end
