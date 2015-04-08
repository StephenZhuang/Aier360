//
//  ZXApiClient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXApiClient.h"

static NSString * const ZXAPIBaseURLString = @"http://www.aierbon.com/";
//static NSString * const ZXAPIBaseURLString = @"http://192.168.0.10:8080/aierbon/";

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
    self = [super initWithBaseURL:[NSURL URLWithString:ZXAPIBaseURLString]];
    if (self) {
        NSLog(@"BASE %@", self.baseURL);
        [self setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/x-zip-compressed",@"text/html",@"application/json",@"application/x-www-form-urlencode"]];
        [self setResponseSerializer:responseSerializer];
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
#ifdef DEBUG
        requestSerializer.timeoutInterval = 60;
#else
        requestSerializer.timeoutInterval = 20;
#endif
        [self setRequestSerializer:requestSerializer];
        self.requestSerializer.HTTPShouldHandleCookies = YES;
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

        [self successLog:task responseObject:responseObject];
        if (success) {
            success(task , responseObject);
        }
    } failure:^(NSURLSessionDataTask *task , NSError *error) {
        
        [self failureLog:task error:error];
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

        [self postSuccessLog:task responseObject:responseObject parameters:parameters];

        if (success) {
            success(task , responseObject);
        }
    } failure:^(NSURLSessionDataTask *task , NSError *error) {

        [self postFailureLog:task error:error parameters:parameters];

        if (failure) {
            failure(task , error);
        }
    }];
}

- (void)successLog:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
#ifdef DEBUG
    NSLog(@"------ REQUEST SUCCESS LOG ------");
    NSLog(@"Request %@", [task.response.URL absoluteString]);
//    NSLog(@"return %@",responseObject);
//    NSLog(@"response %@", task.response);
//    NSLog(@"Cookie %@", [task cookie]);
//    NSLog(@"header %@", [task header]);
    NSLog(@"-------------------------------");
#endif
}

- (void)postSuccessLog:(NSURLSessionDataTask *)task responseObject:(id)responseObject parameters:(id)parameters
{
#ifdef DEBUG
    NSString *jsonString = @"";
    
    for (NSString *key in [parameters keyEnumerator]) {
        jsonString = [jsonString stringByAppendingFormat:@"%@=%@&",key,[parameters objectForKey:key]];
    }
    NSLog(@"------ REQUEST SUCCESS LOG ------");
    NSLog(@"Request %@%@", [task.response.URL absoluteString] ,jsonString);
//    NSLog(@"return %@",responseObject);
    NSLog(@"response %@", task.response);
//    NSLog(@"Cookie %@", [task cookie]);
//    NSLog(@"header %@", [task header]);
    NSLog(@"-------------------------------");
#endif
}

- (void)failureLog:(NSURLSessionDataTask *)task error:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"------ REQUEST ERROR LOG START ------");
    NSLog(@"Request %@", [task.response.URL absoluteString]);
//    NSLog(@"response %@", task.response);
//    NSLog(@"Cookie %@", [task cookie]);
//    NSLog(@"header %@", [task header]);
    NSLog(@"Error %@", error.localizedDescription);
    NSLog(@"------ REQUEST ERROR LOG END ------");
    
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"statusCode: %i",response.statusCode] message:error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"), nil] show];
        });
    }
#endif
}

- (void)postFailureLog:(NSURLSessionDataTask *)task error:(NSError *)error parameters:(id)parameters
{
#ifdef DEBUG
    NSString *jsonString = @"";
    
    for (NSString *key in [parameters keyEnumerator]) {
        jsonString = [jsonString stringByAppendingFormat:@"%@=%@&",key,[parameters objectForKey:key]];
    }
    NSLog(@"------ REQUEST ERROR LOG START ------");
    NSLog(@"Request %@%@", [task.response.URL absoluteString] ,jsonString);
    NSLog(@"response %@", task.response);
//    NSLog(@"Cookie %@", [task cookie]);
//    NSLog(@"header %@", [task header]);
    NSLog(@"Error %@", error.localizedDescription);
    NSLog(@"------ REQUEST ERROR LOG END ------");
    
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"statusCode: %i",response.statusCode] message:error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"), nil] show];
        });
    }
#endif
}

@end

@implementation NSURLSessionTask (cookie)

- (NSString *)cookie
{
    NSString *cookie = @"";
    if ([self.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.response;
        NSString *cookieString = response.allHeaderFields[@"Set-Cookie"];
        return cookieString;
    }
    return cookie;
}

- (NSDictionary *)header
{
    NSDictionary *dic = [[NSDictionary alloc] init];
    if ([self.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.response;
        dic = response.allHeaderFields;
    }
    return dic;
}
@end
