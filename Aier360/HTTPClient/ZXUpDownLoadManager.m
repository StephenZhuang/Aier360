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
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
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
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
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
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:name fileName:fileName mimeType:mimeType error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/x-zip-compressed",@"text/html",@"application/json",@"application/x-www-form-urlencode"]];
    manager.responseSerializer = serializer;
    
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
@end
