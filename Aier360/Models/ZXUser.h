//
//  ZXUser.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXUser : ZXBaseModel
/**
 *  账号
 */
@property (nonatomic , copy) NSString *account;
/**
 *  具体地址
 */
@property (nonatomic , copy) NSString *address;
@property (nonatomic , copy) NSString *appUid;
/**
 *  宝宝所在班级id
 */
@property (nonatomic , assign) long baby_classId;
/**
 *  宝宝所在班级名
 */
@property (nonatomic , copy) NSString *baby_className;
/**
 *  生日
 */
@property (nonatomic , copy) NSString *birthday;
/**
 *  粉丝的数量
 */
@property (nonatomic , assign) NSInteger cfans;
/**
 *  关注的数量
 */
@property (nonatomic , assign) NSInteger cfollow;
/**
 *  新鲜事的数量
 */
@property (nonatomic , assign) NSInteger cfresh;
/**
 *  所在地区id
 */
@property (nonatomic , assign) NSInteger city_id;
/**
 *  共同关注
 */
@property (nonatomic , strong) NSArray *commonFollow;
/**
 *  星座
 */
@property (nonatomic , copy) NSString *constellation;
/**
 *  个人主页封面
 */
@property (nonatomic , copy) NSString *coverimg;
/**
 *  个人简介
 */
@property (nonatomic , copy) NSString *desinfo;
/**
 *  是否购买家校联系薄服务（日期 正常使用，1未购买，2服务过期）
 */
@property (nonatomic , copy) NSString *edate;
/**
 *  邮箱
 */
@property (nonatomic , copy) NSString *email;
/**
 *  头像图片名
 */
@property (nonatomic , copy) NSString *headimg;
@property (nonatomic , strong) NSArray *idenPL;
@property (nonatomic , assign) NSInteger idenProxy;
/**
 *  爱好
 */
@property (nonatomic , copy) NSString *interest;
/**
 *  是否为孩子(孩子账号不给登录) 1:是,0:否
 */
@property (nonatomic , assign) NSInteger isbaby;
/**
 *  昵称
 */
@property (nonatomic , copy) NSString *nickname;
/**
 *  手机号(不是孩子账号时不能为空)
 */
@property (nonatomic , copy) NSString *phone;
/**
 *  手机唯一标识
 */
@property (nonatomic , copy) NSString *phone_imei;
/**
 *  密码
 */
@property (nonatomic , copy) NSString *pwd;
/**
 *  真实姓名
 */
@property (nonatomic , copy) NSString *realname;
/**
 *  关系(宝宝同班，宝宝同校)
 */
@property (nonatomic , copy) NSString *relation;
/**
 *  备注名
 */
@property (nonatomic , copy) NSString *remark;
/**
 *  性别
 */
@property (nonatomic , copy) NSString *sex;
/**
 *  关注状态：1已关注；2互相关注;
 */
@property (nonatomic , assign) NSInteger state;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
@end
