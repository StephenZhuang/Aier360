//
//  ZXDynamicComment.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXDynamicCommentReply.h"

@interface ZXDynamicComment : ZXBaseModel
/**
 *  id
 */
@property (nonatomic , assign) long dcid;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  动态id
 */
@property (nonatomic , assign) long did;
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
/**
 *  回复列表
 */
@property (nonatomic , strong) NSArray *dcrList;
@end
