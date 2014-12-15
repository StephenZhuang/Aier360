//
//  ZXOriginDynamicCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXOriginDynamicCell.h"
#import "ZXBaseCollectionViewCell.h"
#import "MagicalMacro.h"

@implementation ZXOriginDynamicCell

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
    
    CGFloat itemWidth = (SCREEN_WIDTH - 70) / 4;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    [_collectionView setCollectionViewLayout:layout animated:YES];
    
    _emojiLabel.numberOfLines = 0;
    _emojiLabel.font = [UIFont systemFontOfSize:17.0f];
    _emojiLabel.delegate = self;
    _emojiLabel.backgroundColor = [UIColor clearColor];
    _emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _emojiLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _emojiLabel.isNeedAtAndPoundSign = YES;
    _emojiLabel.disableEmoji = NO;
    _emojiLabel.disableThreeCommon = YES;
    
    _emojiLabel.lineSpacing = 3.0f;
    
    _emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _emojiLabel.customEmojiPlistName = @"expressionImage";
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
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXBaseCollectionViewCell" forIndexPath:indexPath];
    NSString *imageUrl = _imageArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForFresh:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
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
    CGFloat height = [ZXOriginDynamicCell heightByImageArray:imageArray];
    _collectionViewHeight.constant = height;
}

+ (CGFloat)heightByImageArray:(NSArray *)imageArray
{
    CGFloat itemWidth = (SCREEN_WIDTH - 70) / 4;
    int line = 0;
    line = (int)ceilf(imageArray.count / 4.0);
    return line * itemWidth + (line - 1) * 8;
}

#pragma mark - layout

+ (CGFloat)heightByDynamic:(ZXDynamic *)dynamic
{
    if (dynamic.img.length > 0) {
        NSArray *arr = [dynamic.img componentsSeparatedByString:@","];
        
        return [MLEmojiLabel heightForEmojiText:dynamic.content preferredWidth:(SCREEN_WIDTH - 46) fontSize:17] + 62 + [self heightByImageArray:arr];
    } else {
        return [MLEmojiLabel heightForEmojiText:dynamic.content preferredWidth:(SCREEN_WIDTH - 46) fontSize:17] + 62;
    }
}

#pragma mark - delegate
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

- (void)configureUIWithDynamic:(ZXDynamic *)dynamic
{
    [self.titleLabel setText:dynamic.nickname];
    _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _emojiLabel.customEmojiPlistName = @"expressionImage";
    [self.emojiLabel setText:dynamic.content];
    NSArray *arr = [dynamic.img componentsSeparatedByString:@","];
    self.imageArray = arr;
}
@end
