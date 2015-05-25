//
//  ZXParentHistoryViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/3.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXParentHistoryViewController.h"
#import "ZXCardHistory+ZXclient.h"
#import "ZXCardHistoryCell.h"
#import "ZXClassPickerCell.h"
#import "SZCalendarPicker.h"
#import "ZXDayHistoryViewController.h"

@interface ZXParentHistoryViewController () {
    NSString *thisDay;
    UIView *mask;
}
@property (nonatomic , weak) IBOutlet UIButton *todayButton;
@property (nonatomic , weak) IBOutlet ZXDropTitleView *babyButton;
@property (nonatomic , weak) IBOutlet ZXDropTitleView *dateButton;
@property (nonatomic , weak) IBOutlet UITableView *babyTableView;
@property (nonatomic , strong) NSMutableArray *babyArray;
@property (nonatomic , weak) IBOutlet UIView *tipView;
@end

@implementation ZXParentHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _dateString = [formatter stringFromDate:date];
    thisDay = _dateString;
    
    _babyArray = [[NSMutableArray alloc] init];
    
    [ZXStudent getStudentListWithUid:[ZXUtils sharedInstance].user.uid block:^(NSArray *array, NSError *error) {
        [_babyArray addObjectsFromArray:array];
        [_babyTableView reloadData];
        if (_babyArray.count > 0) {
            self.currentStudent = [_babyArray firstObject];

            [self.tableView headerBeginRefreshing];
        }
    }];
    
    _dateButton = [[[NSBundle mainBundle] loadNibNamed:@"ZXDropTitleView" owner:self options:nil] firstObject];
    [_dateButton addTarget:self action:@selector(showCalendarPicker:) forControlEvents:UIControlEventTouchUpInside];
    [_dateButton setTitle:@"今天" forState:UIControlStateNormal];
    [self.navigationItem setTitleView:_dateButton];
    
    _todayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _todayButton.frame = CGRectMake(0, 0, 40, 30);
    _todayButton.tintColor = [UIColor whiteColor];
    [_todayButton setTitle:@"今天" forState:UIControlStateNormal];
    [_todayButton addTarget:self action:@selector(goToToday) forControlEvents:UIControlEventTouchUpInside];
    _todayButton.hidden = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_todayButton];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)setCurrentStudent:(ZXStudent *)currentStudent
{
    _currentStudent = currentStudent;
    [_babyButton setTitle:currentStudent.sname forState:UIControlStateNormal];
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
        calendarPicker.callButton = sender;
        calendarPicker.frame = CGRectMake(0, 0, self.view.frame.size.width, 352);
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year) {
            NSString *string = [NSString stringWithFormat:@"%i-%.2d-%.2d",year ,month ,day];
            [_dateButton setTitle:string forState:UIControlStateNormal];
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

- (void)addHeader
{
    [self.tableView addHeaderWithCallback:^(void) {
        if (!hasMore) {
            [self.tableView setFooterHidden:NO];
        }
        page = 1;
        hasMore = YES;
        [self loadData];
    }];
}

- (void)loadData
{
    [ZXCardHistory getBabyDetailCardHistoryWithUid:_currentStudent.uid beginday:_dateString block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (void)configureArray:(NSArray *)array
{
    [self.dataArray removeAllObjects];
    if (array) {
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    [self.tableView headerEndRefreshing];
    if (self.dataArray.count > 0) {
        [_tipView setHidden:YES];
    } else {
        [_tipView setHidden:NO];
    }
}

#pragma mark- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return self.dataArray.count;
    } else {
        return _babyArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        ZXCardHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        ZXCardHistory *history = self.dataArray[indexPath.row];
        [cell.titleLabel setText:[NSString stringWithFormat:@"打卡记录%i",indexPath.row+1]];
        [cell.AMLabel setText:history.time];
        if (history.type == 1) {
            [cell.PMLabel setText:@"进"];
            [cell.PMLabel setBackgroundColor:[UIColor colorWithRed:32 green:196 blue:138]];
        } else {
            [cell.PMLabel setText:@"出"];
            [cell.PMLabel setBackgroundColor:[UIColor colorWithRed:250 green:107 blue:20]];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"babycell"];
        ZXStudent *student = [self.babyArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:student.sname];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_babyTableView]) {
        ZXStudent *student = self.babyArray[indexPath.row];
        if (![_currentStudent isEqual:student]) {
            self.currentStudent = student;
            [self.tableView headerBeginRefreshing];
        }
        [self hideBabyPicker];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)showBabyPicker:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        [self showBabyPicker];
    } else {
        [self hideBabyPicker];
    }
}

- (void)showBabyPicker
{
    [self addMask];
    [UIView animateWithDuration:0.25 animations:^(void) {
        _babyTableView.transform = CGAffineTransformTranslate(_babyTableView.transform, 0, 44 + CGRectGetHeight(_babyTableView.frame));
    }];
}

- (void)addMask
{
    mask = [[UIView alloc] initWithFrame:self.view.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.3;
    [self.view insertSubview:mask belowSubview:_babyTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBabyPicker)];
    [mask addGestureRecognizer:tap];
}

- (void)hideBabyPicker
{
    [UIView animateWithDuration:0.25 animations:^(void) {
        _babyTableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        [mask removeFromSuperview];
        _babyButton.selected = NO;
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
