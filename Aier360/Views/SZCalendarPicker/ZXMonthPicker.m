//
//  ZXMonthPicker.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMonthPicker.h"
#import "SZCalendarCell.h"

NSString *const ZXMonthPickerCellIdentifier = @"cell";

@interface ZXMonthPicker ()
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , weak) IBOutlet UILabel *monthLabel;
@property (nonatomic , weak) IBOutlet UIButton *previousButton;
@property (nonatomic , weak) IBOutlet UIButton *nextButton;
@property (nonatomic , strong) UIView *mask;
@end

@implementation ZXMonthPicker

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addTap];
    [self addSwipe];
    [self show];
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:@"monthPickerHide" object:nil];
    [_collectionView registerClass:[SZCalendarCell class] forCellWithReuseIdentifier:ZXMonthPickerCellIdentifier];
}

- (void)customInterface
{
    CGFloat itemWidth = _collectionView.frame.size.width / 7;
    CGFloat itemHeight = _collectionView.frame.size.height / 2;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [_collectionView setCollectionViewLayout:layout animated:YES];
    
    
}

- (void)setYear:(NSInteger)year
{
    _year = year;
    [_monthLabel setText:[NSString stringWithFormat:@"%i",year]];
    [_collectionView reloadData];
}

#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SZCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZXMonthPickerCellIdentifier forIndexPath:indexPath];
    [cell.dateLabel setText:[NSString stringWithFormat:@"%i",indexPath.row + 1]];
    
            //this month
    if (_year < _currentYear) {
        [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#6f6f6f"]];
    } else if (_year == _currentYear) {
        if (indexPath.row + 1 < _month) {
            [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#6f6f6f"]];
        } else if (indexPath.row + 1 == _month) {
            [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#4898eb"]];
        } else {
            [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#cbcbcb"]];
        }
    } else {
        [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#cbcbcb"]];
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_year < _currentYear) {
        return YES;
    } else if (_year == _currentYear) {
        if (indexPath.row + 1 < _month) {
            return YES;
        } else if (indexPath.row + 1 == _month) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mobthBlock) {
        self.mobthBlock(indexPath.row + 1, _year);
    }
    
    [self hide];
}

- (IBAction)previouseAction:(UIButton *)sender
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.year = _year - 1;
    } completion:nil];
}

- (IBAction)nexAction:(UIButton *)sender
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.year = _year + 1;
    } completion:nil];
}

+ (instancetype)showOnView:(UIView *)view
{
    ZXMonthPicker *monthPicker = [[[NSBundle mainBundle] loadNibNamed:@"ZXMonthPicker" owner:self options:nil] firstObject];
    monthPicker.mask = [[UIView alloc] initWithFrame:view.bounds];
    monthPicker.mask.backgroundColor = [UIColor blackColor];
    monthPicker.mask.alpha = 0.3;
    NSDate *date = [NSDate date];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    monthPicker.currentYear = comp.year;
    monthPicker.month = comp.month;
    monthPicker.year = monthPicker.currentYear;
    [view addSubview:monthPicker.mask];
    [view addSubview:monthPicker];
    return monthPicker;
}

- (void)show
{
    self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        [self customInterface];
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
        self.mask.alpha = 0;
    } completion:^(BOOL isFinished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"monthPickerHide" object:nil];
        if (_callButton) {
            [_callButton setSelected:NO];
        }
        [self.mask removeFromSuperview];
        [self removeFromSuperview];
    }];
}

+ (void)callHide
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"monthPickerHide" object:nil];
}


- (void)addSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nexAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}

- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.mask addGestureRecognizer:tap];
}

@end
