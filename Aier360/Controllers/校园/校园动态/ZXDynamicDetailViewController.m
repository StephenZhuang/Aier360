//
//  ZXDynamicDetailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamicDetailViewController.h"
#import "ZXSChoolDynamicCell.h"
#import "ZXOriginDynamicCell.h"
#import "ZXImageCell.h"
#import "ZXCommentCountCell.h"
#import "ZXDynamicCommentCell.h"

@interface ZXDynamicDetailViewController ()

@end

@implementation ZXDynamicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
}

- (void)loadData
{
    [ZXDynamic getDynamicCommentListWithDid:_dynamic.did page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        if (array) {
            for (ZXDynamicComment *comment in array) {
                [self.dataArray addObject:comment];
                if (comment.dcrList) {
                    [self.dataArray addObjectsFromArray:comment.dcrList];
                }
            }
            
            if (array.count < pageCount) {
                hasMore = NO;
                [self.tableView setFooterHidden:YES];
            }
        } else {
            hasMore = NO;
            [self.tableView setFooterHidden:YES];
        }
        [self.tableView reloadData];
        if (page == 1) {
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
    }];
}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_dynamic.original) {
            return 2;
        } else {
            if (_dynamic.img.length > 0) {
                return 2;
            } else {
                return 1;
            }
        }
    } else if (section == 1) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            return [ZXSchoolDynamicCell heightByText:_dynamic.content];
        } else {
            if (_dynamic.original) {
                //转发
                return [ZXOriginDynamicCell heightByDynamic:_dynamic.dynamic];
            } else {
                //图片
                NSArray *arr = [_dynamic.img componentsSeparatedByString:@","];
                return [ZXImageCell heightByImageArray:arr];
            }
        }
    } else if (indexPath.section == 1){
        return 65;
    } else {
        NSObject *object = [self.dataArray objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[ZXDynamicComment class]]) {
            ZXDynamicComment *comment = (ZXDynamicComment *)object;
            return [ZXDynamicCommentCell heightByEmojiText:comment.content];
        } else {
            ZXDynamicCommentReply *commentReply = (ZXDynamicCommentReply *)object;
            return [ZXDynamicCommentCell heightByEmojiText:commentReply.content];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            ZXSchoolDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXSchoolDynamicCell"];
            [cell configureUIWithDynamic:_dynamic indexPath:indexPath];
            return cell;
        } else {
            if (_dynamic.original) {
                //转发
                ZXOriginDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXOriginDynamicCell"];
                [cell configureUIWithDynamic:_dynamic.dynamic];
                return cell;
            } else {
                //图片
                ZXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImageCell"];
                NSArray *arr = [_dynamic.img componentsSeparatedByString:@","];
                [cell setImageArray:arr];
                return cell;
            }
        }
    } else if (indexPath.section == 1){
        ZXCommentCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCommentCountCell"];
        return cell;
    } else {
        ZXDynamicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXDynamicCommentCell"];
        if ([[self.dataArray objectAtIndex:indexPath.row] isKindOfClass:[ZXDynamicComment class]]) {
            [cell configureUIWithDynamicComment:[self.dataArray objectAtIndex:indexPath.row]];
        } else {
            [cell configureUIWithDynamicCommentReply:[self.dataArray objectAtIndex:indexPath.row]];
        }
        return cell;
    }
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)commentAction:(id)sender
{
    [self.view endEditing:YES];
    NSString *content = [[_commentTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0) {
        return;
    }
    
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXDynamic commentDynamicWithUid:GLOBAL_UID sid:appStateInfo.sid did:_dynamic.did content:content type:_dynamic.type filePath:nil block:^(BOOL success, NSString *errorInfo) {
        if (success) {
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
