//
//  ZXAnnouncement+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncement+ZXclient.h"

@implementation ZXAnnouncement (ZXclient)
+ (NSURLSessionDataTask *)addAnnoucementWithSid:(long)sid
                                            tid:(long)tid
                                          title:(NSString *)title
                                           type:(NSInteger)type
                                            img:(NSString *)img
                                        message:(NSString *)message
                                           tids:(NSString *)tids
                                          block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:sid] forKey:@"schoolMessage.sid"];
    [parameters setObject:@(tid) forKey:@"schoolMessage.tid"];
    [parameters setObject:title forKey:@"schoolMessage.title"];
    [parameters setObject:@(type) forKey:@"schoolMessage.type"];
    [parameters setObject:img forKey:@"schoolMessage.img"];
    if (tids) {
        [parameters setObject:tids forKey:@"schoolMessage.tids"];
    }
    [parameters setObject:message forKey:@"schoolMessage.message"];
    
    NSString *url = @"schooljs/schoolmessagen_addSchoolMessage.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)deleteAnnoucementWithMid:(long)mid
                                             block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(mid) forKey:@"mid"];
    
    NSString *url = @"schooljs/schoolmessagen_deleteSchoolMessage.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)getAnnoucementWithUid:(long)uid
                                            mid:(long)mid
                                          block:(void (^)(ZXAnnouncement *announcement, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(uid) forKey:@"uid"];
    [parameters setObject:@(mid) forKey:@"mid"];
    
    NSString *url = @"schooljs/schoolmessagen_searchDetailSchoolMessage.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXAnnouncement *announcement = [ZXAnnouncement objectWithKeyValues:[JSON objectForKey:@"schoolMessage"]];
        !block?:block(announcement,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}

+ (NSURLSessionDataTask *)getAnnoucementListWithUid:(long)uid
                                                sid:(NSInteger)sid
                                               page:(NSInteger)page
                                           pageSize:(NSInteger)pageSize
                                              block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(uid) forKey:@"uid"];
    [parameters setObject:@(sid) forKey:@"sid"];
    [parameters setObject:@(page) forKey:@"pageUtil.page"];
    [parameters setObject:@(pageSize) forKey:@"pageUtil.page_size"];
    
    NSString *url = @"schooljs/schoolmessagen_searchSchoolMessage.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSArray *arr = [JSON objectForKey:@"schoolMessages"];
        NSArray *array = [ZXAnnouncement objectArrayWithKeyValuesArray:arr];
        !block?:block(array,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}

+ (NSURLSessionDataTask *)remindAnnoucementWithMid:(long)mid
                                               sid:(NSInteger)sid
                                             block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(mid) forKey:@"mid"];
    [parameters setObject:@(sid) forKey:@"sid"];
    NSString *url = @"schooljs/schoolmessagen_remindUnreadedUser.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)getAnnoucementUnreadWithSid:(long)sid
                                                  mid:(long)mid
                                                 type:(NSInteger)type
                                                block:(void (^)(ZXAnnouncement *announcement, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(sid) forKey:@"sid"];
    [parameters setObject:@(mid) forKey:@"mid"];
    [parameters setObject:@(type) forKey:@"type"];
    
    NSString *url = @"schooljs/schoolmessagen_searchUnreadUser.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXAnnouncement *announcement = [ZXAnnouncement objectWithKeyValues:[JSON objectForKey:@"schoolMessage"]];
        !block?:block(announcement,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}
@end
