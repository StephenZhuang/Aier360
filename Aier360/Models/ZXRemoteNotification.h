//
//  ZXRemoteNotification.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/26.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@class ZXAps;

typedef NS_ENUM(NSUInteger, ZXNotificationType) {
    ZXNotificationTypeOther = 0,
    ZXNotificationTypeHomework = 1,
    ZXNotificationTypeSchoolAnnouncement = 2,
    ZXNotificationTypeClassAnnouncement = 3,
    ZXNotificationTypeFood = 4,
    ZXNotificationTypeSchoolDynamic = 5,
    ZXNotificationTypeClassDynamic = 6,
    ZXNotificationTypeICCard = 7,
    ZXNotificationTypePersonalDynamic = 8
};

typedef NS_ENUM(NSUInteger, ZXDynamicOperateType) {
    ZXDynamicOperateTypeComment = 1,
    ZXDynamicOperateTypeReply = 2,
    ZXDynamicOperateTypePraise = 3,
    ZXDynamicOperateTypeRepost = 4,
    ZXDynamicOperateTypeRelease = 5
};

@interface ZXRemoteNotification : ZXBaseModel
@property (nonatomic , assign) ZXNotificationType JPushMessageType;
@property (nonatomic , assign) long _j_msgid;
@property (nonatomic , assign) ZXDynamicOperateType dynamicOperateType;
@property (nonatomic , assign) NSInteger sid;
@property (nonatomic , assign) long did;
@property (nonatomic , strong) ZXAps *aps;
@end

@interface ZXAps : ZXBaseModel
@property (nonatomic , copy) NSString *alert;
@property (nonatomic , assign) NSInteger badge;
@property (nonatomic , copy) NSString *sound;
@end
