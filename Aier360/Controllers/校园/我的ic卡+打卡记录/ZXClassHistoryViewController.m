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
#import "ZXClassPickerCell.h"
#import "SZCalendarPicker.h"
#import "ZXDayHistoryViewController.h"

@interface ZXClassHistoryViewController () {
    NSString *thisDay;
    UIView *mask;
}
@property (nonatomic , weak) IBOutlet UIButton *todayButton;
@property (nonatomic , weak) IBOutlet ZXDropTitleView *classButton;
@property (nonatomic , weak) IBOutlet ZXDropTitleView *dateButton;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *classArray;
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
    
    _classArray = [[NSMutableArray alloc] init];
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXClass getClassListWithSid:appStateInfo.sid block:^(NSArray *array, NSError *error) {
        [_classArray addObjectsFromArray:array];
        [_collectionView reloadData];
        if (_classArray.count > 0) {
            self.currentClass = [_classArray firstObject];
            [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            
            [self.tableView headerBeginRefreshing];
        }
    }];
}

- (void)setCurrentClass:(ZXClass *)currentClass
{
    _currentClass = currentClass;
    [_classButton setTitle:currentClass.cname forState:UIControlStateNormal];
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
        __weak __typeof(&*self)weakSelf = self;
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
                [weakSelf.tableView headerBeginRefreshing];
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
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXCardHistory getClassCardHistoryWithSid:appStateInfo.sid cid:_currentClass.cid beginday:_dateString lastday:_dateString page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        
        [self configureArray:array];
    }];
}

#pragma mark- tableview delegate
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

#pragma mark- collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _classArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXClassPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXClassPickerCell" forIndexPath:indexPath];
    ZXClass *zxclass = self.classArray[indexPath.row];
    [cell.textLabel setText:zxclass.cname];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXClass *zxclass = self.classArray[indexPath.row];
    if (![_currentClass isEqual:zxclass]) {
        self.currentClass = zxclass;
        [self.tableView headerBeginRefreshing];
    }
    [self hideClassPicker];
}

- (IBAction)showClassPicker:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        [self showClassPicker];
    } else {
        [self hideClassPicker];
    }
}

- (void)showClassPicker
{
    [self addMask];
    [UIView animateWithDuration:0.25 animations:^(void) {
        _collectionView.transform = CGAffineTransformTranslate(_collectionView.transform, 0, 44 + CGRectGetHeight(_collectionView.frame));
    }];
}

- (void)addMask
{
    mask = [[UIView alloc] initWithFrame:self.view.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.3;
    [self.view insertSubview:mask belowSubview:_collectionView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideClassPicker)];
    [mask addGestureRecognizer:tap];
}

- (void)hideClassPicker
{
    [UIView animateWithDuration:0.25 animations:^(void) {
        _collectionView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        [mask removeFromSuperview];
        _classButton.selected = NO;
    }];
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
