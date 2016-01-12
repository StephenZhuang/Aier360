//
//  ZXSchoolIntroduce.h
//  Aierbon
//
//  Created by Stephen Zhuang on 16/1/12.
//  Copyright © 2016年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXSchoolIntroduce : ZXBaseModel
@property (nonatomic , assign) NSInteger sid;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *img;
@property (nonatomic , copy) NSString *desinfo;
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , copy) NSString *address;
@property (nonatomic , copy) NSString *nature;
@property (nonatomic , copy) NSString *longitude;
@property (nonatomic , copy) NSString *latitude;
@property (nonatomic , strong) NSMutableArray *honor;

/**
 *  获取学校资料
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)schoolInfoWithSid:(NSInteger)sid
                                      block:(ZXCompletionBlock)block;
@end
