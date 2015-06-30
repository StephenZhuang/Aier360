//
//  ZXUpDownLoadManager.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUpDownLoadManager.h"

@implementation ZXUpDownLoadManager
+ (NSURLSessionDownloadTask *)downloadTaskWithUrl:(NSString *)urlString
                                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    return [self downloadTaskWithUrl:urlString progress:nil completionHandler:completionHandler];
}

+ (NSURLSessionDownloadTask *)downloadTaskWithUrl:(NSString *)urlString
                                         progress:(NSProgress *__autoreleasing)progress
                                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFURLSessionManager *manager = [ZXApiClient sharedClient];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (completionHandler) {
            completionHandler(response , filePath , error);
        }
    }];
    [downloadTask resume];
    return downloadTask;
}

+ (NSURLSessionUploadTask *)uploadTaskWithUrl:(NSString *)urlString
                                         path:(NSString *)path
                            completionHandler:(void(^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    AFURLSessionManager *manager = [ZXApiClient sharedClient];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:path];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
        if (completionHandler) {
            completionHandler(response, responseObject , error);
        }
    }];
    [uploadTask resume];
    return uploadTask;
}

+ (NSURLSessionUploadTask *)uploadTaskWithUrl:(NSString *)urlString
                                         path:(NSString *)path
                                   parameters:(NSDictionary *)parameters
                                     progress:(NSProgress *__autoreleasing)progress
                                         name:(NSString *)name
                                     fileName:(NSString *)fileName
                                     mimeType:(NSString *)mimeType
                            completionHandler:(void(^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    AFURLSessionManager *manager = [ZXApiClient sharedClient];
    NSURL *url = [NSURL URLWithString:urlString relativeToURL:[ZXApiClient sharedClient].baseURL];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url.absoluteString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:name fileName:fileName mimeType:mimeType error:nil];
    } error:nil];
    
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
        if (completionHandler) {
            completionHandler(response, responseObject , error);
        }
    }];
    
    [uploadTask resume];
    return uploadTask;
}

+ (NSURLSessionDataTask *)uploadWithFile:(ZXFile *)file
                                     url:(NSString *)url
                              parameters:(NSMutableDictionary *)parameters
                                   block:(void(^)(NSDictionary *dictionary , NSError *error))block
{
    if (file.path) {
        return [self uploadTaskWithUrl:url path:file.path parameters:parameters progress:nil name:file.name fileName:file.fileName mimeType:file.mimeType completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (block) {
                block(responseObject , error);
            }
        }];
    } else {
        return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (block) {
                block(responseObject , nil);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (block) {
                block(nil , error);
            }
        }];
    }
}

+ (void)uploadImages:(NSArray *)filesArray
                type:(NSInteger)type
          completion:(void(^)(BOOL success,NSString *imagesString))completion
{
    if (filesArray.count <= 0) {
        !completion?:completion(YES,@"");
        return;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    
    dispatch_group_t group = dispatch_group_create();
    
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (ZXFile *file in filesArray) {
        dispatch_group_enter(group);
        [self uploadWithFile:file url:[NSURL URLWithString:@"commonjs/image_uploadImage.shtml?" relativeToURL:[ZXApiClient sharedClient].baseURL].absoluteString parameters:parameters block:^(NSDictionary *dictionary, NSError *error) {
            if (dictionary) {
                if (![[dictionary objectForKey:@"imageName"] isNull]) {
                    [array addObject:[dictionary objectForKey:@"imageName"]];
                }
            }
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (array.count == filesArray.count) {
            !completion?:completion(YES,[array componentsJoinedByString:@","]);
        } else {
            !completion?:completion(NO,@"上传出错，请重试");
        }
    });
}
@end
