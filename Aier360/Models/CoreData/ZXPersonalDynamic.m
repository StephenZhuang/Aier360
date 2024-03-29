//
//  ZXPersonalDynamic.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/22.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPersonalDynamic.h"
#import "ZXManagedUser.h"
#import "ZXSquareLabel.h"
#import "NSManagedObject+ZXRecord.h"
#import "NSNull+ZXNullValue.h"
#import "NSString+ZXNumber.h"

@implementation ZXPersonalDynamic

// Insert code here to add functionality to your managed object subclass
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
    
    if (![[dic objectForKey:@"squareLabels"] isNull]) {
        NSMutableArray *squareLabelArray = [[NSMutableArray alloc] init];
        for (NSDictionary *squareLabelDic in [dic objectForKey:@"squareLabels"]) {
            if (save) {
                ZXSquareLabel *squareLabel = [ZXSquareLabel insertWithAttribute:@"id" value:@([[squareLabelDic objectForKey:@"id"] integerValue])];
                [squareLabel update:squareLabelDic];
                [squareLabel save];
//                [self addSquareLabelsObject:squareLabel];
                [squareLabelArray addObject:squareLabel];
            } else {
                ZXSquareLabel *squareLabel = [ZXSquareLabel create];
                [squareLabel update:squareLabelDic];
//                [self addSquareLabelsObject:squareLabel];
                [squareLabelArray addObject:squareLabel];
            }
        }
        NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:squareLabelArray];
        self.squareLabels = set;
    }
    
    self.bcount = [[dic objectForKey:@"bcount"] integerValue];
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
    self.address = [[dic objectForKey:@"address"] stringValue];
    self.latitude = [[dic objectForKey:@"latitude"] stringValue];
    self.longitude = [[dic objectForKey:@"longitude"] stringValue];
    if (save) {
        self.isTemp = NO;
    } else {
        self.isTemp = YES;
    }
}
@end
