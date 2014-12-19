//
//  ZXHomeworkCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolDynamicCell.h"
#import "ZXHomework.h"

@interface ZXHomeworkCell : ZXSchoolDynamicCell
- (void)configureUIWithHomework:(ZXHomework *)homework indexPath:(NSIndexPath *)indexPath;
@end
