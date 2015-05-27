//
//  ZXPersonalDynamic+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/27.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPersonalDynamic+ZXclient.h"

@implementation ZXPersonalDynamic (ZXclient)
+ (NSURLSessionDataTask *)addDynamicWithUid:(long)uid
                                    content:(NSString *)content
                                        img:(NSString *)img
                                 relativeid:(long)relativeid
                                  authority:(NSInteger)authority
                                      block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"personalDynamic.uid"];
    [parameters setObject:content forKey:@"personalDynamic.content"];
    [parameters setObject:img forKey:@"personalDynamic.img"];
    [parameters setObject:[NSNumber numberWithLong:relativeid] forKey:@"personalDynamic.relativeid"];
    [parameters setObject:[NSNumber numberWithInteger:authority] forKey:@"personalDynamic.authority"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/userDynamic_publishDynamic.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
