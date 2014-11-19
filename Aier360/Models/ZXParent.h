//
//  ZXParent.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"

@interface ZXParent : BaseModel
/**
 *  家长id
 */
@property (nonatomic , assign) long cpid;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  班级id
 */
@property (nonatomic , assign) long cid;
/**
 *  家长姓名
 */
@property (nonatomic , copy) NSString *pname;
/**
 *  对应的班级学生id
 */
@property (nonatomic , assign) long csid;
/**
 *  加入时间
 */
@property (nonatomic , copy) NSString *ctime;
/**
 *  家长与对应的学生的关系
 */
@property (nonatomic , copy) NSString *relation;
@property (nonatomic , copy) NSString *ctime_str;
/**
 *  对应的学生姓名
 */
@property (nonatomic , copy) NSString *name_student;
/**
 *  班级名
 */
@property (nonatomic , copy) NSString *name_clases;
/**
 *  班级
 */
@property (nonatomic , copy) NSString *clogo;
/**
 *  家长账号
 */
@property (nonatomic , copy) NSString *account;
/**
 *  家长手机号码
 */
@property (nonatomic , copy) NSString *tel;
/**
 *  服务的有效期
 */
@property (nonatomic , copy) NSString *edate;
/**
 *  头像
 */
@property (nonatomic , copy) NSString *headimg;
/**
 *  权限
 */
@property (nonatomic , copy) NSString *appStatusPareant;
@end
