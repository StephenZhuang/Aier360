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
            [prameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
            break;
        case ZXDynamicListTypeUser:
            [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
            break;
        case ZXDynamicListTypeFriend:
            [prameters setObject:[NSNumber numberWithInteger:fuid] forKey:@"fuid"];
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
        
        ZXDynamic *dynamic = [ZXDynamic objectWithKeyValues:[JSON objectForKey:@"dynamic"]];
        
        if (block) {
            block(dynamic, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

//new
+ (NSURLSessionDataTask *)getDynamicCommentListWithDid:(NSInteger)did
                                                  page:(NSInteger)page
                                              pageSize:(NSInteger)pageSize
                                                 block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];

    [prameters setObject:[NSNumber numberWithLong:did] forKey:@"personalDynamic.did"];
    
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"pageUtil.page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageUtil.page_size"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userDynamic_searchDynamicComments.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"dynamicCommentList"];
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
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
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
                                         touid:(NSInteger)touid
                                         block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [parameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    [parameters setObject:[NSNumber numberWithInteger:touid] forKey:@"touid"];
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
                                         touid:(NSInteger)touid
                                         block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:ptype] forKey:@"ptype"];
    [parameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    [parameters setObject:[NSNumber numberWithInteger:touid] forKey:@"touid"];
    
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
                                          touid:(NSInteger)touid
                                          block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [parameters setObject:content forKey:@"content"];
    [parameters setObject:[NSNumber numberWithInteger:touid] forKey:@"touid"];
    
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
                                               touid:(NSInteger)touid
                                               block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:dcid] forKey:@"dcid"];
    [parameters setObject:content forKey:@"content"];
    [parameters setObject:rname forKey:@"rname"];
    [parameters setObject:[NSNumber numberWithInteger:touid] forKey:@"touid"];
    
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

/////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSURLSessionDataTask *)commentDynamicWithUid:(NSInteger)uid
                                            did:(NSInteger)did
                                        content:(NSString *)content
                                           type:(NSInteger)type
                                          block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (type == 1) {
        [parameters setObject:@(uid) forKey:@"schoolDynamic.uid"];
        [parameters setObject:@(did) forKey:@"schoolDynamic.did"];
    } else {
        [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"personalDynamic.uid"];
        [parameters setObject:[NSNumber numberWithInteger:did] forKey:@"personalDynamic.did"];
    }
    [parameters setObject:content forKey:@"content"];
    
    NSString *url = type==1?@"schooljs/schoolDynamic_commentSchoolDynamic.shtml?":@"userjs/userDynamic_commentPersonalDynamic.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)replyDynamicCommentWithUid:(NSInteger)uid
                                                dcid:(NSInteger)dcid
                                               rname:(NSString *)rname
                                                ruid:(long)ruid
                                             content:(NSString *)content
                                                type:(NSInteger)type
                                               block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"dynamicCR.uid"];
    [parameters setObject:[NSNumber numberWithInteger:dcid] forKey:@"dynamicCR.dcid"];
    [parameters setObject:@(ruid) forKey:@"dynamicCR.ruid"];
    [parameters setObject:content forKey:@"dynamicCR.content"];
    [parameters setObject:rname forKey:@"dynamicCR.rname"];

    NSString *url = type==1?@"schooljs/schoolDynamic_replySchoolDynamic.shtml?":@"userjs/userDynamic_replyPersonalDynamic.shtml?";
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)deleteCommentDynamicWithDcid:(long)dcid
                                                 block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(dcid) forKey:@"dcid"];
    
    NSString *url = @"userjs/userDynamic_deleteDynamicComment.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)deleteReplyWithDcrid:(long)dcrid
                                         block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(dcrid) forKey:@"dcrid"];
    
    NSString *url = @"userjs/userDynamic_deleteDCR.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)informDynamicWithUid:(long)uid
                                           did:(long)did
                                          type:(NSInteger)type
                                       content:(NSString *)content
                                         block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(uid) forKey:@"inform.uid"];
    [parameters setObject:@(did) forKey:@"inform.did"];
    [parameters setObject:@(type) forKey:@"inform.informType"];
    [parameters setObject:content forKey:@"inform.typeStr"];
    NSString *url = @"schooljs/schoolDynamic_informDynamicMessage.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)getBrowseCountWithDid:(long)did
                                         block:(void(^)(NSInteger bcount))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(did) forKey:@"did"];
    
    NSString *url = @"userjs/userDynamic_searchDynamicBcount.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSInteger bcount = [[JSON objectForKey:@"bcount"] integerValue];
        !block?:block(bcount);
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(0);
    }];
}

#pragma mark - 3.2.0
+ (NSURLSessionDataTask *)getSensitiveDynamicCommentListWithSid:(NSInteger)sid
                                                           page:(NSInteger)page
                                                       pageSize:(NSInteger)pageSize
                                                            uid:(long)uid
                                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    
    [prameters setObject:@(sid) forKey:@"sid"];
    [prameters setObject:@(uid) forKey:@"uid"];
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/monitoring _searchDyCommentHasSensWord?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"objList"];
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

+ (NSURLSessionDataTask *)changeSensitiveDynamicCommentStateWithUid:(long)uid
                                                                did:(long)did
                                                               type:(NSInteger)type
                                                        commentType:(NSInteger)commentType
                                                                sid:(NSInteger)sid
                                                              block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(uid) forKey:@"uid"];
    if (did) {
        [parameters setObject:@(did) forKey:@"did"];
    }
    [parameters setObject:@(type) forKey:@"type"];
    [parameters setObject:@(commentType) forKey:@"commentType"];
    NSString *url = @"schooljs/monitoring_updateDyCommentHasSensWord.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
