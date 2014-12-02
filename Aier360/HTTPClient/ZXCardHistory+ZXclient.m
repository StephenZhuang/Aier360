//
//  ZXCardHistory+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/2.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCardHistory+ZXclient.h"

@implementation ZXCardHistory (ZXclient)
+ (NSURLSessionDataTask *)getMyCardHistoryWithSid:(NSInteger)sid
                                              uid:(NSInteger)uid
                                  yearAndMonthStr:(NSString *)yearAndMonthStr
                                             page:(NSInteger)page
                                         pageSize:(NSInteger)pageSize
                                            block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [prameters setObject:yearAndMonthStr forKey:@"yearAndMonthStr"];
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/teacherIcardInfo_searchTeacherIcardInfoByUidYearMonth.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"userIcardRecordList"];
        NSArray *arr = [ZXCardHistory objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getDayCardHistoryWithUid:(NSInteger)uid
                                          beginday:(NSString *)beginday
                                             block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [prameters setObject:beginday forKey:@"beginday"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/studentrecord_searchTeacherInOutDetail.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"studentInOutRecordList"];
        NSArray *arr = [ZXCardHistory objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getDayDetailCardHistoryWithTid:(NSInteger)tid
                                         yearAndMonthStr:(NSString *)yearAndMonthStr
                                                   block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
    [prameters setObject:yearAndMonthStr forKey:@"yearAndMonthStr"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/teacherIcardInfo_searchTeacherInOutDetail.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"userIcardRecordList"];
        NSArray *arr = [ZXCardHistory objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getTeachersCardHistoryWithSid:(NSInteger)sid
                                               beginday:(NSString *)beginday
                                                lastday:(NSString *)lastday
                                                   page:(NSInteger)page
                                               pageSize:(NSInteger)pageSize
                                                  block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:beginday forKey:@"beginday"];
    [prameters setObject:lastday forKey:@"lastday"];
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/teacherIcardInfo_searchAllTeacherIcardList.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"userIcardRecordList"];
        NSArray *arr = [ZXCardHistory objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getClassCardHistoryWithSid:(NSInteger)sid
                                                 cid:(NSInteger)cid
                                            beginday:(NSString *)beginday
                                             lastday:(NSString *)lastday
                                                page:(NSInteger)page
                                            pageSize:(NSInteger)pageSize
                                               block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [prameters setObject:beginday forKey:@"beginday"];
    [prameters setObject:lastday forKey:@"lastday"];
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/studentrecord_searchAllStudentIcRecord.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"userIcardRecordList"];
        NSArray *arr = [ZXCardHistory objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
