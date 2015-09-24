//
//  ZXSquareLabel+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSquareLabel+ZXclient.h"
#import "NSManagedObject+ZXRecord.h"

@implementation ZXSquareLabel (ZXclient)
+ (NSURLSessionDataTask *)getSquareLabelListWithBlock:(void (^)(NSArray *array, NSError *error))block
{
    NSString *url = @"userjs/squareLabel_searchSquareLabels.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
        NSArray *arr = [JSON objectForKey:@"squareLabels"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in arr) {
            ZXSquareLabel *squareLabel = [ZXSquareLabel create];
            [squareLabel update:dic];
            [array addObject:squareLabel];
        }
        !block?:block(array,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}
@end
