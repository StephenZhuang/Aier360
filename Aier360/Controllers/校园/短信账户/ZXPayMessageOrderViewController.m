//
//  ZXPayMessageOrderViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/23.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPayMessageOrderViewController.h"
#import "ZXOriderContentTableViewCell.h"
#import "ZXPayTypeTableViewCell.h"
#import "ZXMessageBill.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXPayMessageOrderViewController ()

@end

@implementation ZXPayMessageOrderViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MessageAccount" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXPayMessageOrderViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"在线购买";
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"订单详情";
    } else {
        return @"选择付款方式";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = [UIColor colorWithRed:247 green:245 blue:237];
    [headerView.textLabel setFont:[UIFont systemFontOfSize:13]];
    [headerView.textLabel setTextColor:[UIColor colorWithRed:179/255.0 green:176/255.0 blue:168/255.0 alpha:1.0]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXOriderContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXOriderContentTableViewCell"];
        if (indexPath.row == 0) {
            [cell.titleLabel setText:@"单价"];
            [cell.contentLabel setText:[NSString stringWithFormat:@"%.2f元/条",self.messageCommodity.price]];
            [cell.priceLabel setHidden:YES];
        } else if (indexPath.row == 1) {
            [cell.titleLabel setText:@"购买数量"];
            [cell.contentLabel setText:[NSString stringWithFormat:@"%@条",@(self.num)]];
            [cell.priceLabel setHidden:YES];
        } else {
            [cell.titleLabel setText:@"应付金额"];
            [cell.contentLabel setText:@"元"];
            [cell.priceLabel setText:[NSString stringWithFormat:@"%.2f",self.num * self.messageCommodity.price]];
            [cell.priceLabel setHidden:NO];
        }
        return cell;
    } else {
        ZXPayTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXPayTypeTableViewCell"];
        if (indexPath.row == 0) {
            [cell.iconIamge setImage:[UIImage imageNamed:@"ma_ic_alipay"]];
            [cell.titleLabel setText:@"支付宝支付"];
            [cell.contentLabel setText:@"推荐支付宝用户使用"];
        } else {
            [cell.iconIamge setImage:[UIImage imageNamed:@"ma_ic_weixinpay"]];
            [cell.titleLabel setText:@"微信支付"];
            [cell.contentLabel setText:@"推荐微信用户使用"];
        }
        return cell;
    }
}

- (IBAction)submitOrderAction:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [ZXMessageBill submitOrderWithUid:GLOBAL_UID sid:[ZXUtils sharedInstance].currentSchool.sid num:self.num cid:self.messageCommodity.cid block:^(ZXMessageBill *bill, NSError *error) {
        if (bill) {
            [hud hide:YES];
        } else {
            [hud turnToError:@"订单提交失败，请重试"];
        }
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
