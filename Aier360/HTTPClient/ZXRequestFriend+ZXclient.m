//
//  ZXRequestFriend+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/2.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRequestFriend+ZXclient.h"

@implementation ZXRequestFriend (ZXclient)
+ (NSURLSessionDataTask *)getFriendRequestListWithUid:(long)uid
                                                block:(void (^)(NSArray *array, NSError *error))block
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/friend_searchRequestFriends.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"requestFriends"];
        NSArray *arr = [ZXRequestFriend objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)handleFriendRequestWithURfid:(long)rfid
                                                  type:(NSInteger)type
                                                block:(ZXCompletionBlock)block
{
    NSString *url = @"";
    switch (type) {
        case 0:
            url = @"nxadminjs/friend_approveRequestFriend.shtml?";
            break;
        case 1:
            url = @"nxadminjs/friend_rejectRequestFriend.shtml?";
            break;
        case 2:
            url = @"nxadminjs/friend_deletedRequestFriend.shtml?";
            break;
        default:
            break;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:rfid] forKey:@"requestFriend.rfid"];
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

@end
