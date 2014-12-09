//
//  ZXClassDetail.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXClassDetail : ZXBaseModel
/**
 *  班级名
 */
@property (nonatomic , copy) NSString *cname;
/**
 *  宝宝数
 */
@property (nonatomic , assign) NSInteger num;
/**
 *  班主任
 */
@property (nonatomic , copy) NSString *adminName;
/**
 *  协管教师
 */
@property (nonatomic , copy) NSString *assistTeacherName;
/**
 *  保育员
 */
@property (nonatomic , copy) NSString *childCarename;
@end
