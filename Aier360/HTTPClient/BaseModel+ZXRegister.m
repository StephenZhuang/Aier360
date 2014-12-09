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
                                    authCode:(NSString *)authCode
                                       block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:account forKey:@"account"];
    [prameters setObject:authCode forKey:@"authCode"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userregindex_showPhoneMessage.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:phone forKey:@"account"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userregindex_checkPhone.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:phone forKey:@"account"];
    [prameters setObject:code forKey:@"Message"];
    return [[ZXApiClient sharedClient] POST:@"userjs/retpwd_checkCode.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:account forKey:@"account"];
    [prameters setObject:nickName forKey:@"nickname"];
    [prameters setObject:password forKey:@"pwd"];

    return [[ZXApiClient sharedClient] POST:@"userjs/userregindex_regUserApp.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
@end
