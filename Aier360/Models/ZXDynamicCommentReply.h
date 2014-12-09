//
//  ZXDynamicCommentReply.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXDynamicCommentReply : ZXBaseModel
/**
 *  主键
 */
@property (nonatomic , assign) long dcrid;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  评论id
 */
@property (nonatomic , assign) long dcid;
/**
 *  回复的对象的昵称
 */
@property (nonatomic , copy) NSString *rname;
/**
 *  评论内容
 */
@property (nonatomic , copy) NSString *content;
/**
 *  发布时间
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
@end
