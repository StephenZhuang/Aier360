//
//  ZXRequestParent.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXUser.h"

@interface ZXRequestParent : ZXBaseModel
/**
 *  主键
 */
@property (nonatomic , assign) long rpid;
@property (nonatomic , assign) long rtid;
/**
 *  家长用户id
 */
@property (nonatomic , assign) long parent_uid;
/**
 *  孩子用户id
 */
@property (nonatomic , assign) long baby_uid;
/**
 *  家长与孩子的关系
 */
@property (nonatomic , copy) NSString *relation;
/**
 *  教师id
 */
@property (nonatomic , assign) long tid;
/**
 *  班级id
 */
@property (nonatomic , assign) long cid;
/**
 *  内容
 */
@property (nonatomic , copy) NSString *content;
/**
 *  状态 0:审核中,1:同意,2:拒绝
 */
@property (nonatomic , assign) NSInteger state;
/**
 *  邀请时间
 */
@property (nonatomic , copy) NSString *ctime;
@property (nonatomic , copy) NSString *ctime_str;
@property (nonatomic , copy) NSString *state_str;
/**
 *  审核的教师姓名
 */
@property (nonatomic , copy) NSString *name_teacher;
/**
 *  家长姓名
 */
@property (nonatomic , copy) NSString *name_parent;
/**
 *  孩子姓名
 */
@property (nonatomic , copy) NSString *name_student;
/**
 *  班级名称
 */
@property (nonatomic , copy) NSString *name_class;
/**
 *  用户名
 */
@property (nonatomic , copy) NSString *nickname;
/**
 *  家长用户
 */
@property (nonatomic , strong) ZXUser *user_parent;
/**
 *  班级名称
 */
@property (nonatomic , copy) NSString *cname;
@end
