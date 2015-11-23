//
//  ZXPayTypeTableViewCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/23.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMCheckBox/BEMCheckBox.h>

@interface ZXPayTypeTableViewCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UIImageView *iconIamge;
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet BEMCheckBox *checkBox;
@end
