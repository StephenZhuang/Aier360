//
//  ZXClass.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/6.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"

@interface ZXClass : BaseModel
@property (nonatomic , assign) long cid;
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
 *  班级管理员教师名
 */
@property (nonatomic , copy) NSString *tnames;
@property (nonatomic , copy) NSString *ctime_str;
@property (nonatomic , assign) NSInteger num_teacher;
@property (nonatomic , assign) NSInteger num_student;
@property (nonatomic , assign) NSInteger num_parent;
@end
