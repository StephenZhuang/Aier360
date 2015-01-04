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
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:yearAndMonthStr forKey:@"yearAndMonthStr"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/teacherIcardInfo_searchTeacherIcardInfoByUidYearMonth.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:beginday forKey:@"beginday"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/studentrecord_searchTeacherInOutDetail.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
    [parameters setObject:yearAndMonthStr forKey:@"yearAndMonthStr"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/teacherIcardInfo_searchTeacherInOutDetail.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:beginday forKey:@"beginday"];
    [parameters setObject:lastday forKey:@"lastday"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/teacherIcardInfo_searchAllTeacherIcardList.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:beginday forKey:@"beginday"];
    [parameters setObject:lastday forKey:@"lastday"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/studentrecord_searchAllStudentIcRecord.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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

+ (NSURLSessionDataTask *)getBabyDetailCardHistoryWithUid:(NSInteger)uid
                                                 beginday:(NSString *)beginday
                                                    block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    
    NSAssert(beginday != nil, @"beginday must be non-nil");
    
    [parameters setObject:beginday forKey:@"beginday"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/studentrecord_searchTeacherInOutDetail.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
@end
