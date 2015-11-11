//
//  ZXAnnounceMessage.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/11.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnounceMessage.h"
#import "ZXApiClient.h"

@implementation ZXAnnounceMessage
+ (NSInteger)getMessageNumWithTextlength:(NSInteger)length
{
    //y = 62 + (x-1) * 67
    if (length <= 65) {
        return 1;
    } else {
        NSInteger num = ceilf((length - 62) / 67.0) + 1;
        return num;
    }
}

+ (NSURLSessionDataTask *)getSchoolMesCountWithSid:(NSInteger)sid
                                             block:(void (^)(BOOL success , NSInteger mesCount, NSString *errorInfo))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(sid) forKey:@"sid"];
    
    NSString *url = @"schooljs/schoolmessagen_searchMesCount.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        NSInteger mesCount = [[JSON objectForKey:@"mesCount"] integerValue];
        if (block) {
            if (baseModel) {
                if(baseModel.s) {
                    block(YES,mesCount , nil);
                } else {
                    block(NO, mesCount , baseModel.error_info);
                }
            } else {
                block(NO , mesCount , @"未知错误");
            }
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(NO,0,error.localizedDescription);
    }];
}

+ (NSURLSessionDataTask *)sendMessageWithMid:(long)mid
                                         sid:(NSInteger)sid
                                phoneContent:(NSString *)phoneContent
                                       block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(mid) forKey:@"mid"];
    [parameters setObject:@(sid) forKey:@"sid"];
    [parameters setObject:phoneContent forKey:@"phoneContent"];
    
    NSString *url = @"schooljs/schoolmessagen_sendPhoneMessage.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
