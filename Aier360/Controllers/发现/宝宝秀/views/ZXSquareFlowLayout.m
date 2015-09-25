//
//  ZXSquareFlowLayout.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/25.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSquareFlowLayout.h"
#import "MagicalMacro.h"

@implementation ZXSquareFlowLayout
- (id)init
{
    if (!(self = [super init])) return nil;
    
    self.sectionInset = UIEdgeInsetsMake(7, 5, 7, 5);
    self.minimumLineSpacing = 7;
    self.minimumInteritemSpacing = 5;
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(7, 5, 7, 5);
        self.minimumLineSpacing = 7;
        self.minimumInteritemSpacing = 5;
    }
    return self;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray * modifiedLayoutAttributesArray = [NSMutableArray array];
    CGFloat itemWidth = (SCREEN_WIDTH - 15) / 2.0;
    CGFloat itemHeight = 86.5;
    
    [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * layoutAttributes, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            
        } else if (idx == 1) {
            layoutAttributes.frame = CGRectMake(10+itemWidth, 7, itemWidth, itemHeight);
        } else if (idx == 2) {
            layoutAttributes.frame = CGRectMake(10+itemWidth, 14+itemHeight, itemWidth, itemHeight);
        } else {
            layoutAttributes.frame = CGRectMake(5+((idx-3)%2)*(itemWidth+5), 194+((idx-3)/2)*(itemHeight+7), itemWidth, itemHeight);
        }
        
        [modifiedLayoutAttributesArray addObject:layoutAttributes];
    }];
    return modifiedLayoutAttributesArray;
}
@end
