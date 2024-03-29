//
//  ZXPopMenu.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXPopMenu : UIView<UITableViewDelegate , UITableViewDataSource>
{
@private
    BOOL canHide;
}
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIView *maskView;
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , assign) BOOL showing;
@property (nonatomic , copy) void (^ZXPopPickerBlock)(NSInteger selectedIndex);

- (instancetype)initWithContents:(NSArray *)contents targetFrame:(CGRect)frame;
- (void)hide;
@end
