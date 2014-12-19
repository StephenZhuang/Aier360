//
//  ZXHomeworkRead.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXHomeworkRead : ZXBaseModel
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  身份：1：家长，2：普通老师，3：学校管理员
 */
@property (nonatomic , assign) NSInteger state;
/**
 *  姓名
 */
@property (nonatomic , copy) NSString *name;
/**
 *  头像
 */
@property (nonatomic , copy) NSString *headimg;
@end
