//
//  ZXTimeHelper.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXTimeHelper : NSObject
/**
 *  智能时间戳
 *
 *  @param theDate 时间，格式yyyy-MM-ddTHH:mm:ss
 *
 *  @return 智能化时间
 */
+ (NSString *)intervalSinceNow:(NSString *)theDate;

/**
 *  根据生日算年龄
 *
 *  @param birthday 生日
 *
 *  @return 年龄
 */
+ (NSInteger)ageFromBirthday:(NSString *)birthday;

/**
 *  获取相隔的月数
 *
 *  @param dateString 生日
 *
 *  @return 几年几个月
 */
+ (NSString *)yearAndMonthSinceNow:(NSString *)dateString;

+ (NSString *)DayHourMinSinceNow:(NSString *)dateString;

+ (NSInteger)day:(NSDate *)date;
+ (NSInteger)month:(NSDate *)date;
+ (NSInteger)year:(NSDate *)date;
@end
