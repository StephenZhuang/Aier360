//
//  BaseModel.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import <JSONModel.h>
#import "JSONValueTransformer+ZXBoolFromNumber.h"

@interface BaseModel : JSONModel
/**
 *  接口返回类型，1：成功，2：失败
 */
@property (nonatomic , assign) BOOL s;
@end
