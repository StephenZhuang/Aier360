//
//  ZXApiClient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ZXApiClient : AFHTTPSessionManager
+ (instancetype)sharedClient;

/**
 *  GET
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  POST
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSMutableDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end

@interface NSURLSessionTask (cookie)
@property (nonatomic , copy , readonly) NSString *cookie;
@property (nonatomic , strong , readonly) NSDictionary *header;
@end