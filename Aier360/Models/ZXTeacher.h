//
//  ZXTeacher.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"

@interface ZXTeacher : BaseModel
/**
 *  教师id
 */
@property (nonatomic , assign) long tid;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  教师姓名
 */
@property (nonatomic , copy) NSString *tname;
/**
 *  职务id
 */
@property (nonatomic , assign) long gid;
/**
 *  加入时间
 */
@property (nonatomic , copy) NSString *ctime;
/**
 *  是否为学校管理员 1:是,0:否
 */
@property (nonatomic , assign) NSInteger isadmin;
/**
 *  剩余短信条数
 */
@property (nonatomic , assign) NSInteger mesCount;
/**
 *  状态 ： 0 ：正常  1：解雇 2：删除
 */
@property (nonatomic , assign) NSInteger state;
/**
 *  账号
 */
@property (nonatomic , copy) NSString *account;
/**
 *  性别
 */
@property (nonatomic , copy) NSString *sex;
/**
 *  职务名称
 */
@property (nonatomic , copy) NSString *gname;
/**
 *  所在班级名称
 */
@property (nonatomic , copy) NSString *className_in;
/**
 *  所管理的班级名称
 */
@property (nonatomic , copy) NSString *className_manage;
/**
 *  学校名
 */
@property (nonatomic , copy) NSString *name_school;
/**
 *  班级教师列表
 */
@property (nonatomic , strong) NSArray *classTeacherList;
/**
 *  个性签名
 */
@property (nonatomic , copy) NSString *desinfo;
/**
 *  头像
 */
@property (nonatomic , copy) NSString *headimg;
/**
 *  卡号
 */
@property (nonatomic , copy) NSString *cardnum;
@property (nonatomic , copy) NSString *ctime_str;

@end
