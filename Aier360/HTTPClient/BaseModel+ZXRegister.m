//
//  BaseModel+ZXRegister.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel+ZXRegister.h"

@implementation BaseModel (ZXRegister)

+ (NSURLSessionDataTask *)getCodeWithAccount:(NSString *)account
                                       authCode:(NSString *)authCode
                                     block:(void (^)(BaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:account forKey:@"account"];
    [prameters setObject:authCode forKey:@"authCode"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userregindex_showPhoneMessage.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:JSON];
        
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
