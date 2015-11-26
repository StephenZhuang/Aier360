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
#import "Order.h"
#import "ZXApiClient.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ZXAlipayMacro.h"
#import "ZXNotificationHelper.h"
#import "WXApi.h"
#import "ZXWeixinSignParams.h"

@interface ZXPayMessageOrderViewController ()
@property (nonatomic , strong) ZXMessageBill *bill;
@property (nonatomic , copy) NSString *prepay_id;
@property (nonatomic , copy) NSString *nonce_str;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinpaySuccess) name:weixnpaySuccessNotification object:nil];
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
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.section == 0) {
        [MBProgressHUD showText:@"请选择支付方式" toView:self.view];
    } else {
        if (indexPath.row == 0) {
            if (self.bill) {
                [self alipay:self.bill];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
                [ZXMessageBill submitOrderWithUid:GLOBAL_UID sid:[ZXUtils sharedInstance].currentSchool.sid num:self.num cid:self.messageCommodity.cid block:^(ZXMessageBill *bill, NSError *error) {
                    if (bill) {
                        [hud hide:YES];
                        self.bill = bill;
                        [self alipay:self.bill];
                    } else {
                        [hud turnToError:@"订单提交失败，请重试"];
                    }
                }];
            }
        } else {
            if (self.prepay_id && self.nonce_str) {
                [self weixinpay];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
                [ZXMessageBill getPrepayWithUid:GLOBAL_UID sid:[ZXUtils sharedInstance].currentSchool.sid num:self.num cid:self.messageCommodity.cid ip:@"196.168.1.1" block:^(NSString *prepay_id, NSString *nonce_str, NSError *error) {
                    self.prepay_id = prepay_id;
                    self.nonce_str = nonce_str;
                    if (self.prepay_id && self.nonce_str) {
                        [hud hide:YES];
                        [self weixinpay];
                    } else {
                        [hud turnToError:@"订单提交失败，请重试"];
                    }
                }];
            }
        }
    }
    
}

- (void)alipay:(ZXMessageBill *)bill
{
    Order *order = [[Order alloc] init];
    order.partner = Alipay_Partner;
    order.seller = Alipay_Seller;
    order.tradeNO = bill.billno; //订单ID(由商家□自□行制定)
    order.amount = [NSString stringWithFormat:@"%.2f",bill.money]; //商 品价格
    order.notifyURL = [NSURL URLWithString:@"payjs/pay_RSANotifyReceiver.shtml" relativeToURL:[ZXApiClient sharedClient].baseURL].absoluteString; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.productName = @"购买短信";
    order.productDescription = self.messageCommodity.descript;
    order.showUrl = @"m.alipay.com";
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types NSString *appScheme = @"alisdkdemo";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order des]; NSLog(@"orderSpec = %@",orderSpec);
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    
    id<DataSigner> signer = CreateRSADataSigner(Alipay_PrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:Alipay_AppScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            OrderResult *result = [OrderResult objectWithKeyValues:resultDic];
            if (result.resultStatus == 9000) {
                [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
                [[NSNotificationCenter defaultCenter] postNotificationName:paySuccessNotification object:nil];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
            } else {
                [result handleStatus:^(NSString *string) {
                    [MBProgressHUD showText:string toView:self.view];
                }];
            }
        }];
    }
}

- (void)weixinpay
{
    ZXWeixinSignParams *signParams = [[ZXWeixinSignParams alloc] initWithPrepayid:self.prepay_id noncestr:self.nonce_str];
    
    //调起微信支付
    PayReq *req = [[PayReq alloc] init];
    req.openID = signParams.appid;
    req.partnerId = signParams.partnerid;
    req.prepayId = signParams.prepayid;
    req.nonceStr = signParams.noncestr;
    req.timeStamp = signParams.timestamp.intValue;
    req.package = signParams.package;
    req.sign = [signParams sign];
    
    [WXApi sendReq:req];
}

- (void)weixinpaySuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:paySuccessNotification object:nil];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:weixnpaySuccessNotification object:nil];
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
