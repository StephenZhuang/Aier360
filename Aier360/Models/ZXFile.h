//
//  ZXFile.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXFile : ZXBaseModel
/**
 *  文件路径
 */
@property (nonatomic , copy) NSString *path;
/**
 *  key名称
 */
@property (nonatomic , copy) NSString *name;
/**
 *  文件名
 */
@property (nonatomic , copy) NSString *fileName;
/**
 *  mime
 */
@property (nonatomic , copy) NSString *mimeType;
@end
