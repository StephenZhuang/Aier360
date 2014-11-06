//
//  ZXApiClient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXApiClient.h"

static NSString * const ZXAPIDebugBaseURLString = @"http://192.168.20.245:8080/aier360/";
static NSString * const ZXAPIBaseURLString = @"http://www.aier360.com/";

@implementation ZXApiClient

+ (instancetype)sharedClient {
    static ZXApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[[self class] alloc] init];
    });
    
    return _sharedClient;
}

- (id) init
{
#ifdef DEBUG
    self = [super initWithBaseURL:[NSURL URLWithString:ZXAPIDebugBaseURLString]];
#else
    self = [super initWithBaseURL:[NSURL URLWithString:ZXAPIBaseURLString]];
#endif
    if (self) {
        NSLog(@"BASE %@", self.baseURL);
        [self setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [self startReachabilityMonitor];
    }
    return self;
}

- (void)startReachabilityMonitor
{
    NSOperationQueue *operationQueue = self.operationQueue;
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                NSLog(@"Reachability Ok");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                NSLog(@"Reachability Ok");
                break;
        }
    }];
    
    [self.reachabilityManager startMonitoring];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [super GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task , id responseObject) {
#ifdef DEBUG
        [self successLog:task responseObject:responseObject];
#endif
        if (success) {
            success(task , responseObject);
        }
    } failure:^(NSURLSessionDataTask *task , NSError *error) {
#ifdef DEBUG
        [self failureLog:task error:error];
#endif
        if (failure) {
            failure(task , error);
        }
    }];
}



- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [super POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task , id responseObject) {
#ifdef DEBUG
        [self postSuccessLog:task responseObject:responseObject parameters:parameters];
#endif
        if (success) {
            success(task , responseObject);
        }
    } failure:^(NSURLSessionDataTask *task , NSError *error) {
#ifdef DEBUG
        [self postFailureLog:task error:error parameters:parameters];
#endif
        if (failure) {
            failure(task , error);
        }
    }];
}

- (void)successLog:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
    NSLog(@"------ REQUEST SUCCESS LOG ------");
    NSLog(@"Request %@", [task.response.URL absoluteString]);
//    NSLog(@"return %@",responseObject);
//    NSLog(@"response %@", task.response);
    NSLog(@"Cookie %@", [task cookie]);
    NSLog(@"-------------------------------");
}

- (void)postSuccessLog:(NSURLSessionDataTask *)task responseObject:(id)responseObject parameters:(id)parameters
{
    NSString *jsonString = @"";
    
    for (NSString *key in [parameters keyEnumerator]) {
        jsonString = [jsonString stringByAppendingFormat:@"%@=%@&",key,[parameters objectForKey:key]];
    }
    NSLog(@"------ REQUEST SUCCESS LOG ------");
    NSLog(@"Request %@%@", [task.response.URL absoluteString] ,jsonString);
//    NSLog(@"return %@",responseObject);
    NSLog(@"response %@", task.response);
    NSLog(@"Cookie %@", [task cookie]);
    NSLog(@"-------------------------------");
}

- (void)failureLog:(NSURLSessionDataTask *)task error:(NSError *)error
{
    NSLog(@"------ REQUEST ERROR LOG START ------");
    NSLog(@"Request %@", [task.response.URL absoluteString]);
//    NSLog(@"response %@", task.response);
    NSLog(@"Cookie %@", [task cookie]);
    NSLog(@"Error %@", error.localizedDescription);
    NSLog(@"------ REQUEST ERROR LOG END ------");
    
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"statusCode: %i",response.statusCode] message:error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"), nil] show];
        });
    }
}

- (void)postFailureLog:(NSURLSessionDataTask *)task error:(NSError *)error parameters:(id)parameters
{
    NSString *jsonString = @"";
    
    for (NSString *key in [parameters keyEnumerator]) {
        jsonString = [jsonString stringByAppendingFormat:@"%@=%@&",key,[parameters objectForKey:key]];
    }
    NSLog(@"------ REQUEST ERROR LOG START ------");
    NSLog(@"Request %@%@", [task.response.URL absoluteString] ,jsonString);
    //    NSLog(@"response %@", task.response);
    NSLog(@"Cookie %@", [task cookie]);
    NSLog(@"Error %@", error.localizedDescription);
    NSLog(@"------ REQUEST ERROR LOG END ------");
    
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"statusCode: %i",response.statusCode] message:error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"), nil] show];
        });
    }
}

@end

@implementation NSURLSessionTask (cookie)

- (NSString *)cookie
{
    NSString *cookie = @"";
    if ([self.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.response;
        NSString *cookieString = response.allHeaderFields[@"Set-Cookie"];
        if (cookieString.length > 0) {
            cookie = [[[[cookieString componentsSeparatedByString:@";"] firstObject] componentsSeparatedByString:@"="] lastObject];
        }
    }
    return cookie;
}

@end
