//
//  ZXCardHistory.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXCardHistory : ZXBaseModel
/**
 *  用户名称
 */
@property (nonatomic , copy) NSString *name;
/**
 *  日期(2014-09-01)
 */
@property (nonatomic , copy) NSString *day;
/**
 *  上午进园时间
 */
@property (nonatomic , copy) NSString *am_in;
/**
 *  上午出门时间
 */
@property (nonatomic , copy) NSString *am_out;
/**
 *  下午进门时间
 */
@property (nonatomic , copy) NSString *pm_in;
/**
 *  下午出门时间
 */
@property (nonatomic , copy) NSString *pm_out;
/**
 *  教师id
 */
@property (nonatomic , assign) NSInteger tid;
/**
 *  上班时间 (时:分)
 */
@property (nonatomic , copy) NSString *in_time;
/**
 *  下班时间 (时:分)
 */
@property (nonatomic , copy) NSString *out_time;
/**
 *  打卡类型(进1，出2)
 */
@property (nonatomic , assign) NSInteger type;
/**
 *  打卡时间
 */
@property (nonatomic , copy) NSString *time;
/**
 *  打卡次数
 */
@property (nonatomic , assign) NSInteger card_count;
/**
 *  班级名称
 */
@property (nonatomic , copy) NSString *cname;
/**
 *  打卡详情
 */
@property (nonatomic , copy) NSString *detail;
@end
