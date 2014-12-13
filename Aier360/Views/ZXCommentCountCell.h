//
//  ZXCommentCountCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"

@interface ZXCommentCountCell : ZXBaseCell
@property (nonatomic , weak) IBOutlet UILabel *praiseCountLabel;
@property (nonatomic , weak) IBOutlet UILabel *commentCountLabel;
@property (nonatomic , weak) IBOutlet UIButton *praiseDetailButton;
@end
