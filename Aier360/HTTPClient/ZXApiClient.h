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
@end

@interface NSURLSessionTask (cookie)
@property (nonatomic , copy , readonly) NSString *cookie;
@end