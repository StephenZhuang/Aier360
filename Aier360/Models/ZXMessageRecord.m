//
//	ZXMessageRecord.m
//
//	Create by Zhuang Stephen on 13/11/2015
//	Copyright © 2015 Zhixing Internet of Things Technology Co., Ltd.. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ZXMessageRecord.h"

@interface ZXMessageRecord ()
@end
@implementation ZXMessageRecord

+ (NSURLSessionDataTask *)getMessageRecordWithSid:(long)sid
                                            block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(sid) forKey:@"sid"];
    
    NSString *url = @"nxadminjs/messagetask_searchRecord.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSArray *array = [ZXMonthMessageRecord objectArrayWithKeyValuesArray:[JSON objectForKey:@"results"]];
        !block?:block(array,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}

- (NSURLSessionDataTask *)getMessageDetailWithBlock:(void (^)(ZXMessageRecord *messageRecord, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(self.bid) forKey:@"bid"];
    
    NSString *url = @"nxadminjs/messagetaskmap_searchRecordDetail.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXMessageRecord *messageRecord = [ZXMessageRecord objectWithKeyValues:[JSON objectForKey:@"mr"]];
        !block?:block(messageRecord,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}

@end

@implementation ZXMonthMessageRecord

- (NSDictionary *)objectClassInArray
{
    return @{@"mrList" : [ZXMessageRecord class]
             };
}

@end