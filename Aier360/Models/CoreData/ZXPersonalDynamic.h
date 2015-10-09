//
//  ZXPersonalDynamic.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/22.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXBaseDynamic.h"

@class ZXManagedUser, ZXSquareLabel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXPersonalDynamic : ZXBaseDynamic

// Insert code here to declare functionality of your managed object subclass
- (void)updateWithDic:(NSDictionary *)dic save:(BOOL)save;
@end

NS_ASSUME_NONNULL_END

#import "ZXPersonalDynamic+CoreDataProperties.h"
