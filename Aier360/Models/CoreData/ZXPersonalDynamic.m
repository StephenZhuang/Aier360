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
@dynamic cname;
@dynamic repostDynamics;
@dynamic ctype;
@dynamic isTemp;

- (void)updateWithDic:(NSDictionary *)dic save:(BOOL)save
{
    self.original = [[dic objectForKey:@"original"] integerValue];
    
    if (![[dic objectForKey:@"user"] isNull]) {
        if (save) {
            ZXManagedUser *user = [ZXManagedUser insertWithAttribute:@"uid" value:@([[[dic objectForKey:@"user"] objectForKey:@"uid"] longValue])];
            [user update:[dic objectForKey:@"user"]];
            [user save];
            self.user = user;
        } else {
            ZXManagedUser *user = [ZXManagedUser create];
            [user update:[dic objectForKey:@"user"]];
            self.user = user;
        }
    }
    
    if (![[dic objectForKey:@"dynamic"] isNull]) {
        if (self.original == 1) {
            if (save) {
                ZXPersonalDynamic *dynamic = [ZXPersonalDynamic insertWithAttribute:@"did" value:@([[[dic objectForKey:@"dynamic"] objectForKey:@"did"] longValue])];
                [dynamic updateWithDic:[dic objectForKey:@"dynamic"] save:save];
                [dynamic save];
                self.dynamic = dynamic;
            } else {
                ZXPersonalDynamic *dynamic = [ZXPersonalDynamic create];
                [dynamic updateWithDic:[dic objectForKey:@"dynamic"] save:save];
                self.dynamic = dynamic;
            }
        }
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
    self.cname = [[dic objectForKey:@"cname"] stringValue];
    self.sid = [[dic objectForKey:@"sid"] integerValue];
    self.cid = [[dic objectForKey:@"cid"] longValue];
    self.ctype = [[dic objectForKey:@"ctype"] integerValue];
    self.hasCollection = [[dic objectForKey:@"hasCollection"] integerValue];
    self.hasParise = [[dic objectForKey:@"hasParise"] integerValue];
    if (save) {
        self.isTemp = NO;
    } else {
        self.isTemp = YES;
    }
}
@end
