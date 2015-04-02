//
//  ZXFriend.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/1.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ZXPinyinHelper.h"
#import "NSManagedObject+ZXRecord.h"


@interface ZXFriend : NSManagedObject
/**
 *  主键
 */
@property (nonatomic) int32_t fid;
/**
 *  用户id
 */
@property (nonatomic) int32_t uid;
/**
 *  好友id
 */
@property (nonatomic) int32_t fuid;
/**
 *  状态：0正常，1非正常
 */
@property (nonatomic) int16_t state;
/**
 *  备注名
 */
@property (nonatomic, retain) NSString * remark;
/**
 *  添加时间
 */
@property (nonatomic, retain) NSString * cdate;
/**
 *  昵称
 */
@property (nonatomic, retain) NSString * nickname;
/**
 *  头像
 */
@property (nonatomic, retain) NSString * headimg;
/**
 *  类型 0修改，1新增，-2删除
 */
@property (nonatomic) int16_t type;
/**
 *  宝宝姓名，逗号隔开
 */
@property (nonatomic, retain) NSString * babyNicknames;
/**
 *  宝宝生日，逗号隔开
 */
@property (nonatomic, retain) NSString * babyBirthdays;
/**
 *  分组名
 */
@property (nonatomic, retain) NSString * fgName;

/**
 *  拼音
 */
@property (nonatomic, retain) NSString * pinyin;
/**
 *  首字母
 */
@property (nonatomic, retain) NSString * firstLetter;
/**
 *  账号
 */
@property (nonatomic , retain) NSString * account;
/**
 *  爱儿号
 */
@property (nonatomic , retain) NSString * aier;

- (NSString *)displayName;
@end
