//
//  ZXTimeHelper.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTimeHelper.h"

@implementation ZXTimeHelper
+ (NSString *)intervalSinceNow:(NSString *)theDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //奇葩公司的时间表示是2014-01-01T15:15:00这样的，需要替换这个T,dateFormatter不能解析
    theDate = [theDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate *d = [dateFormatter dateFromString:theDate];
    NSTimeInterval late = [d timeIntervalSince1970] * 1;
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970] * 1;
    NSString *timeString = @"";
    NSTimeInterval cha = now-late;
    
    //发表在一小时之内
    if(cha / 3600 < 1) {
        if(cha / 60 < 1) {
            timeString = @"1";
        } else {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    
    //在一小时以上24小以内
    else if(cha / 3600 > 1 && cha / 86400 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }
    
    //发表在24以上10天以内
    else if(cha/86400>1&&cha/864000<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
    }
    
    //发表时间大于10天 显示几月-几号 eg：11-11
    else {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        NSArray*array = [theDate componentsSeparatedByString:@" "];
        //        return [array objectAtIndex:0];
        timeString = [array objectAtIndex:0];
        timeString = [timeString substringWithRange:NSMakeRange(5, [timeString length]-5)];
    }
    
    return timeString;
    
}

+ (NSInteger)ageFromBirthday:(NSString *)birthday
{
    NSDate *date = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthdate = [formatter dateFromString:[[birthday componentsSeparatedByString:@"T"] firstObject]];
    NSTimeInterval time = [date timeIntervalSinceDate:birthdate];
    NSInteger age = (NSInteger)(time / (365.4 * 24 * 3600));
    return age;
}
@end
