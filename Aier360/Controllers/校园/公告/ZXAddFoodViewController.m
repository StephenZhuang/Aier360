//
//  ZXAddFoodViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/28.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddFoodViewController.h"
#import "ZXAddFoodCell.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXAnnouncement+ZXclient.h"

@interface ZXAddFoodViewController ()

@end

@implementation ZXAddFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布餐饮";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
    
    _picker.minimumDate = [NSDate date];
    _dataArray = [[NSMutableArray alloc] init];
    if (_food) {
        NSArray *arr = [_food.content componentsSeparatedByString:@"\\n"];
        for (NSString *string in arr) {
            NSArray *array = [string componentsSeparatedByString:@"："];
            [_dataArray addObject:[array mutableCopy]];
        }
        _date = _food.ddate;
        [_smsButton setSelected:(_food.ismessage==1)];
    } else {
        [_dataArray addObject:[[NSMutableArray alloc] initWithObjects:@"早餐",@"", nil]];
        [_dataArray addObject:[[NSMutableArray alloc] initWithObjects:@"午餐",@"", nil]];
        [_dataArray addObject:[[NSMutableArray alloc] initWithObjects:@"点心",@"", nil]];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _date = [formatter stringFromDate:date];
    }
    
    
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXAnnouncement getSmsCountWithSid:appStateInfo.sid cid:appStateInfo.cid sendType:2 block:^(NSInteger totalMessage, NSInteger mesCount, NSError *error) {
        [_smsButton setTitle:[NSString stringWithFormat:@"同时发送手机短信(本月剩余短信%i条)",mesCount] forState:UIControlStateNormal];
    }];
}

- (void)submit
{
    [self.view endEditing:YES];
    [_tableView setContentOffset:CGPointZero animated:YES];
    
    NSMutableArray *stringArr = [[NSMutableArray alloc] init];
    for (NSMutableArray *array in _dataArray) {
        if ([[array firstObject] length] > 0 && [[array lastObject] length] > 0) {
            [stringArr addObject:[array componentsJoinedByString:@"："]];
        }
    }
    
    if (stringArr.count == 0) {
        [MBProgressHUD showText:@"请填写餐饮信息" toView:self.view];
        return;
    }
    
    NSString *foodString = [stringArr componentsJoinedByString:@"\\n"];
    NSString *content = [_date stringByAppendingFormat:@"$%@",foodString];
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"正在发布" toView:nil];
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    
    if (_food) {
        [ZXDailyFood eidtFoodWithDfid:_food.dfid ddate:_date content:foodString block:^(BaseModel *baseModel, NSError *error) {
            if (baseModel) {
                if (baseModel.s) {
                    [hud turnToSuccess:@""];
                    if (_addSuccessBlock) {
                        _addSuccessBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [hud turnToError:baseModel.error_info];
                }
            } else {
                [hud turnToError:@""];
            }
        }];
    } else {
        [ZXDailyFood addFoodWithSid:appStateInfo.sid dailyfood:content ismessage:_smsButton.selected?1:0 block:^(BaseModel *baseModel, NSError *error) {
            if (baseModel) {
                if (baseModel.s) {
                    [hud turnToSuccess:@""];
                    if (_addSuccessBlock) {
                        _addSuccessBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [hud turnToError:baseModel.error_info];
                }
            } else {
                [hud turnToError:@""];
            }
        }];
    }
}

- (IBAction)addItem:(id)sender
{
    if (_dataArray.count < 6) {
        [_dataArray addObject:[[NSMutableArray alloc] initWithObjects:@"",@"", nil]];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (IBAction)smsButtonAction:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}

- (IBAction)deleteItem:(UIButton *)sender
{
    [_dataArray removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
}

- (IBAction)cancelAction:(id)sender
{
    [self hidePicker];
}

- (IBAction)doneAction:(id)sender
{
    NSDate *date = [_picker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _date = [formatter stringFromDate:date];
    [self.tableView reloadData];
    [self hidePicker];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return _dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"本条餐饮将发布于所编辑日期的上午9:00";
    } else {
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //    view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:176 green:173 blue:165]];
    [header.textLabel setFont:[UIFont systemFontOfSize:14]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell.detailTextLabel setText:_date];
        return cell;
    } else {
        ZXAddFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXAddFoodCell"];
        [cell.titleTextField setText:[_dataArray[indexPath.row] firstObject]];
        [cell.titleTextField setTag:indexPath.row * 10];
        [cell.contentTextField setText:[_dataArray[indexPath.row] lastObject]];
        [cell.contentTextField setTag:indexPath.row * 10 + 1];
        cell.deleteButton.tag = indexPath.row;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self showPicker];
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

#pragma -mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_tableView setContentOffset:CGPointZero animated:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger row = textField.tag / 10;
    [_tableView setContentOffset:CGPointMake(0, 44 * row) animated:YES];
}

- (void)textDidChange:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    NSInteger section = textField.tag / 10;
    NSInteger row = textField.tag % 10;
    _dataArray[section][row] = textField.text;
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
