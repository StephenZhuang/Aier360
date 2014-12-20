//
//  ZXHomeworkCommentCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/20.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomeworkCommentCell.h"
#import "MagicalMacro.h"
#import "ZXBaseCollectionViewCell.h"
#import "ZXTimeHelper.h"

@implementation ZXHomeworkCommentCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat itemWidth = (SCREEN_WIDTH - 106) / 4;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    [_collectionView setCollectionViewLayout:layout animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_imageArray) {
        return _imageArray.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *imageUrl = _imageArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHomework:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
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
    [_collectionView reloadData];
}

+ (CGFloat)heightByImageArray:(NSArray *)imageArray
{
    CGFloat itemWidth = (SCREEN_WIDTH - 106) / 4;
    int line = 0;
    line = (int)ceilf(imageArray.count / 4.0);
    return line * itemWidth + (line - 1) * 8;
}


+ (CGFloat)heightByEmojiText:(NSString *)emojiText imageArray:(NSArray *)imageArray
{
    return MAX(65, [MLEmojiLabel heightForEmojiText:emojiText preferredWidth:(SCREEN_WIDTH - 82) fontSize:17] + 56 + [self heightByImageArray:imageArray]);
}

- (void)configureUIWithHomeworkComment:(ZXHomeworkComment *)comment
{
    [self.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:comment.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.titleLabel setText:[NSString stringWithFormat:@"%@:",comment.cname]];
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:comment.cdate]];
    self.emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.emojiLabel.customEmojiPlistName = @"expressionImage";
    [self.emojiLabel setText:comment.content];
    
    if (comment.img.length > 0) {
        NSArray *arr = [comment.img componentsSeparatedByString:@","];
        [self setImageArray:arr];
        self.collectionHeight.constant = [ZXHomeworkCommentCell heightByImageArray:arr];
    } else {
        self.collectionHeight.constant = 0;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)configureUIWithHomeworkCommentReply:(ZXHomeworkCommentReply *)commentReply
{
    [self.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:commentReply.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:commentReply.cdate]];
    self.emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.emojiLabel.customEmojiPlistName = @"expressionImage";
    [self.emojiLabel setText:commentReply.content];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",commentReply.cname] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:74 green:74 blue:74],   NSFontAttributeName : [UIFont systemFontOfSize:17]}];
//    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@" 回复 " attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:131 green:131 blue:132],   NSFontAttributeName : [UIFont systemFontOfSize:17]}];
//    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",dynamicCommentReply.rname] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:74 green:74 blue:74],   NSFontAttributeName : [UIFont systemFontOfSize:17]}];
//    [string appendAttributedString:string2];
//    [string appendAttributedString:string3];
    [self.titleLabel setAttributedText:string];
    self.collectionHeight.constant = 0;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
@end
