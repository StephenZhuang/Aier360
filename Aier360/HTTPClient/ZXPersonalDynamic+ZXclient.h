//
//  ZXPersonalDynamic+ZXclient.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/27.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPersonalDynamic.h"
#import "ZXApiClient.h"

@interface ZXPersonalDynamic (ZXclient)
/**
 *  发布/转发个人动态
 *
 *  @param uid        用户id
 *  @param content    动态内容
 *  @param img        图片名称，多个以逗号隔开（可为空）
 *  @param relativeid 原创动态的id（可不填，即是原创动态）
 *  @param authority  个人动态权限（1：所有人可见 2：仅好友 3：仅自己可见）
 *  @param block      回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addDynamicWithUid:(long)uid
                                    content:(NSString *)content
                                        img:(NSString *)img
                                 relativeid:(long)relativeid
                                  authority:(NSInteger)authority
                                      block:(ZXCompletionBlock)block;
@end
