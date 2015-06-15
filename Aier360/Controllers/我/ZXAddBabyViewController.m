//
//  ZXAddBabyViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddBabyViewController.h"
#import "ZXMenuCell.h"
#import "ZXCustomSelectViewController.h"
#import "ZXCustomTextFieldViewController.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXAddBabyViewController () {
    NSArray *titleArray;
}
@property (nonatomic , weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic , weak) IBOutlet UIView *pickView;
@property (nonatomic , strong) UIView *maskView;
@property (nonatomic , weak) IBOutlet UIButton *deleteButton;
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
    if (!_isAdd) {
        self.title = @"宝宝资料";
    } else {
        self.title = @"添加宝宝";
    }
    [_deleteButton setHidden:_isAdd];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
    
    titleArray = @[@"宝宝昵称",@"性别",@"生日"];
}

- (void)setExtrueLineHidden{}

- (void)submit
{
    if (self.baby.nickname.length == 0 || self.baby.sex.length == 0 || self.baby.birthday.length == 0) {
        [MBProgressHUD showText:@"请填写完整" toView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    
    if (_isAdd) {
        [ZXBaby addBabyWithUid:GLOBAL_UID nickname:self.baby.nickname sex:self.baby.sex birthday:self.baby.birthday block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud turnToSuccess:@""];
                if (_addBlock) {
                    _addBlock(_baby);
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [hud turnToError:errorInfo];
            }
        }];
        
    } else {
        [ZXBaby updateBabyWithUid:GLOBAL_UID bid:self.baby.bid nickname:self.baby.nickname sex:self.baby.sex birthday:self.baby.birthday block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud turnToSuccess:@""];
                if (_addBlock) {
                    _addBlock(_baby);
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [hud turnToError:errorInfo];
            }
        }];
    }
}

- (void)addHeader{}
- (void)addFooter{}

#pragma mark- tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXBaby *baby = self.baby;
    switch (indexPath.row) {
        case 0:
            [cell.titleLabel setText:@"宝宝昵称"];
            [cell.hasNewLabel setText:baby.nickname];
            break;
        case 1:
            [cell.titleLabel setText:@"性别"];
            [cell.hasNewLabel setText:baby.sex];
            break;
        case 2:
        {
            [cell.titleLabel setText:@"生日"];
            [cell.hasNewLabel setText:[[baby.birthday componentsSeparatedByString:@"T"] firstObject]];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [self getEditedText:_baby.nickname indexPath:indexPath callback:^(NSString *string) {
                self.baby.nickname = string;
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
        default:
            break;
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
    self.baby.birthday = [formatter stringFromDate:date];
    [self.tableView reloadData];
    [self hidePicker];
}

#pragma mark- actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.baby.sex = @"男";
        [self.tableView reloadData];
    } else if (buttonIndex == 1) {
        self.baby.sex = @"女";
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

- (IBAction)deleteBaby:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    
    [ZXBaby deleteBabyWithUid:GLOBAL_UID bid:self.baby.bid block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [hud turnToSuccess:@""];
            if (_deleteBlock) {
                _deleteBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
    
}

#pragma mark- getters and setters
- (ZXBaby *)baby
{
    if (!_baby) {
        _baby = [[ZXBaby alloc] init];
    }
    return _baby;
}
@end
