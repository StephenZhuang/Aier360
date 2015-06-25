//
//  ZXRepostView.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRepostView.h"
#import "ZXManagedUser.h"
#import "ZXTimeHelper.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import "MagicalMacro.h"
#import "ZXBaseCollectionViewCell.h"

@implementation ZXRepostView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.emojiLabel.delegate = self;
    self.emojiLabel.backgroundColor = [UIColor clearColor];
    self.emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.emojiLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.emojiLabel.isNeedAtAndPoundSign = YES;
    self.emojiLabel.disableEmoji = NO;
    self.emojiLabel.disableThreeCommon = YES;
    
    self.emojiLabel.lineSpacing = 3.0f;
    
    self.emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    self.emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.emojiLabel.customEmojiPlistName = @"expressionImage";
    
    CGFloat itemWidth = (SCREEN_WIDTH - 119) / 3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    [self.collectionView setCollectionViewLayout:layout animated:YES];
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}

- (void)configureWithDynamic:(ZXPersonalDynamic *)dynamic
{
    if (dynamic) {
        [self.emojiLabel setText:dynamic.content];
    } else {
        [self.emojiLabel setText:@"(ToT)主人已经把我给删除了..."];
    }
    self.emojiLabelHeight.constant = [MLEmojiLabel heightForEmojiText:self.emojiLabel.text preferredWidth:SCREEN_WIDTH-109 fontSize:17];
    
    if (dynamic.img.length > 0) {
        self.collectionView.fd_collapsed = NO;
        NSArray *arr = [dynamic.img componentsSeparatedByString:@","];
        self.imageArray = arr;
    } else {
        self.collectionView.fd_collapsed = YES;
    }
    
    if (dynamic.type == 2) {
        [self.nameLabel setText:dynamic.tname];
    } else {
        [self.nameLabel setText:dynamic.user.nickname];
    }
    self.repostViewHeight.constant = self.collectionViewHeight.constant + self.emojiLabelHeight.constant + 53;
}

#pragma mark - collentionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArray) {
        return self.imageArray.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *imageUrl = self.imageArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForType:ZXImageTypeFresh imageName:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_imageClickBlock) {
        _imageClickBlock(indexPath.row);
    }
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    [self.collectionView reloadData];
    
    CGFloat itemWidth = (SCREEN_WIDTH - 119) / 3;
    int line = 0;
    line = (int)ceilf(imageArray.count / 3.0);
    CGFloat height = line * itemWidth + (line - 1) * 5;
    self.collectionViewHeight.constant = height;
}
@end
