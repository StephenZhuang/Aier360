//
//  ZXSchoolImg.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXSchoolImg : ZXBaseModel
@property (nonatomic , copy) NSString *img;
@property (nonatomic , copy) NSString *info;
@property (nonatomic , assign) long sid;
@property (nonatomic , copy) NSString *sitime;
@property (nonatomic , assign) NSInteger spid;
@end
