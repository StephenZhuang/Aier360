//
//  ZXBaseUser.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/15.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXBaseUser : ZXBaseModel
/**
 *  账号
 */
@property (nonatomic , copy) NSString *account;
/**
 *  密码
 */
@property (nonatomic , copy) NSString *pwd;

/**
 *  头像图片名
 */
@property (nonatomic , copy) NSString *headimg;

/**
 *  昵称
 */
@property (nonatomic , copy) NSString *nickname;

/**
 *  用户id
 */
@property (nonatomic , assign) long uid;

/**
 *  爱儿号
 */
@property (nonatomic , copy) NSString *aier;

/**
 *  备注名
 */
@property (nonatomic , copy) NSString *remark;

- (NSString *)displayName;
@end
