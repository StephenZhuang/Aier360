//
//  ZXHomeworkToolCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamicToolCell.h"
#import "ZXHomework.h"

@interface ZXHomeworkToolCell : ZXDynamicToolCell
- (void)configureUIWithHomework:(ZXHomework *)homework indexPath:(NSIndexPath *)indexPath;
@end
