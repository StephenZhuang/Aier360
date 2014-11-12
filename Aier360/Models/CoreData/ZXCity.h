//
//  ZXCity.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+ZXRecord.h"

@interface ZXCity : NSManagedObject

@property (nonatomic) int32_t cid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t subCid;
@property (nonatomic) int16_t ctype;
@property (nonatomic) int16_t cstate;
@property (nonatomic, retain) NSString * pinJ;
@property (nonatomic, retain) NSString * pinA;
@property (nonatomic, retain) NSString * pinAS;

@end
