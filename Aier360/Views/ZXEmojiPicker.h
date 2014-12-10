//
//  ZXEmojiPicker.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXEmojiPicker : UIView<UICollectionViewDelegate , UICollectionViewDataSource>
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , copy) void (^emojiBlock)(NSString *text);
@property (nonatomic , assign) BOOL showing;
- (void)show;
- (void)hide;
@end
