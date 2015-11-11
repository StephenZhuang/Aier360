//
//  ZXAnnounceMessage.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/11.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXAnnounceMessage : NSObject
@property (nonatomic , assign) NSInteger sid;
@property (nonatomic , assign) long mid;
@property (nonatomic , copy) NSString *content;
@property (nonatomic , assign) NSInteger needSendPeopleNum;
@property (nonatomic , assign) NSInteger messageNum;

+ (NSInteger)getMessageNumWithTextlength:(NSInteger)length;
@end
