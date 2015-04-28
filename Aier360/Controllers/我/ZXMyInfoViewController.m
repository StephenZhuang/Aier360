//
//  ZXMyInfoViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMyInfoViewController.h"
#import "ZXCustomTextFieldViewController.h"
#import "ZXInfoCell.h"
#import "ZXCity.h"
#import "ZXUser+ZXclient.h"
#import "NSJSONSerialization+ZXString.h"
#import "ZXAddBabyViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXIndustryViewController.h"

@interface ZXMyInfoViewController () {
    BOOL editing;
    NSArray *titleArray;
    BOOL isDatePicker;
}
@property (nonatomic , strong) NSArray *provinceArray;
@property (nonatomic , strong) NSArray *cityArray;
@property (nonatomic , weak) IBOutlet UIPickerView *addressPicker;
@property (nonatomic , weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic , weak) IBOutlet UIView *pickView;
@property (nonatomic , strong) UIView *maskView;
@end

@implementation ZXMyInfoViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXMyInfoViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    editing = NO;
    titleArray = @[@"昵称",@"个性签名",@"性别",@"生日",@"职业",@"所在地",@"家乡"];

    
    if (GLOBAL_UID == _user.uid) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 40, 30)];
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        [button setTitle:@"完成" forState:UIControlStateSelected];
        [button addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    [self loadCity];
}

- (void)addHeader{}
- (void)addFooter{}

- (void)editAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    editing = sender.selected;
    [self.tableView reloadData];
    if (!editing) {
        
        NSString *appuserinfo = [NSJSONSerialization stringWithJSONObject:[_user keyValues]];
        NSString *babysinfo = [NSJSONSerialization stringWithJSONObject:[ZXUser keyValuesArrayWithObjectArray:self.dataArray]];
        
        [ZXUser updateUserInfoAndBabyListWithAppuserinfo:appuserinfo babysinfo:babysinfo uid:GLOBAL_UID block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                if (_editSuccess) {
                    _editSuccess();
                }
            } else {
                [MBProgressHUD showError:errorInfo toView:self.view];
            }
        }];
    }
}

- (void)loadCity
{
    _provinceArray = [ZXCity where:@"subCid == 0"];
    if (_provinceArray.count > 0) {
        [_addressPicker reloadAllComponents];
    } else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Cities" ofType:@"plist"];
            NSArray *arr = [[NSArray alloc] initWithContentsOfFile:path];
            for (NSDictionary *dic in arr) {
                ZXCity *city = [ZXCity insertWithAttribute:@"cid" value:[dic objectForKey:@"cid"]];
                [city update:dic];
                [city save];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                _provinceArray = [ZXCity where:@"subCid == 0"];
                [_addressPicker reloadAllComponents];
            });
        });
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (editing) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    
    NSString *title = titleArray[indexPath.row];
    
    [cell configureUIWithUser:_user title:title indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editing) {
        switch (indexPath.row) {
            case 0:
            {
                [self getEditedText:_user.nickname indexPath:indexPath callback:^(NSString *string) {
                    _user.nickname = string;
                }];
            }
                break;
            case 1:
            {
                [self getEditedText:_user.desinfo indexPath:indexPath callback:^(NSString *string) {
                    _user.desinfo = string;
                }];

            }
                break;
            case 2:
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
                [actionSheet showInView:self.view];
            }
                break;
            case 3:
            {
                isDatePicker = YES;
                [self showPickerWithTag:0];
            }
                break;
            case 4:
            {
                ZXIndustryViewController *vc = [ZXIndustryViewController viewControllerFromStoryboard];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5:
            {
                isDatePicker = NO;
                [self showPickerWithTag:1];
            }
                break;
            case 6:
            {
                isDatePicker = NO;
                [self showPickerWithTag:2];
            }
                break;
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getEditedText:(NSString *)fromText indexPath:(NSIndexPath *)indexPath callback:(void(^)(NSString *string))callback
{
    __weak __typeof(&*self)weakSelf = self;
    ZXCustomTextFieldViewController *vc = [[UIStoryboard storyboardWithName:@"School" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXCustomTextFieldViewController"];
    vc.text = fromText;
    vc.title = titleArray[indexPath.row];
    vc.placeholder = titleArray[indexPath.row];
    vc.textBlock = ^(NSString *text) {
        callback(text);
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        _user.sex = @"男";
        [self.tableView reloadData];
    } else if (buttonIndex == 1) {
        _user.sex = @"女";
        [self.tableView reloadData];
    }
}

#pragma -mark picker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _provinceArray ? _provinceArray.count : 0;
    } else {
        if (_provinceArray.count > 0) {
            ZXCity *province = [_provinceArray objectAtIndex:[_addressPicker selectedRowInComponent:0]];
            _cityArray = [ZXCity where:@"subCid == %i",province.cid];
            return _cityArray ? _cityArray.count : 0;
        } else {
            return 0;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        ZXCity *province = _provinceArray[row];
        return province.name;
    } else {
        ZXCity *city = _cityArray[row];
        return city.name;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        ZXCity *province = [_provinceArray objectAtIndex:[_addressPicker selectedRowInComponent:0]];
        _cityArray = [ZXCity where:@"subCid == %i",province.cid];
        [pickerView reloadComponent:1];
    }
}

- (void)showPickerWithTag:(NSInteger)tag
{
    _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.3;
    [self.view insertSubview:_maskView belowSubview:_pickView];
    
    if (isDatePicker) {
        [_datePicker setHidden:NO];
        [_addressPicker setHidden:YES];
    } else {
        [_addressPicker setHidden:NO];
        [_addressPicker setTag:tag];
        [_datePicker setHidden:YES];
    }
    
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
    if (isDatePicker) {
        NSDate *date = [_datePicker date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _user.birthday = [formatter stringFromDate:date];
    } else {
        ZXCity *province = [_provinceArray objectAtIndex:[_addressPicker selectedRowInComponent:0]];
        ZXCity *city;
        if (_cityArray.count > 0) {
            city = [_cityArray objectAtIndex:[_addressPicker selectedRowInComponent:1]];
        } else {
            city = province;
        }
        if (_addressPicker.tag == 1) {
            _user.city = [NSString stringWithFormat:@"%@-%@",province.name ,city.name];
        } else {
            _user.ht = [NSString stringWithFormat:@"%@-%@",province.name ,city.name];
        }
    }
    [self.tableView reloadData];
    [self hidePicker];
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
