//
//  ZXSchoolMenuHeader.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/7.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXSchoolMenuHeader : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic , weak) IBOutlet UIImageView *schoolImageView;
@property (nonatomic , weak) IBOutlet UIButton *imgNumButton;
@property (nonatomic , weak) IBOutlet UILabel *schoolNameLabel;
@property (nonatomic , weak) IBOutlet UIButton *addClassDynamicButton;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) BOOL hasReward;

@property (nonatomic , copy) void (^schollImageBlock)();

@property (nonatomic , copy) void (^SelectedIndexBlock)(NSInteger index);

@property (nonatomic , weak) IBOutlet NSLayoutConstraint *collectionViewHeight;

- (void)configureUIWithSchool:(ZXSchool *)school;
- (void)setData:(NSMutableArray *)dataArray;
@end
