//
//  ZXParentRepostVIew.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/15.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXPersonalDynamic.h"

@interface ZXParentRepostVIew : UIView<MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UIImageView *imageView;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *repostViewHeight;

- (void)configureWithDynamic:(ZXPersonalDynamic *)dynamic;
@end
