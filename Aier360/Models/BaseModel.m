//
//  BaseModel.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
+ (void)handleCompletion:(ZXCompletionBlock)block baseModel:(BaseModel *)baseModel
{
    if (block) {
        if (baseModel) {
            if(baseModel.s) {
                block(YES, nil);
            } else {
                block(NO, baseModel.error_info);
            }
        } else {
            block(NO , @"");
        }
    }
}

+ (void)handleCompletion:(ZXCompletionBlock)block error:(NSError *)error
{
    if (block) {
        block(NO, error.localizedDescription);
    }
}
@end
