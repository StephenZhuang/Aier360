//
//  ZXPosition.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXPosition : ZXBaseModel
/**
 *  职务id
 */
@property (nonatomic , assign) NSInteger gid;
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  职务名称
 */
@property (nonatomic , copy) NSString *name;
/**
 *  描述
 */
@property (nonatomic , copy) NSString *desinfo;
/**
 *  职务人数
 */
@property (nonatomic , assign) NSInteger typeNumber;
@property (nonatomic , copy) NSString *date_str;
/**
 *  职务作息列表
 */
@property (nonatomic , strong) NSArray *sgaLit;

/**
 *  职务下教师列表
 */
@property (nonatomic , strong) NSMutableArray *list;

/**
 *  未激活的教师数
 */
@property (nonatomic , assign) NSInteger num_login_teacher;
@end
