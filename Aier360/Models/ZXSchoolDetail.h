//
//  ZXSchoolDetail.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/4.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"

@interface ZXSchoolDetail : BaseModel
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  地址
 */
@property (nonatomic , copy) NSString *address;
/**
 *  电话
 */
@property (nonatomic , copy) NSString *phone;
/**
 *  网站
 */
@property (nonatomic , copy) NSString *url;
/**
 *  邮编
 */
@property (nonatomic , copy) NSString *postcode;
/**
 *  学校邮件
 */
@property (nonatomic , copy) NSString *email;

/**
 *  校园简介
 */
@property (nonatomic , copy) NSString *desinfo;
/**
 *  传真
 */
@property (nonatomic , copy) NSString *fax;
@property (nonatomic , assign) NSInteger id;
/**
 *  园长邮箱
 */
@property (nonatomic , copy) NSString *temail;
/**
 *  园长名称
 */
@property (nonatomic , copy) NSString *tname;
/**
 *  园长QQ
 */
@property (nonatomic , copy) NSString *qqnum;
/**
 *  园长电话号码
 */
@property (nonatomic , copy) NSString *tphone;
@end
