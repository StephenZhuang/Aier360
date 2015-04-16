//
//  ZXBaby.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXBaby : ZXBaseModel
/**
 *  baby id
 */
@property (nonatomic , assign) long bid;
/**
 *  生日
 */
@property (nonatomic , copy) NSString *birthday;
/**
 *  昵称
 */
@property (nonatomic , copy) NSString *nickname;
/**
 *  关系
 */
@property (nonatomic , copy) NSString *relation;

@property (nonatomic , assign) long serialVersionUID;
/**
 *  性别
 */
@property (nonatomic , copy) NSString *sex;
/**
 *  家长id
 */
@property (nonatomic , assign) long uid;
@end
