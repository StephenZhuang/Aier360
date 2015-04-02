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
 *  @param block  user,babyList,isFriend
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getUserInfoAndBabyListWithUid:(NSInteger)uid
                                                 in_uid:(NSInteger)in_uid
                                                  block:(void (^)(ZXUser *user, NSArray *array, BOOL isFriend, NSError *error))block;

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
 *  根据爱儿号或者手机号
 *
 *  @param aierOrPhoneOrNickname 搜索字符
 *  @param page                  页码
 *  @param page_size             每页条数
 *  @param block                 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)searchPeopleWithAierOrPhoneOrNickname:(NSString *)aierOrPhoneOrNickname
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

/**
 *  添加好友申请
 *
 *  @param toUid   被添加人id
 *  @param fromUid 发起人id
 *  @param content 验证信息
 *  @param block   回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)requestFriendWithToUid:(NSInteger)toUid
                                         fromUid:(NSInteger)fromUid
                                         content:(NSString *)content
                                           block:(ZXCompletionBlock)block;

/**
 *  解除好友关系
 *
 *  @param uid   用户id
 *  @param fuid  好友id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteFriendWithUid:(NSInteger)uid
                                         fuid:(NSInteger)fuid
                                        block:(ZXCompletionBlock)block;
@end
