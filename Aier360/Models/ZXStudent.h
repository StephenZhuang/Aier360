//
//  ZXStudent.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXParent.h"

@interface ZXStudent : ZXBaseModel
/**
 *  班级学生id
 */
@property (nonatomic , assign) long csid;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  学生名称
 */
@property (nonatomic , copy) NSString *sname;
/**
 *  班级id
 */
@property (nonatomic , assign) long cid;
/**
 *  加入时间
 */
@property (nonatomic , copy) NSString *ctime;
@property (nonatomic , copy) NSString *ctime_str;
/**
 *  班级名
 */
@property (nonatomic , copy) NSString *name_classes;
/**
 *  卡号
 */
@property (nonatomic , copy) NSString *cardnum;
/**
 *  家长列表
 */
@property (nonatomic , strong) NSArray *cpList;
/**
 *  请假次数
 */
@property (nonatomic , assign) NSInteger leav;
/**
 *  旷课次数
 */
@property (nonatomic , assign) NSInteger absent;
/**
 *  性别
 */
@property (nonatomic , copy) NSString *sex;
@end
