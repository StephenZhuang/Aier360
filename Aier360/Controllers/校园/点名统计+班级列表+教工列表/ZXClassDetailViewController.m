//
//  ZXClassDetailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClassDetailViewController.h"
#import "ZXClass+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXClassDetailViewController ()
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *numLabel;
@property (nonatomic , weak) IBOutlet UILabel *masterLabel;
@property (nonatomic , weak) IBOutlet UILabel *assistLabel;
@property (nonatomic , weak) IBOutlet UILabel *careLabel;
@end

@implementation ZXClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)loadData
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"加载中" toView:self.view];
    [ZXClass classDetailWithCid:_cid block:^(ZXClassDetail *classDetail, NSError *error) {
        if (classDetail) {
            [hud turnToSuccess:@""];
            self.title = classDetail.cname;
            [_nameLabel setText:classDetail.cname];
            [_numLabel setText:[NSString stringWithIntger:classDetail.num]];
            [_masterLabel setText:classDetail.adminName];
            [_assistLabel setText:classDetail.assistTeacherName];
            [_careLabel setText:classDetail.childCarename];
             
        } else {
            [hud turnToError:@"加载失败"];
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
