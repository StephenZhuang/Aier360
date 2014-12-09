//
//  ZXAnnounceRead.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXTeacher.h"
#import "ZXParent.h"

@interface ZXAnnounceRead : ZXBaseModel
@property (nonatomic , strong) NSArray *readedParentList;
@property (nonatomic , strong) NSArray *readedTeacherList;
@property (nonatomic , copy) NSString *unreadingList;
@property (nonatomic , copy) NSString *unReadTeacherList;
@end
