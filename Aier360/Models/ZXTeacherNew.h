//
//  ZXTeacherNew.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacher.h"

@interface ZXTeacherNew : ZXTeacher

/**
 *  解雇时间
 */
@property (nonatomic , copy) NSString *firetime;

/**
 *  班级管理员带的所有班级名称
 */
@property (nonatomic , copy) NSString *cname;

/**
 *  所在的所有班级名称
 */
@property (nonatomic , copy) NSString *cnames;
/**
 *  班级id
 */
@property (nonatomic , copy) NSString *cid;
//@property (nonatomic , copy) NSArray *roles;
/**
 *  所带班级
 */
@property (nonatomic , strong) NSArray *classes;
/**
 *  学校
 */
@property (nonatomic , copy) NSString *sname;
/**
 *  手机号
 */
@property (nonatomic , copy) NSString *phone;

/**
 *  最近登录时间
 */
@property (nonatomic , copy) NSString *lastLogon;

/**
 *  昵称，聊天用
 */
@property (nonatomic , copy) NSString *nickname;

/**
 *  是否为班级管理员
 */
@property (nonatomic , assign) BOOL isClassAdmin;

/**
 *  是否被选中
 */
@property (nonatomic , assign) BOOL isSelected;
@end
