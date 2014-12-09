//
//  ZXAnnouncement.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXAnnouncement : ZXBaseModel
/**
 *  公告id
 */
@property (nonatomic , assign) long mid;
/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  班级id
 */
@property (nonatomic , assign) long cid;
/**
 *  发布通告的学校教师id
 */
@property (nonatomic , assign) long tid;
/**
 *  公告内容
 */
@property (nonatomic , copy) NSString *message;
/**
 *  发布时间
 */
@property (nonatomic , copy) NSString *ctime;
/**
 *  通告类型 0:校园通告(全体师生),1:班级通告,2:校园通告(全体教师)
 */
@property (nonatomic , assign) NSInteger type;
/**
 *  公告图片
 */
@property (nonatomic , copy) NSString *img;
/**
 *  公告标题
 */
@property (nonatomic , copy) NSString *title;
/**
 *  公告发送的人数
 */
@property (nonatomic , assign) NSInteger count;
/**
 *  阅读人数
 */
@property (nonatomic , assign) NSInteger reading;
@property (nonatomic , copy) NSString *ctime_str;
/**
 *  发布公告教师姓名
 */
@property (nonatomic , copy) NSString *name_teacher;
/**
 *  发布公告教师头像
 */
@property (nonatomic , copy) NSString *headimg_teacher;
/**
 *  短信发送成功的用户名
 */
@property (nonatomic , copy) NSString *successStr;
/**
 *  短信发送失败的用户名
 */
@property (nonatomic , copy) NSString *failStr;
/**
 *  是否已阅读
 */
@property (nonatomic , assign) BOOL isRead;
@end
