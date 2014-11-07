//
//  ZXAppStateInfo.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/6.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"

@interface ZXAppStateInfo : BaseModel
/**
 *  权限
 */
@property (nonatomic , copy) NSString *appState;
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  学校名
 */
@property (nonatomic , copy) NSString *sname;
/**
 *  教师id
 */
@property (nonatomic , assign) long tid;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  班级id
 */
@property (nonatomic , assign) long cid;
/**
 *  班级名
 */
@property (nonatomic , copy) NSString *cname;
/**
 *  职务名
 */
@property (nonatomic , copy) NSString *gname;
/**
 *  用户身份
 */
@property (nonatomic , copy) NSString *listStr;
@end
