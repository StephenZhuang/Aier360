//
//  ZXCardDetailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCardDetailViewController.h"
#import "ZXICCard+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXCardDetailViewController ()
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *numLabel;
@property (nonatomic , weak) IBOutlet UILabel *codeLabel;
@property (nonatomic , weak) IBOutlet UILabel *classLabel;
@property (nonatomic , weak) IBOutlet UILabel *schoolLabel;
@property (nonatomic , weak) IBOutlet UILabel *nameTitleLabel;
@property (nonatomic , weak) IBOutlet UILabel *classTitleLabel;
@property (nonatomic , weak) IBOutlet UIImageView *lossImage;
@end

@implementation ZXCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _cardNum;
    
    [_numLabel setText:[NSString stringWithIntger:_card.icid]];
    [_codeLabel setText:_card.ifoot];
    [_schoolLabel setText:_card.sname];
    if ([ZXUtils sharedInstance].identity == ZXIdentityParent) {
        [_nameTitleLabel setText:@"宝宝姓名："];
        [_classTitleLabel setText:@"所在班级："];
        [_nameLabel setText:_card.name_student];
        [_classLabel setText:_card.cname];
    } else {
        [_nameTitleLabel setText:@"职工姓名："];
        [_classTitleLabel setText:@"职       务："];
        [_nameLabel setText:_card.name_teacher];
        [_classLabel setText:_card.gname];
    }
    
    if (_card.state == 10) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"挂失" style:UIBarButtonItemStylePlain target:self action:@selector(lossReport)];
        self.navigationItem.rightBarButtonItem = item;
        [_lossImage setHidden:YES];
    } else {
        [_lossImage setHidden:NO];
    }
}

- (void)lossReport
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"挂失后该卡将成为一张废卡" message:@"确定要挂失吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //确定
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"提交中" toView:self.view];
        ZXAppStateInfo *appstateinfo = [ZXUtils sharedInstance].currentAppStateInfo;
        [ZXICCard changeICCardStateWithSid:appstateinfo.sid icid:_card.icid state:20 block:^(ZXBaseModel *baseModel ,NSError *error) {
            if (baseModel) {
                if (baseModel.s) {
                    [hud turnToSuccess:@""];
                    [_lossImage setHidden:NO];
                    self.navigationItem.rightBarButtonItem = nil;
                    if (_lossReportBlock) {
                        _lossReportBlock();
                    }
                } else {
                    [hud turnToError:baseModel.error_info];
                }
            } else {
                [hud turnToError:@"提交失败"];
            }
        }];
    }
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
