//
//  ZXPopPicker.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/20.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXPopPicker : UIView<UITableViewDelegate , UITableViewDataSource>
{
    @private
    BOOL canHide;
}
@property (nonatomic , strong) UIView *maskView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , copy) NSString *pickTitle;
@property (nonatomic , copy) void (^ZXPopPickerBlock)(NSInteger selectedIndex);

- (instancetype)initWithTitle:(NSString *)title contents:(NSArray *)contents;
@end
