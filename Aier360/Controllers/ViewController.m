//
//  ViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "ViewController.h"
#import "ZXAccount+ZXclient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginAction:(id)sender
{
    [ZXAccount loginWithAccount:@"18001508524" pwd:@"123456" block:^(ZXAccount *account ,NSError *error) {
        NSLog(@"=============");
        ZXUser *user = account.user;
        NSLog(@"%@",user);
//        NSLog(@"%@",account);
        if (account.s) {
            NSLog(@"成功 %i",account.s);
        } else {
            NSLog(@"失败 %i",account.s);
        }
        NSLog(@"=============");
    }];
    
//    [[ZXApiClient sharedClient] GET:@"http://192.168.20.19:8080/aier360/testvali.jpg?20" parameters:nil success:nil failure:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
