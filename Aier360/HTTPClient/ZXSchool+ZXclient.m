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

+ (NSURLSessionDataTask *)updateSchoolInfoDesinfo:(NSString *)desinfo
                                            phone:(NSString *)phone
                                          address:(NSString *)address
                                             name:(NSString *)name
                                           nature:(NSString *)nature
                                        longitude:(NSString *)longitude
                                         latitude:(NSString *)latitude
                                            block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@([ZXUtils sharedInstance].currentSchool.sid) forKey:@"schoolIntroduce.sid"];
    if (desinfo) {
        [parameters setObject:desinfo forKey:@"schoolIntroduce.desinfo"];
    }
    if (phone) {
        [parameters setObject:phone forKey:@"schoolIntroduce.phone"];
    }
    if (address) {
        [parameters setObject:address forKey:@"schoolIntroduce.address"];
    }
    if (name) {
        [parameters setObject:name forKey:@"schoolIntroduce.name"];
    }
    if (nature) {
        [parameters setObject:nature forKey:@"schoolIntroduce.nature"];
    }
    if (latitude) {
        [parameters setObject:latitude forKey:@"schoolIntroduce.latitude"];
    }
    if (longitude) {
        [parameters setObject:longitude forKey:@"schoolIntroduce.longitude"];
    }
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolInfo_modifySchoolIntroduceNew?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)updateSchoolImageWithSid:(NSInteger)sid
                                              simg:(NSString *)simg
                                           simgBig:(NSString *)simgBig
                                             block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(sid) forKey:@"sid"];
    [parameters setObject:simg forKey:@"simg"];
    [parameters setObject:simgBig forKey:@"simgBig"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolInfo_setSchoolMainImgNew.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
