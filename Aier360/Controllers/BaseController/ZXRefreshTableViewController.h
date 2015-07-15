//
//  ZXRefreshTableViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/7.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "MJRefresh.h"
#import "ZXBlankView.h"

@interface ZXRefreshTableViewController : ZXBaseViewController<UITableViewDelegate ,UITableViewDataSource>
{
@protected
    BOOL hasMore;
    NSInteger pageCount;
    NSInteger page;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , strong) UIImage *blankImage;
@property (nonatomic , copy) NSString *blankString;
@property (nonatomic , strong) ZXBlankView *blankView;
- (void)addHeader;
- (void)addFooter;
- (void)loadData;
- (void)configureArray:(NSArray *)array;
- (void)configureArrayWithNoFooter:(NSArray *)array;
- (void)setExtrueLineHidden;
- (void)configureBlankView;

//重写tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
