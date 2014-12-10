//
//  ZXSchoolMasterEmail+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolMasterEmail+ZXclient.h"

@implementation ZXSchoolMasterEmail (ZXclient)
+ (NSURLSessionDataTask *)getEmailListWithSid:(NSInteger)sid
                                        block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/schoolmasterEmail_searchEmail.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"emailList"];
        NSArray *arr = [ZXSchoolMasterEmail objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)commentEmailListWithSuid:(NSInteger)suid
                                              ruid:(NSInteger)ruid
                                             smeid:(NSInteger)smeid
                                           content:(NSString *)content
                                               sid:(NSInteger)sid
                                             block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:suid] forKey:@"suid"];
    [parameters setObject:[NSNumber numberWithInteger:ruid] forKey:@"ruid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:smeid] forKey:@"smeid"];
    [parameters setObject:content forKey:@"content"];
    
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/schoolmasterEmail_replyEmail.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"emailList"];
        NSArray *arr = [ZXSchoolMasterEmail objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)sendEmailWithSuid:(NSInteger)suid
                                        sid:(NSInteger)sid
                                    content:(NSString *)content
                                      block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:suid] forKey:@"suid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:content forKey:@"content"];
    
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/schoolmasterEmail_sendEmail.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)deleteEmailWithSmeid:(NSInteger)smeid
                                         block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:smeid] forKey:@"smeid"];
    
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/schoolmasterEmail_deleteLetter.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)getEmailDetailListWithSid:(NSInteger)sid
                                                uid:(NSInteger)uid
                                              block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/schoolmasterEmail_searchEmailDetail.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"emailList"];
        NSArray *arr = [ZXSchoolMasterEmail objectArrayWithKeyValuesArray:array];
        
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
