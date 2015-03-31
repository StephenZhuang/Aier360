//
//  ZXUser+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUser.h"
#import "ZXUpDownLoadManager.h"

@interface ZXUser (ZXclient)
/**
 *  获取赞过的人列表
 *
 *  @param did   动态id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getPraisedListWithDid:(NSInteger)did
                                          block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取个人信息
 *
 *  @param uid    用户id
 *  @param in_uid 目标用户id
 *  @param block  user,babyList,isGz
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getUserInfoAndBabyListWithUid:(NSInteger)uid
                                                 in_uid:(NSInteger)in_uid
                                                  block:(void (^)(ZXUser *user, NSArray *array, BOOL isFocus, NSError *error))block;

/**
 *  修改个人信息
 *
 *  @param appuserinfo 用户信息
 *  @param babysinfo   宝宝信息
 *  @param uid         用户id
 *  @param block       回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)updateUserInfoAndBabyListWithAppuserinfo:(NSString *)appuserinfo
                                                         babysinfo:(NSString *)babysinfo
                                                               uid:(NSInteger)uid
                                                             block:(ZXCompletionBlock)block;

/**
 *  投诉
 *
 *  @param uid    用户id
 *  @param in_uid 投诉用户id
 *  @param block  回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)complaintWithUid:(NSInteger)uid
                                    in_uid:(NSInteger)in_uid
                                     block:(ZXCompletionBlock)block;

/**
 *  加关注
 *
 *  @param uid   用户id
 *  @param fuid  关注人id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)focusWithUid:(NSInteger)uid
                                  fuid:(NSInteger)fuid
                                 block:(ZXCompletionBlock)block;

/**
 *  取消关注（可批量）
 *
 *  @param uid     用户id
 *  @param fuidStr 取消关注用户id， 逗号隔开
 *  @param block   回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)cancelFocusWithUid:(NSInteger)uid
                                     fuidStr:(NSString *)fuidStr
                                       block:(ZXCompletionBlock)block;

/**
 *  修改备注名
 *
 *  @param uid    用户id
 *  @param auid   被加密友的用户id
 *  @param remark 备注名
 *  @param block  回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)changeRemarkWithUid:(NSInteger)uid
                                         auid:(NSInteger)auid
                                       remark:(NSString *)remark
                                        block:(ZXCompletionBlock)block;

/**
 *  根据账号昵称模糊查询
 *
 *  @param uid       用户id
 *  @param nickname  查找昵称
 *  @param page      页码
 *  @param page_size 每页条数
 *  @param block     回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)searchPeopleWithUid:(NSInteger)uid
                                     nickname:(NSString *)nickname
                                         page:(NSInteger)page
                                    page_size:(NSInteger)page_size
                                        block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  生成二维码
 *
 *  @param uid           用户id
 *  @param qrCodeContent 二维码内容
 *  @param block         回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)createQrcodeWithUid:(NSInteger)uid
                                qrCodeContent:(NSString *)qrCodeContent
                                        block:(void (^)(NSString *qrcode, NSError *error))block;
@end
