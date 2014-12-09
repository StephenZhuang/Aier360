//
//  ZXTeacherCharisma.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXTeacherCharisma : ZXBaseModel
/**
 *  主键
 */
@property (nonatomic , assign) long stcid;
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  教师姓名
 */
@property (nonatomic , copy) NSString *name;
/**
 *  照片
 */
@property (nonatomic , copy) NSString *img;
/**
 *  个人简介
 */
@property (nonatomic , copy) NSString *desinfo;
/**
 *  创建时间
 */
@property (nonatomic , copy) NSString *ctime;
@end
