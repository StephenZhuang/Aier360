//
//  ZXSchoolMasterEmail.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXSchoolMasterEmailDetail.h"

@interface ZXSchoolMasterEmail : ZXBaseModel
/**
 *  校长信箱主键
 */
@property (nonatomic , assign) NSInteger smeid;
/**
 *  发起留言用户
 */
@property (nonatomic , assign) long suid;
/**
 *  时间
 */
@property (nonatomic , copy) NSString *cdate;
/**
 *  发起人的昵称
 */
@property (nonatomic , copy) NSString *nickname;
/**
 *  发起人的头像
 */
@property (nonatomic , copy) NSString *headimg;
/**
 *  内容
 */
@property (nonatomic , copy) NSString *content;
/**
 *  学校ID
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  未读
 */
@property (nonatomic , assign) NSInteger stats;
/**
 *  所有对话信息列表
 */
@property (nonatomic , strong) NSArray *smeList;
@end
