//
//  ZXMessageBill.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXMessageBill : ZXBaseModel
/**
 *  订单id
 */
@property (nonatomic , assign) long bid;
/**
 *  订单号
 */
@property (nonatomic , copy) NSString *bilno;
/**
 *  商品id
 */
@property (nonatomic , assign) long cid;
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  购买数量
 */
@property (nonatomic , assign) NSInteger num;
/**
 *  商品总金额
 */
@property (nonatomic , assign) double money;
/**
 *  支付类型（1支付宝2微信）
 */
@property (nonatomic , assign) NSInteger type;
/**
 *  订单状态（0：正在支付1：支付成功-1：支付失败）
 */
@property (nonatomic , assign) NSInteger state;
/**
 *  订单描述
 */
@property (nonatomic , copy) NSString *descript;
/**
 *  订单生成时间
 */
@property (nonatomic , copy) NSString *cdate;

/**
 *  生成订单
 *
 *  @param uid   用户id
 *  @param sid   学校id
 *  @param num   数量
 *  @param cid   商品id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)submitOrderWithUid:(long)uid
                                         sid:(NSInteger)sid
                                         num:(NSInteger)num
                                         cid:(long)cid
                                       block:(void (^)(ZXMessageBill *bill, NSError *error))block;
@end
