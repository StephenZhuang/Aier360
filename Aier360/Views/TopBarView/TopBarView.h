//
//  TopBarView.h
//  Property
//
//  Created by admin on 13-11-28.
//  Copyright (c) 2013年 lijun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopBarView;
@protocol TopBarViewDataSource<NSObject>

@required
- (NSInteger)numOfItems;
- (NSInteger)defaultSelectedItem;
- (NSString *)topBarView:(TopBarView *)topBarView nameForItem:(NSInteger)item;
@end

@protocol TopBarViewDelegate <NSObject>

- (void)selectItemAtIndex:(NSInteger)index;

@end

@interface TopBarView : UIView<UIScrollViewDelegate>
{
    UIImageView *selectedImage;
    NSMutableArray *buttonArray;
    UIScrollView *mScrollView;
}
@property (nonatomic , assign) IBOutlet id<TopBarViewDataSource> dataSource;
@property (nonatomic , assign) IBOutlet id<TopBarViewDelegate> delegate;
@property (nonatomic , assign) int selectedIndex;
- (void)reloadData;
@end
