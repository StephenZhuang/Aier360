//
//  ZXSchool+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchool+ZXclient.h"

@implementation ZXSchool (ZXclient)
+ (NSURLSessionDataTask *)searchSchoolWithCityid:(NSString *)cityid
                                      schoolName:(NSString *)schoolName
                                           block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:cityid forKey:@"scid"];
    [prameters setObject:schoolName forKey:@"words"];
    return [[ZXApiClient sharedClient] POST:@"userjs/lookup_searchSchoolByCidAndWord.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolList"];
        NSArray *arr = [ZXSchool objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)schoolInfoWithSid:(NSInteger)sid
                                      block:(void (^)(ZXSchool *school , ZXSchoolDetail *schoolDetail, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/sbinfo_searchSchoolInfo.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXSchool *school = [ZXSchool objectWithKeyValues:[JSON objectForKey:@"school"]];
        ZXSchoolDetail *schoolDetail = [ZXSchoolDetail objectWithKeyValues:[JSON objectForKey:@"schoolInfoDetail"]];
        
        if (block) {
            block(school , schoolDetail, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil ,nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)updateSchoolInfoWithSid:(NSInteger)sid
                                          schools:(NSString *)schools
                                schoolInfoDetails:(NSString *)schoolInfoDetails
                                            block:(void (^)(BaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:schools forKey:@"schools"];
    [prameters setObject:schoolInfoDetails forKey:@"schoolInfoDetails"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/sbinfo_updateSchoolDesinfoApp.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
