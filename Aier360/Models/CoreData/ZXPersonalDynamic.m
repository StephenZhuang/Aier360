//
//  ZXPersonalDynamic.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/27.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPersonalDynamic.h"
#import "ZXBaseDynamic.h"
#import "ZXManagedUser.h"
#import "NSManagedObject+ZXRecord.h"
#import "NSNull+ZXNullValue.h"

@implementation ZXPersonalDynamic

@dynamic authority;
@dynamic babyBirthdays;
@dynamic dynamic;
@dynamic user;
@dynamic tname;
@dynamic sid;
@dynamic cid;

- (void)updateWithDic:(NSDictionary *)dic
{
    ZXManagedUser *user = [ZXManagedUser create];
    [user update:[dic objectForKey:@"user"]];
    self.user = user;
    
    self.original = [[dic objectForKey:@"original"] integerValue];
    if (self.original == 1) {
        ZXBaseDynamic *dynamic = [ZXBaseDynamic create];
        [dynamic update:[dic objectForKey:@"dynamic"]];
        self.dynamic = dynamic;
    }
    
    self.ccount = [[dic objectForKey:@"ccount"] integerValue];
    self.cdate = [[dic objectForKey:@"cdate"] stringValue];
    self.content = [dic objectForKey:@"content"];
    self.did = [[dic objectForKey:@"did"] longValue];
    self.img = [[dic objectForKey:@"img"] stringValue];
    self.pcount = [[dic objectForKey:@"pcount"] integerValue];
    self.relativeid = [[dic objectForKey:@"relativeid"] longValue];
    self.tcount = [[dic objectForKey:@"tcount"] integerValue];
    self.type = [[dic objectForKey:@"type"] integerValue];
    self.uid = [[dic objectForKey:@"uid"] longValue];
    self.authority = [[dic objectForKey:@"authority"] integerValue];
    self.babyBirthdays = [[dic objectForKey:@"babyBirthdays"] stringValue];
    NSString *tname = [[dic objectForKey:@"tname"] stringValue];
    self.tname = tname;
    self.sid = [[dic objectForKey:@"sid"] integerValue];
    self.cid = [[dic objectForKey:@"cid"] longValue];
    
}
@end
