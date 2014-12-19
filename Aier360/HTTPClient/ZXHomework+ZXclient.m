//
//  ZXHomework+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomework+ZXclient.h"

@implementation ZXHomework (ZXclient)
+ (NSURLSessionDataTask *)getClassHomeworkListWithUid:(NSInteger)uid
                                                  sid:(NSInteger)sid
                                                  cid:(NSInteger)cid
                                                 page:(NSInteger)page
                                            page_size:(NSInteger)page_size
                                                block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:page_size] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userHomework_searchHomework.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"hwList"];
        NSArray *arr = [ZXHomework objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getAllClassHomeworkListWithUid:(NSInteger)uid
                                                     sid:(NSInteger)sid
                                                    page:(NSInteger)page
                                               page_size:(NSInteger)page_size
                                                   block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:page_size] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userHomework_searchAllHomeworks.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"hwList"];
        NSArray *arr = [ZXHomework objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getHomeworkDetailWithUid:(NSInteger)uid
                                               hid:(NSInteger)hid
                                             block:(void (^)(ZXHomework *homework, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:hid] forKey:@"hid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userHomework_searchAllHomeworks.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXHomework *homework = [ZXHomework objectWithKeyValues:[JSON objectForKey:@"homework"]];
        
        if (block) {
            block(homework, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getHomeworkReadListWithHid:(NSInteger)hid
                                                 sid:(NSInteger)sid
                                               block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:hid] forKey:@"hid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userHomework_seacherHomeworkReadedList.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"homeworkReadeds"];
        NSArray *arr = [ZXHomeworkRead objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)deleteHomeworkWithHid:(NSInteger)hid
                                          block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:hid] forKey:@"hid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userHomework_deleteHomework.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)commentHomeworkWithHid:(NSInteger)hid
                                             sid:(NSInteger)sid
                                         content:(NSString *)content
                                            type:(NSInteger)type
                                             uid:(NSInteger)uid
                                             tid:(NSInteger)tid
                                        filePath:(NSString *)filePath
                                          block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:hid] forKey:@"hid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
    [parameters setObject:content forKey:@"content"];
    
    if (filePath) {
        [parameters setObject:@"newzipfile.zip" forKey:@"photoName"];
    }
    
    ZXFile *file = [[ZXFile alloc] init];
    file.path = filePath;
    file.name = @"image";
    
    return [ZXUpDownLoadManager uploadWithFile:file url:@"userjs/comment_hw.shtml" parameters:parameters block:^(NSDictionary *dictionary, NSError *error) {
        if (dictionary) {
            ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:dictionary];
            [ZXBaseModel handleCompletion:block baseModel:baseModel];
        } else {
            [ZXBaseModel handleCompletion:block error:error];
        }
    }];
    
}

+ (NSURLSessionDataTask *)replyCommentWithChid:(NSInteger)chid
                                           sid:(NSInteger)sid
                                       content:(NSString *)content
                                          type:(NSInteger)type
                                           uid:(NSInteger)uid
                                           tid:(NSInteger)tid
                                         crhid:(NSInteger)crhid
                                         touid:(NSInteger)touid
                                         block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:chid] forKey:@"chid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
    [parameters setObject:[NSNumber numberWithInteger:crhid] forKey:@"crhid"];
    [parameters setObject:[NSNumber numberWithInteger:touid] forKey:@"touid"];
    [parameters setObject:content forKey:@"content"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/userHomework_replyCommentApp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)addHomeworkWithSid:(NSInteger)sid
                                     content:(NSString *)content
                                       title:(NSString *)title
                                         cid:(NSInteger)cid
                                         tid:(NSInteger)tid
                                 isSendPhone:(BOOL)isSendPhone
                                    filePath:(NSString *)filePath
                                       block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithBool:isSendPhone] forKey:@"isSendPhone"];
    [parameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
    [parameters setObject:content forKey:@"content"];
    [parameters setObject:title forKey:@"title"];
    
    if (filePath) {
        [parameters setObject:@"newzipfile.zip" forKey:@"photoName"];
    }
    
    ZXFile *file = [[ZXFile alloc] init];
    file.path = filePath;
    file.name = @"file";
    
    return [ZXUpDownLoadManager uploadWithFile:file url:@"userjs/publish_hw.shtml" parameters:parameters block:^(NSDictionary *dictionary, NSError *error) {
        if (dictionary) {
            ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:dictionary];
            [ZXBaseModel handleCompletion:block baseModel:baseModel];
        } else {
            [ZXBaseModel handleCompletion:block error:error];
        }
    }];
    
}
@end
