//
//  ZXHomeworkMessage.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXHomeworkMessage : ZXBaseModel
/**
 *  主键id
 */
@property (nonatomic , assign) long hmid;
/**
 *  亲子任务id
 */
@property (nonatomic , assign) long hid;
/**
 *  被回复、评论人用户id
 */
@property (nonatomic , assign) long ouid;
/**
 *  回复、评论用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  1：评论，2：回复
 */
@property (nonatomic , assign) NSInteger type;
/**
 *  是否已经阅读
 */
@property (nonatomic , assign) BOOL isread;
/**
 *  时间
 */
@property (nonatomic , copy) NSString *cate;
/**
 *  回复、评论人的头像
 */
@property (nonatomic , copy) NSString *headimg;
/**
 *  回复、评论人的昵称
 */
@property (nonatomic , copy) NSString *nickname;
@end
