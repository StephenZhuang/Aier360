//
//  ZXSchoolSummaryViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/4.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolSummaryViewController.h"
#import "ZXCustomTextFieldViewController.h"

@interface ZXSchoolSummaryViewController ()
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSArray *titleArray;
@property (nonatomic , assign) BOOL editing;
@end

@implementation ZXSchoolSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"校园简介";
    _titleArray = @[@[@"校园简介",@"地址",@"电话",@"邮编",@"传真",@"电子邮箱",@"校园网站"],@[@"姓名",@"联系电话",@"电子邮箱",@"QQ"]];
    _editing = NO;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.tableView setExtrueLineHidden];
}

- (void)edit:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _editing = sender.selected;
    [self.tableView reloadData];
    if (!sender.selected) {
        NSDictionary *dic = [_schoolDetail keyValues];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [ZXSchool updateSchoolInfoWithSid:_schoolDetail.sid schools:[NSString stringWithFormat:@"{\"sid\":%i}",_schoolDetail.sid] schoolInfoDetails:string block:^(ZXBaseModel *baseModel, NSError *error) {
            if (baseModel && baseModel.s) {

            }
        }];
    }
}

#pragma - mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    } else {
        return @"园长信息";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    } else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        NSString *string = cell.detailTextLabel.text;
        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize size = CGSizeMake(self.view.frame.size.width - cell.detailTextLabel.frame.origin.x,2000);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        return MAX(44, labelsize.height + 16);
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //    view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:154 green:154 blue:154]];
    [header.textLabel setFont:[UIFont systemFontOfSize:14]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (_editing) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell.textLabel setText:_titleArray[indexPath.section][indexPath.row]];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [cell.detailTextLabel setText:_schoolDetail.desinfo];
                break;
            case 1:
                [cell.detailTextLabel setText:_schoolDetail.address];
                break;
            case 2:
                [cell.detailTextLabel setText:_schoolDetail.phone];
                break;
            case 3:
                [cell.detailTextLabel setText:_schoolDetail.postcode];
                break;
            case 4:
                [cell.detailTextLabel setText:_schoolDetail.fax];
                break;
            case 5:
                [cell.detailTextLabel setText:_schoolDetail.email];
                break;
            case 6:
                [cell.detailTextLabel setText:_schoolDetail.url];
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                [cell.detailTextLabel setText:_schoolDetail.tname];
                break;
            case 1:
                [cell.detailTextLabel setText:_schoolDetail.tphone];
                break;
            case 2:
                [cell.detailTextLabel setText:_schoolDetail.temail];
                break;
            case 3:
                [cell.detailTextLabel setText:_schoolDetail.qqnum];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_editing) {
        
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
                    [self getEditedText:_schoolDetail.desinfo indexPath:indexPath callback:^(NSString *string) {
                        _schoolDetail.desinfo = string;
                    }];
                }
                    break;
                case 1:
                {
                    [self getEditedText:_schoolDetail.address indexPath:indexPath callback:^(NSString *string) {
                        _schoolDetail.address = string;
                    }];
                }
                    break;
                case 2:
                {
                    [self getEditedText:_schoolDetail.phone indexPath:indexPath callback:^(NSString *string) {
                        _schoolDetail.phone = string;
                    }];
                }
                    break;
                case 3:
                {
                    [self getEditedText:_schoolDetail.postcode indexPath:indexPath callback:^(NSString *string) {
                        _schoolDetail.postcode = string;
                    }];
                }
                    break;
                case 4:
                {
                    [self getEditedText:_schoolDetail.fax indexPath:indexPath callback:^(NSString *string) {
                        _schoolDetail.fax = string;
                    }];
                }
                    break;
                case 5:
                {
                    [self getEditedText:_schoolDetail.email indexPath:indexPath callback:^(NSString *string) {
                        _schoolDetail.email = string;
                    }];
                }
                    break;
                case 6:
                {
                    [self getEditedText:_schoolDetail.url indexPath:indexPath callback:^(NSString *string) {
                        _schoolDetail.url = string;
                    }];
                }
                    break;
                default:
                    break;
            }
        } else {
            switch (indexPath.row) {
                case 0:
                {
                    [self getEditedText:_schoolDetail.tname indexPath:indexPath callback:^(NSString *string) {
                        _schoolDetail.tname = string;
                    }];
                }
                    break;
                case 1:
                {
                    [self getEditedText:_schoolDetail.tphone indexPath:indexPath callback:^(NSString *string) {
                        _schoolDetail.tphone = string;
                    }];
                }
                    break;
                case 2:
                {
                    [self getEditedText:_schoolDetail.temail indexPath:indexPath callback:^(NSString *string) {
                        _schoolDetail.temail = string;
                    }];
                }
                    break;
                case 3:
                {
                    [self getEditedText:_schoolDetail.qqnum indexPath:indexPath callback:^(NSString *string) {
                        _schoolDetail.qqnum = string;
                    }];
                }
                    break;
                default:
                    break;
            }
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                NSString *telUrl = [NSString stringWithFormat:@"telprompt://%@",_schoolDetail.phone];
                NSURL *url = [[NSURL alloc] initWithString:telUrl];
                [[UIApplication sharedApplication] openURL:url];
            } else if (indexPath.row == 6) {
                NSString *telUrl = _schoolDetail.url;
                if (telUrl.length > 0) {                    
                    if (![telUrl hasPrefix:@"http"]) {
                        telUrl = [@"http://" stringByAppendingString:telUrl];
                    }
                    NSURL *url = [[NSURL alloc] initWithString:telUrl];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        } else {
            if (indexPath.row == 1) {
                NSString *telUrl = [NSString stringWithFormat:@"telprompt://%@",_schoolDetail.tphone];
                NSURL *url = [[NSURL alloc] initWithString:telUrl];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getEditedText:(NSString *)fromText indexPath:(NSIndexPath *)indexPath callback:(void(^)(NSString *string))callback
{
    __weak __typeof(&*self)weakSelf = self;
    ZXCustomTextFieldViewController *vc = [[UIStoryboard storyboardWithName:@"School" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXCustomTextFieldViewController"];
    vc.text = fromText;
    vc.title = _titleArray[indexPath.section][indexPath.row];
    vc.placeholder = _titleArray[indexPath.section][indexPath.row];
    vc.textBlock = ^(NSString *text) {
        callback(text);
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
