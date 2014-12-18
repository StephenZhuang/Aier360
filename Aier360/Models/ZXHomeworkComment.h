//
//  ZXHomeworkComment.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXHomeworkCommentReply.h"

@interface ZXHomeworkComment : ZXBaseModel
/**
 *  主键
 */
@property (nonatomic , assign) long chid;
/**
 *  作业id
 */
@property (nonatomic , assign) long hid;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  内容
 */
@property (nonatomic , copy) NSString *content;
/**
 *  图片
 */
@property (nonatomic , copy) NSString *img;
/**
 *  职务+名称或学生名+关系
 */
@property (nonatomic , copy) NSString *cname;
/**
 *  评论的时间
 */
@property (nonatomic , copy) NSString *cdate;
@property (nonatomic , copy) NSString *headimg;
/**
 *  回复列表
 */
@property (nonatomic , strong) NSArray *hcrList;
@end
