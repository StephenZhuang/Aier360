//
//  ZXSchool.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/6.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXClass.h"

@interface ZXSchool : ZXBaseModel
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  学校名称
 */
@property (nonatomic , copy) NSString *name;
/**
 *  代理商id
 */
@property (nonatomic , assign) NSInteger pid;
/**
 *  所在城市id
 */
@property (nonatomic , assign) NSInteger cid;
/**
 *  剩余短信数
 */
@property (nonatomic , assign) NSInteger mesCount;
/**
 *  学校简介
 */
@property (nonatomic , copy) NSString *desinfo;
/**
 *  学校主图
 */
@property (nonatomic , copy) NSString *img;
/**
 *  学校logo
 */
@property (nonatomic , copy) NSString *slogo;
/**
 *  学校付费方式(1,0)
 */
@property (nonatomic , assign) NSInteger method;
/**
 *  付费方式
 */
@property (nonatomic , copy) NSString *methodStr;
/**
 *  学校短信后缀
 */
@property (nonatomic , copy) NSString *mesSuffix;
/**
 *  班级数
 */
@property (nonatomic , assign) NSInteger classCount;
/**
 *  学校管理员名字与账号
 */
@property (nonatomic , copy) NSString *managers;
/**
 *  图片数量
 */
@property (nonatomic , assign) NSInteger num_img;
/**
 *  班级教师人数
 */
@property (nonatomic , assign) NSInteger num_teacher;
/**
 *  班级学生人数
 */
@property (nonatomic , assign) NSInteger num_student;
/**
 *  班级家长人数
 */
@property (nonatomic , assign) NSInteger num_parent;
/**
 *  memberNum =班级教师人数 + 班级学生人数+班级家长人数
 */
@property (nonatomic , assign) NSInteger memberNum;
/**
 *  已发短信条数
 */
@property (nonatomic , assign) NSInteger count;
/**
 *  地址
 */
@property (nonatomic , copy) NSString *address;
/**
 *  联系电话
 */
@property (nonatomic , copy) NSString *phone;
/**
 *  邮编
 */
@property (nonatomic , copy) NSString *postcode;
/**
 *  具体网址
 */
@property (nonatomic , copy) NSString *url;
/**
 *  权限
 */
@property (nonatomic , copy) NSString *appStatusSchool;
/**
 *  用户所在班级
 */
@property (nonatomic , strong) NSArray *classList;
/**
 *  id
 */
@property (nonatomic , assign) NSInteger id;
@end
