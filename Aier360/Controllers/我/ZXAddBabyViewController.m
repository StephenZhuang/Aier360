//
//  ZXAddBabyViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddBabyViewController.h"
#import "ZXInfoCell.h"
#import "ZXCustomSelectViewController.h"
#import "ZXCustomTextFieldViewController.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXAddBabyViewController () {
    BOOL isAdd;
    NSArray *titleArray;
}
@property (nonatomic , weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic , weak) IBOutlet UIView *pickView;
@property (nonatomic , strong) UIView *maskView;
@end

@implementation ZXAddBabyViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXAddBabyViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_baby) {
        self.title = @"宝宝信息";
        isAdd = NO;
    } else {
        self.title = @"添加宝宝";
        isAdd = YES;
        _baby = [[ZXUser alloc] init];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
    
    titleArray = @[@"昵称",@"性别",@"生日",@"我是TA的"];
}

- (void)submit
{
    if (_baby.nickname.length == 0) {
        [MBProgressHUD showText:@"请填写昵称" toView:self.view];
        return;
    }
    
    if (_addBlock) {
        _addBlock(_baby);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addHeader{}
- (void)addFooter{}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isAdd) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        ZXUser *baby = _baby;
        switch (indexPath.row) {
            case 0:
                [cell.titleLabel setText:@"昵称"];
                [cell.contentLabel setText:baby.nickname];
                break;
            case 1:
                [cell.titleLabel setText:@"性别"];
                [cell.contentLabel setText:baby.sex];
                break;
            case 2:
            {
                [cell.titleLabel setText:@"年龄"];
                NSDate *date = [NSDate new];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *birthday = [formatter dateFromString:[[baby.birthday componentsSeparatedByString:@"T"] firstObject]];
                NSTimeInterval time = [date timeIntervalSinceDate:birthday];
                NSInteger age = (NSInteger)(time / (365.4 * 24 * 3600));
                [cell.contentLabel setText:[NSString stringWithIntger:age]];
            }
                break;
            case 3:
                [cell.titleLabel setText:@"我是TA的"];
                [cell.contentLabel setText:baby.relation];
                break;
            default:
                break;
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deleteCell"];
        [cell.textLabel setText:@"删除宝宝"];
        [cell.textLabel setTextColor:[UIColor redColor]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                [self getEditedText:_baby.nickname indexPath:indexPath callback:^(NSString *string) {
                    _baby.nickname = string;
                }];
            }
                break;
            case 1:
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
                [actionSheet showInView:self.view];
            }
                break;
            case 2:
                [self showPicker];
                break;
            case 3:
            {
                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"姥姥",@"姥爷",@"其他", nil];
                [self getEditSelect:arr indexPath:indexPath callback:^(id object) {
                    _baby.relation = object;
                }];
            }
                break;
            default:
                break;
        }
    } else {
        if (_addBlock) {
            _addBlock(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showPicker
{
    _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.3;
    [self.view insertSubview:_maskView belowSubview:_pickView];
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        _pickView.transform = CGAffineTransformTranslate(_pickView.transform, 0, - CGRectGetHeight(_pickView.frame));
    }];
}

- (void)hidePicker
{
    [UIView animateWithDuration:0.25 animations:^(void) {
        _maskView.transform = CGAffineTransformTranslate(_maskView.transform, 0, - CGRectGetHeight(_maskView.frame));
        _pickView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        if (isFinished) {
            [_maskView removeFromSuperview];
        }
    }];
}

- (IBAction)cancelAction:(id)sender
{
    [self hidePicker];
}

- (IBAction)doneAction:(id)sender
{
    NSDate *date = [_datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _baby.birthday = [formatter stringFromDate:date];
    [self.tableView reloadData];
    [self hidePicker];
}

#pragma -mark actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        _baby.sex = @"男";
        [self.tableView reloadData];
    } else if (buttonIndex == 1) {
        _baby.sex = @"女";
        [self.tableView reloadData];
    }
}


- (void)getEditedText:(NSString *)fromText indexPath:(NSIndexPath *)indexPath callback:(void(^)(NSString *string))callback
{
    ZXCustomTextFieldViewController *vc = [[UIStoryboard storyboardWithName:@"School" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXCustomTextFieldViewController"];
    vc.text = fromText;
    vc.title = titleArray[indexPath.row];
    vc.placeholder = titleArray[indexPath.row];
    vc.textBlock = ^(NSString *text) {
        callback(text);
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getEditSelect:(NSMutableArray *)fromArray indexPath:(NSIndexPath *)indexPath callback:(void(^)(id object))callback
{
    ZXCustomSelectViewController *vc = [[UIStoryboard storyboardWithName:@"School" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXCustomSelectViewController"];
    vc.title = @"我是TA的";
    vc.dataArray = fromArray;
    vc.objectBlock = ^(id object) {
        callback(object);
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
@end
