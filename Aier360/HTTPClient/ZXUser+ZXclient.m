//
//  ZXUser+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUser+ZXclient.h"

@implementation ZXUser (ZXclient)
+ (NSURLSessionDataTask *)getPraisedListWithDid:(NSInteger)did
                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_searchDynamicPraise.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"userList"];
        NSArray *arr = [ZXUser objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getUserInfoAndBabyListWithUid:(NSInteger)uid
                                                 in_uid:(NSInteger)in_uid
                                                  block:(void (^)(ZXUser *user, NSArray *array, BOOL isFriend, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:in_uid] forKey:@"in_uid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/uccomm_userInfoapp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"babyList"];
        NSArray *arr = [ZXUser objectArrayWithKeyValuesArray:array];
        ZXUser *user = [ZXUser objectWithKeyValues:[JSON objectForKey:@"user"]];
        BOOL isFriend = ([[JSON objectForKey:@"isFriend"] integerValue] == 1);
        if (block) {
            block(user ,arr,isFriend, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil,nil,NO, error);
        }
    }];
}

+ (NSURLSessionDataTask *)updateUserInfoAndBabyListWithAppuserinfo:(NSString *)appuserinfo
                                                         babysinfo:(NSString *)babysinfo
                                                               uid:(NSInteger)uid
                                                             block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:appuserinfo forKey:@"appuserinfo"];
    [parameters setObject:babysinfo forKey:@"babysinfo"];
    return [[ZXApiClient sharedClient] POST:@"userjs/useraccountsettings_updateUserInfoApp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}


+ (NSURLSessionDataTask *)complaintWithUid:(NSInteger)uid
                                    in_uid:(NSInteger)in_uid
                                     block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:in_uid] forKey:@"in_uid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/uccomm_Complaints.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)changeRemarkWithUid:(NSInteger)uid
                                         auid:(NSInteger)auid
                                       remark:(NSString *)remark
                                        block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:auid] forKey:@"fuid"];
    [parameters setObject:remark forKey:@"remark"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userchumscircle_updateRemarkApp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}


+ (NSURLSessionDataTask *)searchPeopleWithAierOrPhoneOrNickname:(NSString *)aierOrPhoneOrNickname
                                                           page:(NSInteger)page
                                                      page_size:(NSInteger)page_size
                                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:aierOrPhoneOrNickname forKey:@"aierOrPhoneOrNickname"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"pageUtil.page"];
    [parameters setObject:[NSNumber numberWithInteger:page_size] forKey:@"pageUtil.page_size"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/friend_searchUsersByCondition.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"usres"];
        NSArray *arr = [ZXUser objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)createQrcodeWithUid:(NSInteger)uid
                                qrCodeContent:(NSString *)qrCodeContent
                                        block:(void (^)(NSString *qrcode, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:qrCodeContent forKey:@"qrCodeContent"];
    return [[ZXApiClient sharedClient] POST:@"userjs/useraccountnew_generateQrCode.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSString *qrcode = [JSON objectForKey:@"qrCode"];
        
        if (block) {
            block(qrcode, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)requestFriendWithToUid:(NSInteger)toUid
                                         fromUid:(NSInteger)fromUid
                                         content:(NSString *)content
                                           block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:toUid] forKey:@"requestFriend.toUid"];
    [parameters setObject:[NSNumber numberWithInteger:fromUid] forKey:@"requestFriend.fromUid"];
    [parameters setObject:content forKeyedSubscript:@"requestFriend.content"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/friend_addRequestFriend.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)deleteFriendWithUid:(NSInteger)uid
                                         fuid:(NSInteger)fuid
                                        block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:fuid] forKey:@"friend.fuid"];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"friend.uid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/friend_deleteFriend.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
