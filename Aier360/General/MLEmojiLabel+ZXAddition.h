//
//  MLEmojiLabel+ZXAddition.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "MLEmojiLabel.h"

@interface MLEmojiLabel (ZXAddition)
/**
 *  获取label高度
 *
 *  @param emojiText 文本
 *  @param width     宽度
 *
 *  @return 高度
 */
+ (CGFloat)heightForEmojiText:(NSString*)emojiText preferredWidth:(CGFloat)width fontSize:(CGFloat)fontSize;
@end
