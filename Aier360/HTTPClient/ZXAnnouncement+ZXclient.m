//
//  ZXAnnouncement+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncement+ZXclient.h"

@implementation ZXAnnouncement (ZXclient)
+ (NSURLSessionDataTask *)getAnnouncementListWithSid:(NSInteger)sid
                                                 cid:(NSInteger)cid
                                                 uid:(NSInteger)uid
                                            appState:(NSInteger)appState
                                                page:(NSInteger)page
                                            pageSize:(NSInteger)pageSize
                                               block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [prameters setObject:[NSNumber numberWithInteger:appState] forKey:@"appState"];
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userBulletin_searchSchoolMessageList_App.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolMessageList"];
        NSArray *arr = [ZXAnnouncement objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)readAnnouncementWithMid:(NSInteger)mid
                                              tid:(NSInteger)tid
                                              uid:(NSInteger)uid
                                            block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:mid] forKey:@"mid"];
    [prameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
    [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userBulletin_searchDetail.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            block(baseModel, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getSmsCountWithSid:(NSInteger)sid
                                         cid:(NSInteger)cid
                                    sendType:(NSInteger)sendType
                                       block:(void (^)(NSInteger totalMessage , NSInteger mesCount, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [prameters setObject:[NSNumber numberWithInteger:sendType] forKey:@"sendType"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userhscb_searchSchoolMescount.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSNumber *totalNum = [JSON objectForKey:@"totalMessage"];
        NSNumber *mes = [JSON objectForKey:@"mesCount"];
        
        NSInteger mesCount = 0;
        if (![mes isEqual:[NSNull null]]) {
            mesCount = mes.integerValue;
        }
        
        NSInteger totalMessage = 0;
        if (![totalNum isEqual:[NSNull null]]) {
            totalMessage = totalNum.integerValue;
        }
        
        if (block) {
            block(totalMessage , mesCount, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(0 , 0, error);
        }
    }];
}

+ (NSURLSessionDataTask *)publishAnnouncementWithhSid:(NSInteger)sid
                                         cid:(NSInteger)cid
                                    sendType:(NSInteger)sendType
                                       block:(void (^)(NSInteger totalMessage , NSInteger mesCount, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [prameters setObject:[NSNumber numberWithInteger:sendType] forKey:@"sendType"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userhscb_searchSchoolMescount.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSNumber *totalNum = [JSON objectForKey:@"totalMessage"];
        NSNumber *mes = [JSON objectForKey:@"mesCount"];
        
        NSInteger mesCount = 0;
        if (![mes isEqual:[NSNull null]]) {
            mesCount = mes.integerValue;
        }
        
        NSInteger totalMessage = 0;
        if (![totalNum isEqual:[NSNull null]]) {
            totalMessage = totalNum.integerValue;
        }
        
        if (block) {
            block(totalMessage , mesCount, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(0 , 0, error);
        }
    }];
}

@end
