//
//  ZXUpDownLoadManager.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFURLSessionManager.h>

@interface ZXUpDownLoadManager : NSObject
/**
 *  简单的下载
 *
 *  @param urlString         下载地址
 *  @param completionHandler 成功的回调
 *
 *  @return NSURLSessionDownloadTask 下载任务
 */
+ (NSURLSessionDownloadTask *)downloadTaskWithUrl:(NSString *)urlString
                                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/**
 *  带有progress的下载
 *
 *  @param urlString         下载地址
 *  @param progress          进度
 *  @param completionHandler 成功的回调
 *
 *  @return NSURLSessionDownloadTask 下载任务
 */
+ (NSURLSessionDownloadTask *)downloadTaskWithUrl:(NSString *)urlString
                                         progress:(NSProgress *__autoreleasing)progress
                                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/**
 *  简单的上传
 *
 *  @param urlString         上传地址
 *  @param path              上传文件的路径
 *  @param completionHandler 成功的回调
 *
 *  @return NSURLSessionUploadTask 上传任务
 */
+ (NSURLSessionUploadTask *)uploadTaskWithUrl:(NSString *)urlString
                                         path:(NSString *)path
                            completionHandler:(void(^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

/**
 *  复杂的上传
 *
 *  @param urlString         上传地址
 *  @param path              上传文件路径
 *  @param parameters        参数
 *  @param progress          进度
 *  @param name              名称
 *  @param fileName          文件名
 *  @param mineType          文件类型 "text/txt","image/png" etc.
 *  @param completionHandler 成功的回调
 *
 *  @return NSURLSessionUploadTask 上传任务
 */
+ (NSURLSessionUploadTask *)uploadTaskWithUrl:(NSString *)urlString
                                         path:(NSString *)path
                                   parameters:(NSDictionary *)parameters
                                     progress:(NSProgress *__autoreleasing)progress
                                         name:(NSString *)name
                                     fileName:(NSString *)fileName
                                     mineType:(NSString *)mineType
                            completionHandler:(void(^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;
@end
