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
    if (account.appStatus.integerValue == 0) {
        if (self.currentSchool) {
            ZXSchool *school = self.currentSchool;
            if (school.appStatusSchool.integerValue == 1) {
                _identity = ZXIdentitySchoolMaster;
            } else {
                if (school.classList.count > 0) {
                    ZXClass *schoolClass = [school.classList firstObject];
                    _identity = schoolClass.appStatusClass.integerValue;
                } else {
                    _identity = ZXIdentityStaff;
                }
            }
            
        } else {
            _identity = ZXIdentityNone;
        }
    } else {
        _identity = ZXIdentityNone;
    }
}
@end
