//
//  ZXAnnounceRead+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/20.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnounceRead+ZXclient.h"

@implementation ZXAnnounceRead (ZXclient)
+ (NSURLSessionDataTask *)getReaderListWithMid:(NSInteger)mid
                                         block:(void (^)(ZXAnnounceRead *baseModel, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:mid] forKey:@"mid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userBulletin_searchReadingList.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXAnnounceRead *announceRead = [ZXAnnounceRead objectWithKeyValues:JSON];
        
        if (block) {
            block(announceRead, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
