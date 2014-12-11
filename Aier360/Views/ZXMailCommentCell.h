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
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;

+ (CGFloat)heightByText:(NSString *)emojiText;
- (void)configureUIWithSchoolMasterEmail:(ZXSchoolMasterEmailDetail *)email;
@end
