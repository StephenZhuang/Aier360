//
//  ZXUser.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUserInfomation.h"

@interface ZXUser : ZXUserInfomation
/**
 *  关注状态：1已关注；2互相关注;
 */
@property (nonatomic , assign) NSInteger state;




/**
 *  二维码
 */
@property (nonatomic , copy) NSString *qrcode;

/**
 *  宝宝生日，逗号隔开
 */
@property (nonatomic , copy) NSString *babyBirthdays;

@end
