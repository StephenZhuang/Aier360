//
//	ZXMessageTask.m
//
//	Create by Zhuang Stephen on 13/11/2015
//	Copyright © 2015 Zhixing Internet of Things Technology Co., Ltd.. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ZXMessageTask.h"
#import "NSNull+ZXNullValue.h"

@interface ZXMessageTask ()
@end
@implementation ZXMessageTask

+ (NSURLSessionDataTask *)getMessageTaskWithSid:(long)sid
                                          block:(void (^)(NSArray *array,NSInteger mesCount, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(sid) forKey:@"sid"];
    
    NSString *url = @"nxadminjs/messagetaskmap_searchMessageTask.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSArray *array = [ZXMessageTask objectArrayWithKeyValuesArray:[JSON objectForKey:@"mtList"]];
        NSInteger mesCount = [[JSON objectForKey:@"mesCount"] integerValue];
        !block?:block(array,mesCount,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,0,error);
    }];
}

- (NSURLSessionDataTask *)completeTaskWithBlock:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(GLOBAL_UID) forKey:@"uid"];
    [parameters setObject:@(self.mtid) forKey:@"mtid"];
    [parameters setObject:self.mtContent forKey:@"des"];
    
    NSString *url = @"nxadminjs/messagetask_receiveReward.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end