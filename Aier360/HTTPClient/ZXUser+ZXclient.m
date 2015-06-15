//
//  ZXUser+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUser+ZXclient.h"
#import "ZXBaby.h"
#import "NSNull+ZXNullValue.h"

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

//+ (NSURLSessionDataTask *)getUserInfoAndBabyListWithUid:(NSInteger)uid
//                                                 in_uid:(NSInteger)in_uid
//                                                  block:(void (^)(ZXUser *user, NSArray *array, BOOL isFriend, NSError *error))block
//{
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
//    [parameters setObject:[NSNumber numberWithInteger:in_uid] forKey:@"in_uid"];
//    return [[ZXApiClient sharedClient] POST:@"userjs/uccomm_userInfoapp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
//        
//        NSArray *array = [JSON objectForKey:@"babyList"];
//        NSArray *arr = [ZXUser objectArrayWithKeyValuesArray:array];
//        ZXUser *user = [ZXUser objectWithKeyValues:[JSON objectForKey:@"user"]];
//        BOOL isFriend = ([[JSON objectForKey:@"isFriend"] integerValue] == 1);
//        if (block) {
//            block(user ,arr,isFriend, nil);
//        }
//    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//        if (block) {
//            block(nil,nil,NO, error);
//        }
//    }];
//}

+ (NSURLSessionDataTask *)getUserInfoAndBabyListWithUid:(long)uid
                                                   fuid:(long)fuid
                                                  block:(void (^)(ZXUser *user, NSArray *array, BOOL isFriend ,ZXDynamic *dynamic,NSInteger dynamicCount, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithLong:fuid] forKey:@"fuid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userInfo_showUserHome.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"baby"];
        NSArray *arr = [ZXBaby objectArrayWithKeyValuesArray:array];
        ZXUser *user = [ZXUser objectWithKeyValues:[JSON objectForKey:@"userInformationDetail"]];
        BOOL isFriend = ([[JSON objectForKey:@"isFriend"] isNull]?NO: [[JSON objectForKey:@"isFriend"] integerValue] == 1);
        ZXDynamic *dynamic = [ZXDynamic objectWithKeyValues:[JSON objectForKey:@"dynamic"]];
        NSInteger dynamicCount = [[JSON objectForKey:@"dynamicCount"] isNull] ?0: [[JSON objectForKey:@"dynamicCount"] integerValue];
        if (block) {
            block(user ,arr,isFriend,dynamic,dynamicCount, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil,nil,NO,nil,0, error);
        }
    }];
}

//+ (NSURLSessionDataTask *)updateUserInfoAndBabyListWithAppuserinfo:(NSString *)appuserinfo
//                                                         babysinfo:(NSString *)babysinfo
//                                                               uid:(NSInteger)uid
//                                                             block:(ZXCompletionBlock)block
//{
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
//    [parameters setObject:appuserinfo forKey:@"appuserinfo"];
//    [parameters setObject:babysinfo forKey:@"babysinfo"];
//    return [[ZXApiClient sharedClient] POST:@"userjs/useraccountsettings_updateUserInfoApp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
//        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
//        [ZXBaseModel handleCompletion:block baseModel:baseModel];
//    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//        [ZXBaseModel handleCompletion:block error:error];
//    }];
//}

+ (NSURLSessionDataTask *)updateUserInfoWithUser:(ZXUser *)user
                                           block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:user.uid] forKey:@"userInformation.uid"];
    [parameters setObject:[NSNumber numberWithInteger:user.city_id] forKey:@"userInformation.city_id"];
    [parameters setObject:[NSNumber numberWithInteger:user.ht_id] forKey:@"userInformation.ht_id"];
    NSString *(^NotNullString)(NSString *astring) = ^(NSString *bstring) {
        if (bstring) {
            return bstring;
        } else {
            return @"";
        }
    };
    [parameters setObject:NotNullString(user.nickname) forKey:@"userInformation.nickname"];
    [parameters setObject:NotNullString(user.desinfo) forKey:@"userInformation.desinfo"];
    [parameters setObject:NotNullString(user.sex) forKey:@"userInformation.sex"];
    [parameters setObject:NotNullString(user.birthday) forKey:@"userInformation.birthday"];
    [parameters setObject:NotNullString(user.industry) forKey:@"userInformation.industry"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userInfo_modifyUserInformation.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
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
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"friend.uid"];
    [parameters setObject:[NSNumber numberWithInteger:auid] forKey:@"friend.fuid"];
    [parameters setObject:remark forKey:@"friend.remark"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/friend_addOrUpdateFriendRemark.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
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
        
        NSArray *array = [JSON objectForKey:@"users"];
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

+ (NSURLSessionDataTask *)addAddressFriendWithUid:(long)uid
                                           phones:(NSString *)phones
                                            block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:phones forKey:@"phones"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/friend_searchAddressListFriends.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"users"];
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

+ (NSURLSessionDataTask *)getPrasedUserWithDid:(long)did
                                   limitNumber:(NSInteger)limitNumber
                                         block:(void (^)(NSArray *array,NSInteger total, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:did] forKey:@"did"];
    [parameters setObject:@(limitNumber) forKey:@"limitNumber"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userDynamic_searchDynamicPraise.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"userList"];
        NSArray *arr = [ZXBaseUser objectArrayWithKeyValuesArray:array];
        NSInteger total = [[JSON objectForKey:@"praiseTotalNumber"] integerValue];
        if (block) {
            block(arr,total, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil,0, error);
        }
    }];
}
@end
