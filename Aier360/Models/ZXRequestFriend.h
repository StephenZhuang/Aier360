//
//  ZXRequestFriend.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/2.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXRequestFriend : ZXBaseModel
/**
 *  主键
 */
@property (nonatomic , assign) long rfid;
/**
 *  添加者id
 */
@property (nonatomic , assign) long fromUid;
/**
 *  被添加者id
 */
@property (nonatomic , assign) long toUid;
/**
 *  验证信息
 */
@property (nonatomic , copy) NSString *content;
/**
 *  状态（0：等待确认，1：同意，2：拒绝，3：超时）
 */
@property (nonatomic , assign) NSInteger state;
/**
 *  申请时间
 */
@property (nonatomic , copy) NSString *ctime;
/**
 *  是否已经删除
 */
@property (nonatomic , assign) BOOL deleted;
/**
 *  头像
 */
@property (nonatomic , copy) NSString *headimg;
/**
 *  昵称
 */
@property (nonatomic , copy) NSString *nickname;
@end
