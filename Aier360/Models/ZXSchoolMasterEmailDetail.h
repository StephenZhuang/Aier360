//
//  ZXSchoolMasterEmailDetail.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXSchoolMasterEmailDetail : ZXBaseModel
/**
 *  id
 */
@property (nonatomic , assign) NSInteger smedid;
/**
 *  发信人id
 */
@property (nonatomic , assign) NSInteger suid;
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  内容
 */
@property (nonatomic , copy) NSString *content;
/**
 *  时间
 */
@property (nonatomic , copy) NSString *cdate;
/**
 *  校长信箱id
 */
@property (nonatomic , assign) NSInteger smeid;
@end
