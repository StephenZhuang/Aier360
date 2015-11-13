//
//  ZXICCard.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXICCard : ZXBaseModel
/**
 *  主键id
 */
@property (nonatomic , assign) long siid;
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  ic的id
 */
@property (nonatomic , assign) long icid;
/**
 *  班级id
 */
@property (nonatomic , assign) long cid;
/**
 *  状态:10启用,20注销
 */
@property (nonatomic , assign) NSInteger state;
/**
 *  绑定时间
 */
@property (nonatomic , copy) NSString *bsdate;
/**
 *  卡号
 */
@property (nonatomic , copy) NSString *cardnum;
/**
 *  验证码
 */
@property (nonatomic , copy) NSString *ifoot;
@property (nonatomic , assign) long csid;
/**
 *  教师id
 */
@property (nonatomic , assign) long tid;
/**
 *  卡拥有人id(uid)
 */
@property (nonatomic , assign) long uid;
/**
 *  归属人
 */
@property (nonatomic , copy) NSString *name_card;
/**
 *  绑定的教师名
 */
@property (nonatomic , copy) NSString *name_teacher;
/**
 *  职务名称
 */
@property (nonatomic , copy) NSString *gname;
/**
 *  绑定的学生名
 */
@property (nonatomic , copy) NSString *name_student;
@property (nonatomic , copy) NSString *bsdate_str;
@property (nonatomic , copy) NSString *state_str;
/**
 *  学校名称
 */
@property (nonatomic , copy) NSString *sname;
/**
 *  班级名称
 */
@property (nonatomic , copy) NSString *cname;
/**
 *  身份（学生或教师）
 */
@property (nonatomic , copy) NSString *identity;
@property (nonatomic , copy) NSString *statestr;
@end
