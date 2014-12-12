//
//  ZXDynamic+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamic+ZXclient.h"

@implementation ZXDynamic (ZXclient)
+ (NSURLSessionDataTask *)getDynamicListWithSid:(NSInteger)sid
                                            uid:(NSInteger)uid
                                            cid:(NSInteger)cid
                                           fuid:(NSInteger)fuid
                                           type:(ZXDynamicListType)type
                                           page:(NSInteger)page
                                       pageSize:(NSInteger)pageSize
                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    switch (type) {
        case ZXDynamicListTypeSchool:
            [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
            break;
        case ZXDynamicListTypeClass:
            [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"cid"];
            break;
        case ZXDynamicListTypeUser:
            [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"uid"];
            break;
        case ZXDynamicListTypeFriend:
            [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"fuid"];
            break;
            
        default:
            [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
            break;
    }
    
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_searchDynamicList.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"dynamicList"];
        NSArray *arr = [ZXDynamic objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getDynamicDetailWithUid:(NSInteger)uid
                                              did:(NSInteger)did
                                            block:(void (^)(ZXDynamic *dynamic, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [prameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_searchDynamicDetail.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXDynamic *dynamic = [ZXDynamic objectWithKeyValues:JSON];
        
        if (block) {
            block(dynamic, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getDynamicCommentListWithDid:(NSInteger)did
                                                  page:(NSInteger)page
                                              pageSize:(NSInteger)pageSize
                                                 block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];

    [prameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_searchCommentByDid.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"dcList"];
        NSArray *arr = [ZXDynamicComment objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)addDynamicWithUid:(NSInteger)uid
                                        sid:(NSInteger)sid
                                        cid:(NSInteger)cid
                                    content:(NSString *)content
                                       type:(NSInteger)type
                                   filePath:(NSString *)filePath
                                      block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [parameters setObject:content forKey:@"content"];
    
    if (filePath) {
        [parameters setObject:@"newzipfile.zip" forKey:@"photoName"];
        NSURL *url = [NSURL URLWithString:@"nxadminjs/Dynamic_publishDynamicApp.shtml?" relativeToURL:[ZXApiClient sharedClient].baseURL];
        return [ZXUpDownLoadManager uploadTaskWithUrl:url.absoluteString path:filePath parameters:parameters progress:nil name:@"file" fileName:@"newzipfile.zip" mimeType:@"application/octet-stream" completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
            if (error) {
                [ZXBaseModel handleCompletion:block error:error];
            } else {
                ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:responseObject];
                [ZXBaseModel handleCompletion:block baseModel:baseModel];
            }
        }];
    } else {
        return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_publishDynamicApp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
            ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
            [ZXBaseModel handleCompletion:block baseModel:baseModel];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [ZXBaseModel handleCompletion:block error:error];
        }];
    }
}


+ (NSURLSessionDataTask *)repostDynamicWithUid:(NSInteger)uid
                                           sid:(NSInteger)sid
                                           cid:(NSInteger)cid
                                       content:(NSString *)content
                                          type:(NSInteger)type
                                           did:(NSInteger)did
                                         block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [parameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    [parameters setObject:content forKey:@"content"];

    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_transmitDynamic.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)praiseDynamicWithUid:(NSInteger)uid
                                         ptype:(NSInteger)ptype
                                           did:(NSInteger)did
                                         block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:ptype] forKey:@"ptype"];
    [parameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_praiseDynamic.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)commentDynamicWithUid:(NSInteger)uid
                                            sid:(NSInteger)sid
                                            did:(NSInteger)did
                                        content:(NSString *)content
                                           type:(NSInteger)type
                                       filePath:(NSString *)filePath
                                          block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [parameters setObject:content forKey:@"content"];
    
    if (filePath) {
        [parameters setObject:@"newzipfile.zip" forKey:@"photoName"];
        
        NSURL *url = [NSURL URLWithString:@"nxadminjs/Dynamic_commentDynamic.shtml?" relativeToURL:[ZXApiClient sharedClient].baseURL];
        return [ZXUpDownLoadManager uploadTaskWithUrl:url.absoluteString path:filePath parameters:parameters progress:nil name:@"file" fileName:@"newzipfile.zip" mimeType:@"application/octet-stream" completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
            if (error) {
                [ZXBaseModel handleCompletion:block error:error];
            } else {
                ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:responseObject];
                [ZXBaseModel handleCompletion:block baseModel:baseModel];
            }
        }];
    } else {
        return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_commentDynamic.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
            
            ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
            [ZXBaseModel handleCompletion:block baseModel:baseModel];
            
        } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
            [ZXBaseModel handleCompletion:block error:error];
        }];
    }
}

+ (NSURLSessionDataTask *)replyDynamicCommentWithUid:(NSInteger)uid
                                                dcid:(NSInteger)dcid
                                               rname:(NSString *)rname
                                             content:(NSString *)content
                                               block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:dcid] forKey:@"dcid"];
    [parameters setObject:content forKey:@"content"];
    [parameters setObject:rname forKey:@"rname"];
    
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_replyDynamic.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)deleteDynamicWithDid:(NSInteger)did
                                         block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_deleteDynamic.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
