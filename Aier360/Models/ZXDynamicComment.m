//
//  ZXDynamicComment.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamicComment.h"

@implementation ZXDynamicComment
- (NSDictionary *)objectClassInArray
{
    return @{@"dcrList" : [ZXDynamicCommentReply class]};
}
@end
