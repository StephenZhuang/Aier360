//
//  ZXSchoolIntroduce.m
//  Aierbon
//
//  Created by Stephen Zhuang on 16/1/12.
//  Copyright © 2016年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolIntroduce.h"
#import "ZXHonor.h"
#import "ZXApiClient.h"

@implementation ZXSchoolIntroduce
- (NSDictionary *)objectClassInArray
{
    return @{@"honor" : [ZXHonor class]};
}

+ (NSURLSessionDataTask *)schoolInfoWithSid:(NSInteger)sid
                                      block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolInfo_searchSchoolInfoNew.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXSchoolIntroduce *schoolIntroduce = [ZXSchoolIntroduce objectWithKeyValues:[JSON objectForKey:@"schoolIntroduce"]];
        ZXSchool *school = [ZXUtils sharedInstance].currentSchool;
        school.name = schoolIntroduce.name;
        school.simgBig = schoolIntroduce.img;
        school.desinfo = schoolIntroduce.desinfo;
        school.phone = schoolIntroduce.phone;
        school.address = schoolIntroduce.address;
        school.nature = schoolIntroduce.nature;
        school.latitude = schoolIntroduce.latitude;
        school.longitude = schoolIntroduce.longitude;
        school.honor = schoolIntroduce.honor;
        
        if (block) {
            block(YES,nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}
@end
