//
//  ZXHomeworkComment.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomeworkComment.h"

@implementation ZXHomeworkComment
- (NSDictionary *)objectClassInArray
{
    return @{@"hcrList" : [ZXHomeworkCommentReply class]};
}
@end
