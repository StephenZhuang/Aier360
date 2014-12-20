//
//  ZXHomework.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXHomeworkComment.h"

@interface ZXHomework : ZXBaseModel
/**
 *  id
 */
@property (nonatomic , assign) long hid;
/**
 *  班级id
 */
@property (nonatomic , assign) long cid;
/**
 *  教师id
 */
@property (nonatomic , assign) long tid;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
@property (nonatomic , copy) NSString *title;
/**
 *  作业内容
 */
@property (nonatomic , copy) NSString *content;
/**
 *  作业图片
 */
@property (nonatomic , copy) NSString *img;
/**
 *  发布作业时间
 */
@property (nonatomic , copy) NSString *cdate;
/**
 *  作业发送的人数
 */
@property (nonatomic , assign) NSInteger count;
/**
 *  评论数量
 */
@property (nonatomic , assign) NSInteger comment;
/**
 *  已阅读人数
 */
@property (nonatomic , assign) NSInteger reading;
/**
 *  教师姓名
 */
@property (nonatomic , copy) NSString *tname;
/**
 *  评论列表
 */
@property (nonatomic , strong) NSArray *hcList;
/**
 *  头像
 */
@property (nonatomic , copy) NSString *headimg;
/**
 *  短信发送成功的用户名
 */
@property (nonatomic , copy) NSString *successStr;
/**
 *  短信发送失败的用户名
 */
@property (nonatomic , copy) NSString *failStr;
@end
