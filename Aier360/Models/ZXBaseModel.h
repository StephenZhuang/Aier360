//
//  BaseModel.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "MJExtension.h"

typedef void(^ZXCompletionBlock)(BOOL success ,NSString *errorInfo);

@interface ZXBaseModel : NSObject
/**
 *  接口返回类型，1：成功，2：失败
 */
@property (nonatomic , assign) NSInteger s;
/**
 *  错误信息
 */
@property (nonatomic , copy) NSString *error_info;

+ (void)handleCompletion:(ZXCompletionBlock)block baseModel:(ZXBaseModel *)baseModel;
+ (void)handleCompletion:(ZXCompletionBlock)block error:(NSError *)error;
@end
