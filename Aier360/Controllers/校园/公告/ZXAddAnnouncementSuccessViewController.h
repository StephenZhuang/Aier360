//
//  ZXAddAnnouncementSuccessViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/10.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import <BEMCheckBox/BEMCheckBox.h>
#import "ZXAnnounceMessage.h"

@interface ZXAddAnnouncementSuccessViewController : ZXBaseViewController
@property (nonatomic , strong) ZXAnnounceMessage *announceMessage;
@property (nonatomic , weak) IBOutlet BEMCheckBox *checkBox;
@property (nonatomic , weak) IBOutlet UILabel *tipLabel;
@end
