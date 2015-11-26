//
//  ZXMessageCommodity.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXMessageCommodity : ZXBaseModel
/**
 *  商品id
 */
@property (nonatomic , assign) long cid;
/**
 *  商品名称
 */
@property (nonatomic , copy) NSString *cname;
/**
 *  商品单价
 */
@property (nonatomic , assign) double price;
/**
 *  商品描述
 */
@property (nonatomic , copy) NSString *descript;

/**
 *  获取短信商品信息
 *
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getMessageCommodityWithBlock:(void (^)(ZXMessageCommodity *messageCommodity, NSError *error))block;
@end
