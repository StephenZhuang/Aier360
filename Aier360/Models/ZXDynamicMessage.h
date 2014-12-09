//
//  ZXDynamicMessage.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/8.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXDynamicMessage : ZXBaseModel
/**
 *  id
 */
@property (nonatomic , assign) long dmid;
/**
 *  动态id
 */
@property (nonatomic , assign) long did;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  评论内容
 */
@property (nonatomic , copy) NSString *dynamiccontent;
/**
 *  内容
 */
@property (nonatomic , copy) NSString *content;
/**
 *  类型(1评论动态2回复评论3赞了动态)
 */
@property (nonatomic , assign) NSInteger type;
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
@property (nonatomic , assign) long oid;
@property (nonatomic , assign) NSInteger isRead;
@end
