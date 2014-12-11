//
//  ZXDynamicToolCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"
#import "ZXDynamic.h"

@interface ZXDynamicToolCell : ZXBaseCell
@property (nonatomic , weak) IBOutlet UIButton *praiseButton;
@property (nonatomic , weak) IBOutlet UIButton *repostButton;
@property (nonatomic , weak) IBOutlet UIButton *commentButton;
- (void)configureUIWithDynamic:(ZXDynamic *)dynamic indexPath:(NSIndexPath *)indexPath;
@end
