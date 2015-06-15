//
//  ZXUtils.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUtils.h"
#import "NSString+ZXMD5.h"

@implementation ZXUtils
+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)setAccount:(ZXAccount *)account
{
    _account = account;
    if (account.schoolList.count > 0) {
        self.currentSchool = [account.schoolList firstObject];
    } else {
        self.currentSchool = nil;
    }
}

- (BOOL)hasIdentity:(ZXIdentity)identity inClass:(long)cid
{
    BOOL hasIdentity = NO;
    for (ZXAppStateInfo *appStateInfo in self.account.appStateInfolist) {
        if (appStateInfo.appState.integerValue == identity) {
            if (cid == 0) {
                hasIdentity = YES;
                break;
            } else {
                if (appStateInfo.cid == cid) {
                    hasIdentity = YES;
                    break;
                }
            }
        }
    }
    return hasIdentity;
}

- (BOOL)hasIdentity:(ZXIdentity)identity
{
    return [self hasIdentity:identity inClass:0];
}

- (long)getTid
{
    long tid = 0;
    for (ZXAppStateInfo *appStateInfo in self.account.appStateInfolist) {
        if (appStateInfo.appState.integerValue != ZXIdentityParent) {
            tid = appStateInfo.tid;
            break;
        }
    }
    return tid;
}

- (ZXAppStateInfo *)getAppStateInfoWithIdentity:(ZXIdentity)identity cid:(long)cid
{
    for (ZXAppStateInfo *appStateInfo in self.account.appStateInfolist) {
        if (appStateInfo.appState.integerValue == identity) {
            if (cid == 0) {
                return appStateInfo;
            } else {
                if (appStateInfo.cid == cid) {
                    return appStateInfo;
                }
            }
        }
    }
    return nil;
}

- (ZXAppStateInfo *)getHigherAppStateInfo
{
    ZXAppStateInfo *higherState;
    ZXIdentity identity = ZXIdentityUnchoosesd;
    for (ZXAppStateInfo *appStateInfo in self.account.appStateInfolist) {
        if (appStateInfo.appState.integerValue < identity) {
            identity = appStateInfo.appState.integerValue;
            higherState = appStateInfo;
        }
    }
    return higherState;
}

- (ZXIdentity)getHigherIdentity
{
    ZXAppStateInfo *appStateInfo = [self getHigherAppStateInfo];
    return appStateInfo.appState.integerValue;
}

- (NSString *)appStates
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ZXAppStateInfo *appStateInfo in self.account.appStateInfolist) {
        [array addObject:appStateInfo.appState];
    }
    NSString *appStates =  [array componentsJoinedByString:@","];
    return appStates;
}

- (ZXMessageExtension *)messageExtension
{
    if (!_messageExtension) {
        _messageExtension = [[ZXMessageExtension alloc] init];
    }
    _messageExtension.fromAccount = [_user.account md5];
    _messageExtension.from = _user.nickname;
    _messageExtension.fheadimg = _user.headimg;
    return _messageExtension;
}

- (NSDictionary *)controllerNameDictionary
{
    if (!_controllerNameDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ControllerName" ofType:@"plist"];
        _controllerNameDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _controllerNameDictionary;
}
@end
