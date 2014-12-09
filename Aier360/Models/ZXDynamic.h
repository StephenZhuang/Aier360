//
//  ZXDynamic.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXDynamicComment.h"

@interface ZXDynamic : ZXBaseModel
/**
 *  主键
 */
@property (nonatomic , assign) long did;
/**
 *  发布动态的用户id
 */
@property (nonatomic , assign) long uid;
/**
 *  学校id(学校动态)
 */
@property (nonatomic , assign) NSInteger sid;
/**
 *  班级id(班级动态)
 */
@property (nonatomic , assign) long cid;
/**
 *  动态内容
 */
@property (nonatomic , copy) NSString *content;
/**
 *  动态的图片
 */
@property (nonatomic , copy) NSString *img;
/**
 *  类型(1校园动态2班级动态3个人动态)
 */
@property (nonatomic , assign) NSInteger type;
/**
 *  是否是原创 0原创1转发
 */
@property (nonatomic , assign) NSInteger original;
/**
 *  原创动态的id
 */
@property (nonatomic , assign) long relativeid;
/**
 *  赞的次数
 */
@property (nonatomic , assign) NSInteger pcount;
/**
 *  转发的次数
 */
@property (nonatomic , assign) NSInteger tcount;
/**
 *  评论的次数
 */
@property (nonatomic , assign) NSInteger ccount;
/**
 *  发布时间
 */
@property (nonatomic , copy) NSString *cdate;
/**
 *  昵称
 */
@property (nonatomic , copy) NSString *nickname;
/**
 *  头像
 */
@property (nonatomic , copy) NSString *headimg;
/**
 *  原创动态
 */
@property (nonatomic , strong) ZXDynamic *dynamic;
/**
 *  登录用户是否赞过
 */
@property (nonatomic , assign) NSInteger pflag;
/**
 *  评论列表
 */
@property (nonatomic , strong) NSArray *dcList;
@end
