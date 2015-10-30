//
//  ZXHotDynamicCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/25.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPersonalDynamic.h"
#import "MLEmojiLabel+ZXAddition.h"

@interface ZXHotDynamicCell : UICollectionViewCell
{
    CAGradientLayer *gradient;
}
@property (nonatomic , weak) IBOutlet UIButton *headButton;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *addressLabel;
@property (nonatomic , weak) IBOutlet UIImageView *imageView;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *contentLabel;
@property (nonatomic , weak) IBOutlet UIButton *favButton;
@property (nonatomic , weak) IBOutlet UIImageView *mask;
- (void)configureCellWithDynamic:(ZXPersonalDynamic *)dynamic;
@end
