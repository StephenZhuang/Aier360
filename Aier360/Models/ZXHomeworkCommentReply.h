//
//  ZXHomeworkCommentReply.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXHomeworkCommentReply : ZXBaseModel
/**
 *  id
 */
@property (nonatomic , assign) long crhid;
/**
 *  评论id
 */
@property (nonatomic , assign) long chid;
/**
 *  回复人的用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  职务+名称或学生名+关系
 */
@property (nonatomic , copy) NSString *cname;
/**
 *  内容
 */
@property (nonatomic , copy) NSString *content;
/**
 *  回复时间
 */
@property (nonatomic , copy) NSString *cdate;
@property (nonatomic , copy) NSString *headimg;
@end
