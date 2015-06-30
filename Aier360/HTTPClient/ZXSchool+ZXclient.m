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
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:cityid forKey:@"scid"];
    [parameters setObject:schoolName forKey:@"words"];
    return [[ZXApiClient sharedClient] POST:@"userjs/lookup_searchSchoolByCidAndWord.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
                                      block:(void (^)(ZXSchool *school , ZXSchoolDetail *schoolDetail, NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/sbinfo_searchSchoolInfo.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXSchool *school = [ZXSchool objectWithKeyValues:[JSON objectForKey:@"school"]];
        ZXSchoolDetail *schoolDetail = [ZXSchoolDetail objectWithKeyValues:[JSON objectForKey:@"schoolInfoDetail"]];
        NSArray *array = [JSON objectForKey:@"stcList"];
        NSArray *arr = [ZXTeacherCharisma objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(school , schoolDetail,arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil ,nil,nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)updateSchoolInfoWithSid:(NSInteger)sid
                                          schools:(NSString *)schools
                                schoolInfoDetails:(NSString *)schoolInfoDetails
                                            block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:schools forKey:@"schools"];
    [parameters setObject:schoolInfoDetails forKey:@"schoolInfoDetails"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/sbinfo_updateSchoolDesinfoApp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            block(baseModel, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)updateSchoolInfoWithSid:(NSInteger)sid
                                          desinfo:(NSString *)desinfo
                                            phone:(NSString *)phone
                                          address:(NSString *)address
                                            sname:(NSString *)sname
                                            block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(sid) forKey:@"schoolIntroduce.sid"];
    [parameters setObject:desinfo forKey:@"schoolIntroduce.desinfo"];
    [parameters setObject:phone forKey:@"schoolIntroduce.phone"];
    [parameters setObject:address forKey:@"schoolIntroduce.address"];
    [parameters setObject:sname forKey:@"schoolIntroduce.name"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolInfo_modifySchoolIntroduce.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
