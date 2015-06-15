//
//  ZXInfoCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"

@interface ZXInfoCell : ZXBaseCell
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet UILabel *tipLabel;
- (void)configureUIWithUser:(ZXUser *)user title:(NSString *)title indexPath:(NSIndexPath *)indexPath;
@end
