//
//  ZXFollow.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXFollow : ZXBaseModel
/**
 *  id
 */
@property (nonatomic , assign) long foid;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  被关注用户id
 */
@property (nonatomic , assign) long fuid;
/**
 *  分组id(0默认分组--特别关注；-1未分组）
 */
@property (nonatomic , assign) long fgid;
/**
 *  备注名
 */
@property (nonatomic , copy) NSString *remark;
/**
 *  关注状态：1已关注；2互相关注
 */
@property (nonatomic , assign) NSInteger state;
/**
 *  时间
 */
@property (nonatomic , copy) NSString *cdate;
/**
 *  昵称
 */
@property (nonatomic , copy) NSString *nickname;
/**
 *  头像
 */
@property (nonatomic , copy) NSString *headimg;
/**
 *  分组名称
 */
@property (nonatomic , copy) NSString *fgName;
/**
 *  个人简介
 */
@property (nonatomic , copy) NSString *desinfo;
/**
 *  关注类型（已关注，互相关注）
 */
@property (nonatomic , copy) NSString *followStr;
/**
 *  状态类型(密友,等待确认中)
 */
@property (nonatomic , copy) NSString *stateStr;
@property (nonatomic , copy) NSString *account;
/**
 *  被关注人的昵称
 */
@property (nonatomic , copy) NSString *fnickname;
/**
 *  被关注人的头像
 */
@property (nonatomic , copy) NSString *fheadimg;
/**
 *  性别
 */
@property (nonatomic , copy) NSString *sex;
/**
 *  地址
 */
@property (nonatomic , copy) NSString *address;
/**
 *  年龄
 */
@property (nonatomic , assign) NSInteger age;
/**
 *  1：同班  2：同校
 */
@property (nonatomic , assign) NSInteger relation;
/**
 *  0普通用户，1爱儿邦团队
 */
@property (nonatomic , assign) NSInteger adminFlag;
@end
