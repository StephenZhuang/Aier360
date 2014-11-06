//
//  ZXSchool.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/6.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"
#import "ZXClass.h"

@interface ZXSchool : BaseModel
@property (nonatomic , assign) NSInteger sid;
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

@property (nonatomic , copy) NSString *desinfo;
@property (nonatomic , copy) NSString *img;
@property (nonatomic , copy) NSString *slogo;
/**
 *  学校付费方式
 */
@property (nonatomic , assign) NSInteger method;
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
@property (nonatomic , assign) NSInteger num_teacher;
@property (nonatomic , assign) NSInteger num_student;
@property (nonatomic , assign) NSInteger num_parent;
@property (nonatomic , assign) NSInteger memberNum;
/**
 *  已发短信条数
 */
@property (nonatomic , assign) NSInteger count;
@property (nonatomic , copy) NSString *address;
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , copy) NSString *postcode;
@property (nonatomic , copy) NSString *url;
@property (nonatomic , copy) NSString *appStatusSchool;
@property (nonatomic , strong) NSArray *classList;
/**
 *  id
 */
@property (nonatomic , assign) NSInteger id;
@end
