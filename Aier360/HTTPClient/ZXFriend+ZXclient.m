//
//  ZXFriend+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/1.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFriend+ZXclient.h"
#import "NSManagedObject+ZXRecord.h"

@implementation ZXFriend (ZXclient)
+ (NSURLSessionDataTask *)getFriendListWithUid:(long)uid
                                         block:(void (^)(NSArray *array, NSError *error))block
{
    NSString *key = [NSString stringWithFormat:@"version%@",@(uid)];
    
    NSNumber *version = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!version) {
        version = @(0);
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:version forKey:@"version"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/friend_serarchFriends.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"friends"];
        [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"version"] forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if (![array isNull]) {
            for (NSDictionary *friendDic in array) {
                ZXFriend *friend = [ZXFriend insertWithAttribute:@"fid" value:[friendDic objectForKey:@"fid"]];
                [friend update:friendDic];
                
                if (friend.type == 3) {
                    [friend delete];
                }
                [friend save];
            }
        }
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
