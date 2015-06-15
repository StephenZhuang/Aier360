//
//  ZXUserInfomation.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/15.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseUser.h"

@interface ZXUserInfomation : ZXBaseUser
/**
 *  生日
 */
@property (nonatomic , copy) NSString *birthday;

/**
 *  所在地区id
 */
@property (nonatomic , assign) NSInteger city_id;

/**
 *  所在地
 */
@property (nonatomic , copy) NSString *city;

/**
 *  个性签名
 */
@property (nonatomic , copy) NSString *desinfo;

/**
 *  家乡
 */
@property (nonatomic , copy) NSString *ht;

/**
 *  家乡id
 */
@property (nonatomic , assign) NSInteger ht_id;

/**
 *  行业
 */
@property (nonatomic , copy) NSString *industry;

@property (nonatomic , assign) long serialVersionUID;

/**
 *  性别
 */
@property (nonatomic , copy) NSString *sex;
@end
