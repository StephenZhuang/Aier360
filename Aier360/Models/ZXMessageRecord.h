//
//	ZXMessageRecord.h
//
//	Create by Zhuang Stephen on 13/11/2015
//	Copyright © 2015 Zhixing Internet of Things Technology Co., Ltd.. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "ZXBaseModel.h"
#import "ZXApiClient.h"

@interface ZXMessageRecord : ZXBaseModel
/**
 *  主键
 */
@property (nonatomic, assign) NSInteger bid;
/**
 *  订单号
 */
@property (nonatomic, strong) NSString * billno;
@property (nonatomic, strong) NSString * cdate;
/**
 *  时间字符串
 */
@property (nonatomic, strong) NSString * cdateStr;
/**
 *  商品id
 */
@property (nonatomic, assign) NSInteger cid;
/**
 *  订单描述
 */
@property (nonatomic, strong) NSString * descript;
/**
 *  短信剩余量
 */
@property (nonatomic, assign) NSInteger mescount;
/**
 *  总金额
 */
@property (nonatomic, assign) float money;
/**
 *  月份
 */
@property (nonatomic, strong) NSString * monthStr;
/**
 *  姓名
 */
@property (nonatomic, strong) NSString * nickname;
/**
 *  商品数量
 */
@property (nonatomic, assign) NSInteger num;
/**
 *  支付方式
 */
@property (nonatomic, strong) NSString * pay;
/**
 *  支付状态
 */
@property (nonatomic, strong) NSString * payState;
/**
 *  价格
 */
@property (nonatomic, strong) NSString * price;
/**
 *  学校id
 */
@property (nonatomic, assign) NSInteger sid;
/**
 *  订单状态（0:正在支付,1:支付成功,-1:支付失败）
 */
@property (nonatomic, assign) NSInteger state;
/**
 *  付款类型（1支付宝2微信支付,3任务）
 */
@property (nonatomic, assign) NSInteger type;
/**
 *  购买人id
 */
@property (nonatomic, assign) NSInteger uid;
/**
 *  使用短信
 */
@property (nonatomic, assign) NSInteger usecount;

/**
 *  获取短信记录列表
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getMessageRecordWithSid:(long)sid
                                            block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取记录详情
 *
 *  @param block 回调
 *
 *  @return task
 */
- (NSURLSessionDataTask *)getMessageDetailWithBlock:(void (^)(ZXMessageRecord *messageRecord, NSError *error))block;
@end

@interface ZXMonthMessageRecord : ZXBaseModel
@property (nonatomic , assign) NSInteger mescount;
@property (nonatomic , strong) NSMutableArray *mrList;
@property (nonatomic , copy) NSString *month;
@property (nonatomic , assign) NSInteger usecount;
@end