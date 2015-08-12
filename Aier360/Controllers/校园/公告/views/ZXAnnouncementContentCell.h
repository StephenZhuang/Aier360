//
//  ZXAnnouncementContentCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface ZXAnnouncementContentCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic , weak) IBOutlet UIPlaceHolderTextView *textView;
@property (nonatomic , weak) IBOutlet UILabel *letterLabel;
@property (nonatomic , copy) void (^textBlock)(NSString *text);
@end
