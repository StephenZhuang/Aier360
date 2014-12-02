//
//  ZXClassHistoryViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/2.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClassHistoryViewController.h"
#import "ZXCardHistory+ZXclient.h"
#import "ZXCardHistoryCell.h"

#import "SZCalendarPicker.h"
#import "ZXDayHistoryViewController.h"

@interface ZXClassHistoryViewController () {
    NSString *thisDay;
}

@end

@implementation ZXClassHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"班级记录";
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _dateString = [formatter stringFromDate:date];
    thisDay = _dateString;
}

- (IBAction)goToToday
{
    [_dateButton setTitle:@"今天" forState:UIControlStateNormal];
    [_todayButton setHidden:YES];
    _dateString = thisDay;
    [self.tableView headerBeginRefreshing];
}

- (IBAction)showCalendarPicker:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
        calendarPicker.today = [NSDate date];
        calendarPicker.date = calendarPicker.today;
        calendarPicker.frame = CGRectMake(0, 0, self.view.frame.size.width, 352);
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year) {
            NSString *string = [NSString stringWithFormat:@"%i-%.2d-%.2d",year ,month ,day];
            [_dateButton setTitle:string forState:UIControlStateNormal];
            [_dateButton setSelected:!_dateButton.selected];
            if (![string isEqualToString:_dateString]) {
                _dateString = [NSString stringWithFormat:@"%i-%.2d-%.2d",year ,month ,day];
                [self.tableView headerBeginRefreshing];
            }
            if ([string isEqualToString:thisDay]) {
                [_dateButton setTitle:@"今天" forState:UIControlStateNormal];
                [_todayButton setHidden:YES];
            } else {
                [_todayButton setHidden:NO];
            }
        };
        
    } else {
        [SZCalendarPicker callHide];
    }
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXCardHistory getClassCardHistoryWithSid:appStateInfo.sid cid:appStateInfo.cid beginday:_dateString lastday:_dateString page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        
        [self configureArray:array];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXCardHistory *history = self.dataArray[indexPath.row];
    [cell.textLabel setText:history.name];
    [cell.detailTextLabel setText:[NSString stringWithIntger:history.card_count]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
