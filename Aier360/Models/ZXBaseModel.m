//
//  BaseModel.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "ZXBaseModel.h"

@implementation ZXBaseModel
+ (void)handleCompletion:(ZXCompletionBlock)block baseModel:(ZXBaseModel *)baseModel
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
