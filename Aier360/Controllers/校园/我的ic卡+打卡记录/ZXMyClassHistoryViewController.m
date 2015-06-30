//
//  ZXMyClassHistoryViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/3.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMyClassHistoryViewController.h"
#import "ZXCardHistory+ZXclient.h"
#import "ZXCardHistoryCell.h"
#import "ZXDropTitleView.h"
#import "SZCalendarPicker.h"
#import "ZXDayHistoryViewController.h"

@interface ZXMyClassHistoryViewController () {
    UIButton *thisDayButton;
    ZXDropTitleView *dropTitle;
    NSString *thisDay;
}

@end

@implementation ZXMyClassHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _dateString = [formatter stringFromDate:date];
    thisDay = _dateString;
    
    thisDayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    thisDayButton.frame = CGRectMake(0, 0, 40, 30);
    thisDayButton.tintColor = [UIColor whiteColor];
    [thisDayButton setTitle:@"今天" forState:UIControlStateNormal];
    [thisDayButton addTarget:self action:@selector(goToThisMonth) forControlEvents:UIControlEventTouchUpInside];
    thisDayButton.hidden = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:thisDayButton];
    self.navigationItem.rightBarButtonItem = item;
    
    dropTitle = [[[NSBundle mainBundle] loadNibNamed:@"ZXDropTitleView" owner:self options:nil] firstObject];
    [dropTitle setTitle:@"今天" forState:UIControlStateNormal];
    [dropTitle addTarget:self action:@selector(showCalendarPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:dropTitle];
}

- (void)goToThisMonth
{
    [dropTitle setTitle:@"今天" forState:UIControlStateNormal];
    [thisDayButton setHidden:YES];
    _dateString = thisDay;
    [self.tableView headerBeginRefreshing];
}

- (void)showCalendarPicker:(UIButton *)sender
{
    __weak __typeof(&*self)weakSelf = self;
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
        calendarPicker.today = [NSDate date];
        calendarPicker.date = calendarPicker.today;
        calendarPicker.callButton = sender;
        calendarPicker.frame = CGRectMake(0, 0, self.view.frame.size.width, 352);
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year) {
            NSString *string = [NSString stringWithFormat:@"%i-%.2d-%.2d",year ,month ,day];
            [dropTitle setTitle:string forState:UIControlStateNormal];
            if (![string isEqualToString:_dateString]) {
                weakSelf.dateString = [NSString stringWithFormat:@"%i-%.2d-%.2d",year ,month ,day];
                [weakSelf.tableView headerBeginRefreshing];
            }
            if ([string isEqualToString:thisDay]) {
                [dropTitle setTitle:@"今天" forState:UIControlStateNormal];
                [thisDayButton setHidden:YES];
            } else {
                [thisDayButton setHidden:NO];
            }
        };
        
    } else {
        [SZCalendarPicker callHide];
    }
}

- (void)loadData
{
    ZXSchool *school = [ZXUtils sharedInstance].currentSchool;
    ZXAppStateInfo *appStateInfo = [[ZXUtils sharedInstance] getAppStateInfoWithIdentity:ZXIdentityClassMaster cid:0];
    [ZXCardHistory getClassCardHistoryWithSid:school.sid cid:appStateInfo.cid beginday:_dateString lastday:_dateString page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZXCardHistory *history = self.dataArray[indexPath.row];
    ZXDayHistoryViewController *vc = segue.destinationViewController;
    vc.history = history;
    vc.identity = ZXIdentityParent;
}

@end
