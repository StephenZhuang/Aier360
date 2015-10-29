//
//  ZXSchoolDynamicCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolDynamicCell.h"
#import "ZXManagedUser.h"
#import "ZXTimeHelper.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import "MagicalMacro.h"
#import "ZXBaseCollectionViewCell.h"
#import "ZXSquareLabel+CoreDataProperties.h"
#import "ZXApiClient.h"

@implementation ZXSchoolDynamicCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.emojiLabel.delegate = self;
    self.emojiLabel.backgroundColor = [UIColor clearColor];
    self.emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.emojiLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.emojiLabel.isNeedAtAndPoundSign = NO;
    self.emojiLabel.disableEmoji = NO;
    self.emojiLabel.disableThreeCommon = YES;
    
    self.emojiLabel.lineSpacing = 3.0f;
    
    self.emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    self.emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.emojiLabel.customEmojiPlistName = @"expressionImage";
    
    CGFloat itemWidth = (SCREEN_WIDTH - 85) / 3;
    
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
            NSInteger oslid = [[[link componentsSeparatedByString:@"="] lastObject] integerValue];
            !_squareLabelBlock?:_squareLabelBlock(oslid);
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
    ZXManagedUser *user = dynamic.user;
    [self.headImageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"head_default"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)];
    [self.headImageView addGestureRecognizer:tap];
    self.headImageView.userInteractionEnabled = YES;
    
    [self.nameLabel setText:dynamic.tname];
    NSString *tip = @"";
    if (dynamic.type == 1) {
        tip = @"校园动态";
    } else {
        tip = [NSString stringWithFormat:@"%@动态",dynamic.cname];
    }
    [self.tipLabel setText:tip];
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ZXSquareLabel *squareLabel in dynamic.squareLabels) {
        [array addObject:[NSString stringWithFormat:@"#%@#",squareLabel.name]];
    }
    NSString *string = [array componentsJoinedByString:@""];
    NSString *content = [string stringByAppendingString:dynamic.content];
    [self.emojiLabel setText:content];
    self.emojiLabelHeight.constant = [MLEmojiLabel heightForEmojiText:content preferredWidth:SCREEN_WIDTH-75 fontSize:17];
    for (ZXSquareLabel *squareLabel in dynamic.squareLabels) {
        [self.emojiLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oslid?oslid=%@",[ZXApiClient sharedClient].baseURL.absoluteString,@(squareLabel.id)]] withRange:[content rangeOfString:[NSString stringWithFormat:@"#%@#",squareLabel.name]]];
    }
    
    if (dynamic.img.length > 0) {
        self.collectionView.fd_collapsed = NO;
        NSArray *arr = [dynamic.img componentsSeparatedByString:@","];
        self.imageArray = arr;
    } else {
        self.collectionView.fd_collapsed = YES;
    }
    
    if (dynamic.address.length > 0) {
        [self.addressButton setTitle:dynamic.address forState:UIControlStateNormal];
        self.addressButton.fd_collapsed = NO;
    } else {
        self.addressButton.fd_collapsed = YES;
    }
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:dynamic.cdate]];
    self.favButton.selected = dynamic.hasParise == 1;
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
    [cell.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForType:ZXImageTypeSmall imageName:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
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
    
    CGFloat itemWidth = (SCREEN_WIDTH - 85) / 3;
    int line = 0;
    line = (int)ceilf(imageArray.count / 3.0);
    CGFloat height = line * itemWidth + (line - 1) * 5;
    self.collecionViewHeight.constant = height;
}

- (void)headClick
{
    !_headClickBlock?:_headClickBlock();
}
@end
