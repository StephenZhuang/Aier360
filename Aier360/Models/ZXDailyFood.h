//
//  ZXDailyFood.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXDailyFood : ZXBaseModel
/**
 *  餐饮id
 */
@property (nonatomic , assign) long dfid;
/**
 *  餐饮内容
 */
@property (nonatomic , copy) NSString *content;
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  用餐日期（yyyy-MM-dd）
 */
@property (nonatomic , copy) NSString *ddate;
/**
 *  状态（0未发送1已发送）
 */
@property (nonatomic , assign) NSInteger state;
/**
 *  是否发送短信
 */
@property (nonatomic , assign) NSInteger ismessage;
/**
 *  餐饮编辑时间（yyyy-MM-ddThh:mm:ss:）
 */
@property (nonatomic , copy) NSString *cdate;
/**
 *   餐饮图片（多张以，号分隔）
 */
@property (nonatomic , copy) NSString *img;

/**
 *  是否有图片(学校管理员)
 */
@property (nonatomic , assign) BOOL hasImg;
@end
