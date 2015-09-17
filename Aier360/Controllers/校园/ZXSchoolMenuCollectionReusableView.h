//
//  ZXSchoolMenuCollectionReusableView.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/17.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXSchoolMenuCollectionReusableView : UICollectionReusableView
@property (nonatomic , weak) IBOutlet UIImageView *schoolImageView;
@property (nonatomic , weak) IBOutlet UIButton *imgNumButton;
@property (nonatomic , weak) IBOutlet UILabel *schoolNameLabel;

@property (nonatomic , copy) void (^schollImageBlock)();

- (void)configureUIWithSchool:(ZXSchool *)school;
@end
