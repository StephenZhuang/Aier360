//
//  ZXUser.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"
#import "JSONValueTransformer+ZXBoolFromNumber.h"


@interface ZXUser : BaseModel
@property (nonatomic , copy) NSString *account;
@property (nonatomic , copy) NSString *address;
@property (nonatomic , copy) NSString *appUid;
@property (nonatomic , copy) NSString *babyClassId;
@property (nonatomic , copy) NSString *babyClassName;
@property (nonatomic , copy) NSString *birthday;
@property (nonatomic , copy) NSString *cfans;
@property (nonatomic , copy) NSString *cfollow;
@property (nonatomic , copy) NSString *cfresh;
@property (nonatomic , assign) NSInteger cityId;
@property (nonatomic , copy) NSString *commonFollow;
@property (nonatomic , copy) NSString *constellation;
@property (nonatomic , copy) NSString *coverimg;
@property (nonatomic , copy) NSString *desinfo;
@property (nonatomic , copy) NSString *edate;
@property (nonatomic , copy) NSString *email;
@property (nonatomic , copy) NSString *headimg;
@property (nonatomic , copy) NSString *idenPL;
@property (nonatomic , copy) NSString *idenProxy;
@property (nonatomic , copy) NSString *interest;
@property (nonatomic , assign) BOOL isbaby;
@property (nonatomic , copy) NSString *nickname;
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , copy) NSString *phoneImei;
@property (nonatomic , copy) NSString *pwd;
@property (nonatomic , copy) NSString *realname;
@property (nonatomic , copy) NSString *relation;
@property (nonatomic , copy) NSString *remark;
@property (nonatomic , copy) NSString *sex;
@property (nonatomic , copy) NSString *state;
@property (nonatomic , assign) NSInteger uid;
@end
