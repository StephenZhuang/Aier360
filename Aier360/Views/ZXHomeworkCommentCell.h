//
//  ZXHomeworkCommentCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/20.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamicCommentCell.h"
#import "ZXHomeworkComment.h"

@interface ZXHomeworkCommentCell : ZXDynamicCommentCell<UICollectionViewDelegate , UICollectionViewDataSource>
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSArray *imageArray;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *collectionHeight;
@property (nonatomic , copy) void (^imageClickBlock)(NSInteger index);

+ (CGFloat)heightByEmojiText:(NSString *)emojiText imageArray:(NSArray *)imageArray;
- (void)configureUIWithHomeworkComment:(ZXHomeworkComment *)comment;
- (void)configureUIWithHomeworkCommentReply:(ZXHomeworkCommentReply *)commentReply;
@end
