//
//  ZXBuyMessageViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/18.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBuyMessageViewController.h"
#import "ZXPayMessageOrderViewController.h"
#import "ZXMessageCommodity.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXBuyMessageViewController ()
@property (nonatomic , strong) ZXMessageCommodity *messageCommodity;
@end

@implementation ZXBuyMessageViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MessageAccount" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXBuyMessageViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"在线购买";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [ZXMessageCommodity getMessageCommodityWithBlock:^(ZXMessageCommodity *messageCommodity, NSError *error) {
        [hud hide:YES];
        self.messageCommodity = messageCommodity;
        [self.priceLabel setText:[NSString stringWithFormat:@"%.2f元/条",self.messageCommodity.price]];
    }];
}

#pragma mark - textfield delegate
- (void)textFieldDidChange:(NSNotification *)notification
{
    NSInteger num = [self.textField.text integerValue];
    NSString *price = [NSString stringWithFormat:@"%.2f",self.messageCommodity.price * num];
    [self.totalPriceLabel setText:price];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 6) {
        if ([string isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)submitOrderAction:(id)sender
{
    [self.view endEditing:YES];
    NSInteger num = [self.textField.text integerValue];
    if (!self.messageCommodity) {
        [MBProgressHUD showText:@"网络连接失败，请返回重试" toView:self.view];
        return;
    }
    if (num <= 0) {
        return;
    }
    ZXPayMessageOrderViewController *vc = [ZXPayMessageOrderViewController viewControllerFromStoryboard];
    vc.messageCommodity = self.messageCommodity;
    vc.num = num;
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
