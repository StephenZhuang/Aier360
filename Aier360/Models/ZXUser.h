//
//  ZXUser.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"

@interface ZXUser : BaseModel
@property (nonatomic , copy) NSString *account;
@property (nonatomic , copy) NSString *address;
@property (nonatomic , copy) NSString *appUid;
@property (nonatomic , assign) long baby_classId;
@property (nonatomic , copy) NSString *baby_className;
@property (nonatomic , copy) NSString *birthday;
@property (nonatomic , assign) NSInteger cfans;
@property (nonatomic , assign) NSInteger cfollow;
@property (nonatomic , assign) NSInteger cfresh;
@property (nonatomic , assign) NSInteger city_id;
@property (nonatomic , strong) NSArray *commonFollow;
@property (nonatomic , copy) NSString *constellation;
@property (nonatomic , copy) NSString *coverimg;
@property (nonatomic , copy) NSString *desinfo;
@property (nonatomic , copy) NSString *edate;
@property (nonatomic , copy) NSString *email;
@property (nonatomic , copy) NSString *headimg;
@property (nonatomic , strong) NSArray *idenPL;
@property (nonatomic , assign) NSInteger idenProxy;
@property (nonatomic , copy) NSString *interest;
@property (nonatomic , assign) NSInteger isbaby;
@property (nonatomic , copy) NSString *nickname;
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , copy) NSString *phone_imei;
@property (nonatomic , copy) NSString *pwd;
@property (nonatomic , copy) NSString *realname;
@property (nonatomic , copy) NSString *relation;
@property (nonatomic , copy) NSString *remark;
@property (nonatomic , copy) NSString *sex;
@property (nonatomic , assign) NSInteger state;
@property (nonatomic , assign) long uid;
@end
