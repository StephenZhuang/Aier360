//
//  ZXCity+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCity+ZXclient.h"

@implementation ZXCity (ZXclient)

+ (NSURLSessionDataTask *)getCities:(NSString *)cityid
                                     block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:cityid forKey:@"cityId"];
    return [[ZXApiClient sharedClient] POST:@"commonjs/loadCity.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"proOrCityList"];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSDictionary *cityDic in array) {
            ZXCity *city = [ZXCity insertWithAttribute:@"cid" value:[cityDic objectForKey:@"cid"]];
            [city update:cityDic];
            [city save];
            [arr addObject:city];
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
