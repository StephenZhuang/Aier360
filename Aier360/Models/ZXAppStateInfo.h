//
//  ZXAppStateInfo.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/6.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"

@interface ZXAppStateInfo : BaseModel
/**
 *  权限
 */
@property (nonatomic , copy) NSString *appState;
@property (nonatomic , assign) NSInteger sid;
@property (nonatomic , copy) NSString *sname;
@property (nonatomic , assign) long tid;
@property (nonatomic , assign) long uid;
@property (nonatomic , assign) long cid;
@property (nonatomic , copy) NSString *cname;
@property (nonatomic , copy) NSString *gname;
@property (nonatomic , copy) NSString *listStr;
@end
