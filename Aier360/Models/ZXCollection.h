//
//  ZXCollection.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseUser.h"

@interface ZXCollection : ZXBaseUser
@property (nonatomic , assign) long cid;
@property (nonatomic , assign) long relativeId;
@property (nonatomic , copy) NSString *content;
@property (nonatomic , copy) NSString *ctime;
@property (nonatomic , copy) NSString *img;
@end
