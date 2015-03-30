//
//  BaseModel+ZXRegister.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel+ZXRegister.h"

@implementation ZXBaseModel (ZXRegister)

+ (NSURLSessionDataTask *)getCodeWithAccount:(NSString *)account
                                  randomChar:(NSString *)randomChar
                                       block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:account forKey:@"account"];
    [parameters setObject:randomChar forKey:@"randomChar"];
    return [[ZXApiClient sharedClient] POST:@"userjs/useraccountnew_showRegPhoneMessageCode.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            block(baseModel, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)checkPhoneHasRegister:(NSString *)phone
                                          block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:phone forKey:@"account"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userregindex_checkPhone.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            block(baseModel, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)checkCode:(NSString *)code
                              phone:(NSString *)phone
                              block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:phone forKey:@"account"];
    [parameters setObject:code forKey:@"Message"];
    return [[ZXApiClient sharedClient] POST:@"userjs/retpwd_checkCode.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            block(baseModel, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)registerWithAccount:(NSString *)account
                                     password:(NSString *)password
                                     nickName:(NSString *)nickName
                                        block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:account forKey:@"account"];
    [parameters setObject:nickName forKey:@"nickname"];
    [parameters setObject:password forKey:@"pwd"];

    return [[ZXApiClient sharedClient] POST:@"userjs/userregindex_regUserApp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            block(baseModel, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)changePasswordWithAccount:(NSString *)account
                                           password:(NSString *)password
                                             oldpwd:(NSString *)oldpwd
                                              block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:account forKey:@"account"];
    [parameters setObject:password forKey:@"pwd"];
    [parameters setObject:oldpwd forKey:@"oldpwd"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/retpwd_changeUserPwdApp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)forgetPasswordWithAccount:(NSString *)account
                                           password:(NSString *)password
                                              block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:account forKey:@"account"];
    [parameters setObject:password forKey:@"pwd"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/retpwd_forgetPwd.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)getRandomChar:(void (^)(NSString *randomChar ,NSString *error_info))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/useraccountnew_getRandom.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSString *randomChar = [JSON objectForKey:@"randomChar"];
        if (block) {
            block(randomChar ,[JSON objectForKey:@"error_info"]);
        }
        
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *response1 = (NSHTTPURLResponse *)task.response;
            NSString *cookieString = response1.allHeaderFields[@"Set-Cookie"];
            if (cookieString) {
                [[ZXApiClient sharedClient].requestSerializer setValue:cookieString forHTTPHeaderField:@"Set-Cookie"];
            }
        }
        

    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil,error.localizedDescription);
        }
    }];
}
@end
