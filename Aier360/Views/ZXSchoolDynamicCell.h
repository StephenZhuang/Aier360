//
//  ZXSchoolDynamicCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXDynamic.h"

@interface ZXSchoolDynamicCell : ZXBaseCell<MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;
@property (nonatomic , weak) IBOutlet UIButton *deleteButton;
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;

+ (CGFloat)heightByText:(NSString *)emojiText;
- (void)configureUIWithDynamic:(ZXDynamic *)dynamic indexPath:(NSIndexPath *)indexPath;
@end
