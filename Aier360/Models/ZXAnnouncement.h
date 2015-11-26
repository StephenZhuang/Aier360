//
//  ZXAnnouncement.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXAnnouncement : ZXBaseModel
/**
 *  班级id
 */
@property (nonatomic , assign) long cid;

/**
 *  公告发送的人数
 */
@property (nonatomic , assign) NSInteger count;

/**
 *  发布时间
 */
@property (nonatomic , copy) NSString *ctime;

@property (nonatomic , copy) NSString *ctime_str;

/**
 *  发布公告教师头像
 */
@property (nonatomic , copy) NSString *headimg_teacher;

/**
 *  公告图片
 */
@property (nonatomic , copy) NSString *img;

/**
 *  是否发送短信（0否1是）
 */
@property (nonatomic , assign) NSInteger ismessage;

/**
 *  是否阅读
 */
@property (nonatomic , assign) BOOL isRead;

/**
 *  通告内容
 */
@property (nonatomic , copy) NSString *message;

/**
 *  公告id
 */
@property (nonatomic , assign) long mid;

/**
 *  发布公告教师姓名
 */
@property (nonatomic , copy) NSString *name_teacher;

/**
 *  阅读人数
 */
@property (nonatomic , assign) NSInteger reading;

/**
 *  学校id
 */
@property (nonatomic , assign) NSInteger sid;

/**
 *  发布教师id
 */
@property (nonatomic , assign) long tid;

/**
 *  收件人为部分老师时候的老师id（多个一逗号隔开
 */
@property (nonatomic , copy) NSString *tids;

/**
 *  公告标题
 */
@property (nonatomic , copy) NSString *title;

/**
 *  部分收件老师名称
 */
@property (nonatomic , copy) NSString *tnames;

/**
 *  通告类型 0:校园通告(全体师生),1:班级通告,2:校园通告(全体教师)3:部分老师
 */
@property (nonatomic , assign) NSInteger type;

@property (nonatomic , assign) long uid;

/**
 *  总数
 */
@property (nonatomic , assign) NSInteger shouldReaderNumber;

/**
 *  未读家长列表
 */
@property (nonatomic , strong) NSMutableArray *unReadedParents;

/**
 *  未读老师列表
 */
@property (nonatomic , strong) NSMutableArray *unReadedTeachers;
@end
