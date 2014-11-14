//
//  ZXUtils.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUtils.h"

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
    
    if (account.classList.count > 0) {
        self.currentClass = [account.classList firstObject];
    } else {
        self.currentClass = nil;
    }
    
    [self getIdentity];
}

- (void)getIdentity
{
    ZXAccount *account = self.account;
    if (account.logonStatus == 1) {
        _identity = ZXIdentityNone;
    } else if (account.logonStatus == 2) {
        _identity = ZXIdentityUnchoosesd;
    } else if (account.logonStatus == 3) {
        if (account.appStateInfolist.count > 0) {
            ZXAppStateInfo *appstateinfo = [account.appStateInfolist firstObject];
            _identity = appstateinfo.appState.integerValue;
        } else {
            _identity = ZXIdentityNone;
        }
    } else {
        _identity = ZXIdentityNone;
    }
}
@end
