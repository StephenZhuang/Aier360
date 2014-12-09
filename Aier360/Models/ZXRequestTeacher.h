//
//  ZXRequestTeacher.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXRequestTeacher : ZXBaseModel
/**
 *  requestid
 */
@property (nonatomic , assign) long rtid;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  教师姓名
 */
@property (nonatomic , copy) NSString *tname;
/**
 *  职务id
 */
@property (nonatomic , assign) long gid;
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  班级id
 */
@property (nonatomic , assign) long cid;
/**
 *  教师id
 */
@property (nonatomic , assign) long tid;
/**
 *  内容
 */
@property (nonatomic , copy) NSString *content;
/**
 *  状态 0:审核中,1:同意,2:拒绝
 */
@property (nonatomic , assign) NSInteger state;
/**
 *  时间
 */
@property (nonatomic , copy) NSString *ctime;
@property (nonatomic , copy) NSString *ctime_str;
@property (nonatomic , copy) NSString *state_str;
/**
 *  职务名称
 */
@property (nonatomic , copy) NSString *gname;
/**
 *  审核的教师姓名
 */
@property (nonatomic , copy) NSString *name_teacher;
/**
 *  申请的用户
 */
@property (nonatomic , strong) ZXUser *user;
/**
 *  班级名称
 */
@property (nonatomic , copy) NSString *cname;
@end
