//
//  ZXSelectSquareLabelViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/23.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSelectSquareLabelViewController.h"
#import "ZXSquareLabel+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXTeacherPickCell.h"

@interface ZXSelectSquareLabelViewController ()

@end

@implementation ZXSelectSquareLabelViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dynamic" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSelectSquareLabelViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择标签";
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"加载中..." toView:self.view];
    [ZXSquareLabel getSquareLabelListWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [hud hide:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                NSArray *oslidArray = [self.oslids componentsSeparatedByString:@","];
                for (ZXSquareLabel *squareLabel in self.dataArray) {
                    for (NSString *oslid in oslidArray) {
                        if (squareLabel.id == oslid.integerValue) {
                            squareLabel.isSelected = YES;
                            [self.selectedArray addObject:squareLabel];
                            break;
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    [self.tableView reloadData];
                });
            });
        } else {
            [hud turnToError:error.localizedDescription];
        }
    }];
    
    NSInteger num = 0;
    if (self.oslids.length > 0) {
        num = [[self.oslids componentsSeparatedByString:@","] count];
    }
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:[NSString stringWithFormat:@"完成(%@)",@(num)] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setFrame:CGRectMake(0, 0, 100, 30)];
    submitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitleColor: [UIColor colorWithRed:133/255.0 green:216/255.0 blue:188/255.0 alpha:1.0] forState:UIControlStateDisabled];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = item;
    if (num == 0) {
        submitButton.enabled = NO;
    } else {
        submitButton.enabled = YES;
    }
}

- (void)submit
{
    !_selectSquareLabelBlock?:_selectSquareLabelBlock(self.selectedArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureSubmitButton
{
    NSInteger num = self.selectedArray.count;
    [submitButton setTitle:[NSString stringWithFormat:@"完成(%@)",@(num)] forState:UIControlStateNormal];
    if (num == 0) {
        submitButton.enabled = NO;
    } else {
        submitButton.enabled = YES;
    }
}

- (void)addHeader{}
- (void)addFooter{}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXTeacherPickCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXTeacherPickCell"];
    ZXSquareLabel *squareLabel = self.dataArray[indexPath.row];
    [cell.nameLabel setText:squareLabel.name];
    if (squareLabel.isSelected) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [cell.headImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSquareLabel:squareLabel.img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXSquareLabel *squareLabel = self.dataArray[indexPath.row];
    squareLabel.isSelected = YES;
    [self.selectedArray addObject:squareLabel];
    [self configureSubmitButton];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXSquareLabel *squareLabel = self.dataArray[indexPath.row];
    squareLabel.isSelected = NO;
    
    [self.selectedArray removeObject:squareLabel];
    [self configureSubmitButton];
}


#pragma mark - setters and getters
- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
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
