//
//  ZXClass.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/6.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"

@interface ZXClass : BaseModel
/**
 *  班级id
 */
@property (nonatomic , assign) long cid;
/**
 *  班级名称
 */
@property (nonatomic , copy) NSString *cname;
/**
 *  班级信息
 */
@property (nonatomic , copy) NSString *desinfo;
/**
 *  班级宣言
 */
@property (nonatomic , copy) NSString *manifesto;
/**
 *  班级主图
 */
@property (nonatomic , copy) NSString *img;
/**
 *  班徽
 */
@property (nonatomic , copy) NSString *clogo;
/**
 *  创建时间
 */
@property (nonatomic , copy) NSString *ctime;
/**
 *  剩余短信数
 */
@property (nonatomic , assign) NSInteger mesCount;
/**
 *  班级的管理教师名(多个用,分隔)
 */
@property (nonatomic , copy) NSString *tnames;
/**
 *  格式化ctime，只显示年月日
 */
@property (nonatomic , copy) NSString *ctime_str;
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
 *  班级权限 2:班级管理员 3:教师 4:家长 5:没有身份
 */
@property (nonatomic , copy) NSString *appStatusClass;
@end
