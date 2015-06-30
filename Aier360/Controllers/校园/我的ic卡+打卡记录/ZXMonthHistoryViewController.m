//
//  ZXMonthHistoryViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMonthHistoryViewController.h"
#import "ZXCardHistory+ZXclient.h"
#import "ZXCardHistoryCell.h"
#import "ZXDropTitleView.h"
#import "ZXMonthPicker.h"
#import "ZXDayHistoryViewController.h"

@interface ZXMonthHistoryViewController () {
    UIButton *thisMonthButton;
    ZXDropTitleView *dropTitle;
    NSString *thisMonth;
}

@end

@implementation ZXMonthHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    _dateString = [formatter stringFromDate:date];
    thisMonth = _dateString;
    
    thisMonthButton = [UIButton buttonWithType:UIButtonTypeSystem];
    thisMonthButton.frame = CGRectMake(0, 0, 40, 30);
    thisMonthButton.tintColor = [UIColor whiteColor];
    [thisMonthButton setTitle:@"本月" forState:UIControlStateNormal];
    [thisMonthButton addTarget:self action:@selector(goToThisMonth) forControlEvents:UIControlEventTouchUpInside];
    thisMonthButton.hidden = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:thisMonthButton];
    self.navigationItem.rightBarButtonItem = item;
    
    dropTitle = [[[NSBundle mainBundle] loadNibNamed:@"ZXDropTitleView" owner:self options:nil] firstObject];
    [dropTitle addTarget:self action:@selector(showCalendarPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:dropTitle];
}

- (void)goToThisMonth
{
    [dropTitle setTitle:@"本月" forState:UIControlStateNormal];
    [thisMonthButton setHidden:YES];
    _dateString = thisMonth;
    [self.tableView headerBeginRefreshing];
}

- (void)showCalendarPicker:(UIButton *)sender
{
    __weak __typeof(&*self)weakSelf = self;
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        ZXMonthPicker *monthPicker = [ZXMonthPicker showOnView:self.view];
        monthPicker.frame = CGRectMake(0, 0, self.view.frame.size.width, 132);
        monthPicker.callButton = sender;
        monthPicker.mobthBlock = ^(NSInteger month, NSInteger year) {
            NSString *string = [NSString stringWithFormat:@"%i-%.2d",year ,month];
            [dropTitle setTitle:string forState:UIControlStateNormal];
            if (![string isEqualToString:_dateString]) {
                weakSelf.dateString = [NSString stringWithFormat:@"%i-%.2d",year ,month];
                [weakSelf.tableView headerBeginRefreshing];
            }
            if ([string isEqualToString:thisMonth]) {
                [dropTitle setTitle:@"本月" forState:UIControlStateNormal];
                [thisMonthButton setHidden:YES];
            } else {
                [thisMonthButton setHidden:NO];
            }
        };
        
    } else {
        [ZXMonthPicker callHide];
    }
}

- (void)loadData
{
    ZXSchool *school = [ZXUtils sharedInstance].currentSchool;
    [ZXCardHistory getMyCardHistoryWithSid:school.sid uid:[ZXUtils sharedInstance].user.uid yearAndMonthStr:_dateString page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        
        [self configureArray:array];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCardHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXCardHistory *history = self.dataArray[indexPath.row];
    NSString *day = history.day;
    if (day.length == 10) {
        day = [day substringFromIndex:5];
    }
    [cell.titleLabel setText:day];
    if (history.in_time.length > 0) {
        [cell.AMLabel setText:history.in_time];
    } else {
        [cell.AMLabel setText:@"未打卡"];
    }
    if (history.out_time.length > 0) {
        [cell.PMLabel setText:history.out_time];
    } else {
        [cell.PMLabel setText:@"未打卡"];
    }
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
    vc.identity = ZXIdentitySchoolMaster;
}


@end
