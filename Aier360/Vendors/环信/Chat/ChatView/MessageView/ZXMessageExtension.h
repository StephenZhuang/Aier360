//
//  ZXMessageExtension.h
//  Aierbon
//
//  Created by Stephen Zhuang on 14/12/31.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXMessageExtension : ZXBaseModel
@property (nonatomic , copy) NSString *fromAccount;
@property (nonatomic , copy) NSString *from;
@property (nonatomic , copy) NSString *fheadimg;
@property (nonatomic , copy) NSString *to;
@property (nonatomic , copy) NSString *theadimg;
@end
