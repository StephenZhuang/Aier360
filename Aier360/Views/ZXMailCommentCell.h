//
//  ZXMailCommentCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXSchoolMasterEmailDetail.h"

@interface ZXMailCommentCell : ZXBaseCell<MLEmojiLabelDelegate>
@property (nonatomic , strong) MLEmojiLabel *emojiLabel;
@property (nonatomic , weak) IBOutlet UIView *emojiView;

+ (CGFloat)heightByText:(NSString *)emojiText;
- (void)configureUIWithSchoolMasterEmail:(ZXSchoolMasterEmailDetail *)email;
@end
