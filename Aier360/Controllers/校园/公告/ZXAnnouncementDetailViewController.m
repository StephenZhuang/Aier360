//
//  ZXAnnouncementDetailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementDetailViewController.h"
#import "ZXImageCell.h"
#import "MagicalMacro.h"
#import "ZXReadAnnouncementViewController.h"
#import "UIViewController+ZXPhotoBrowser.h"

@interface ZXAnnouncementDetailViewController ()

@end

@implementation ZXAnnouncementDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公告详情";
    [self setup];
    
}

- (void)setup
{
    [_typeLabel setText:(_announcement.type == 1)?@"班级公告":@"学校公告"];
    [_senderLabel setText:_announcement.name_teacher];
    [_titleLabel setText:_announcement.title];
    [_timeLabel setText:_announcement.ctime_str];
    [_readButton setTitle:[NSString stringWithFormat:@"已阅读 %i",_announcement.reading] forState:UIControlStateNormal];
    if (_announcement.type == 1) {
        [_readButton setBackgroundImage:[UIImage imageNamed:@"check_agree"] forState:UIControlStateNormal];
        _readButton.userInteractionEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_announcement.img.length > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_announcement.img.length > 0) {
        if (indexPath.row == 0) {
            NSArray *array = [_announcement.img componentsSeparatedByString:@","];
            return [ZXImageCell heightByImageArray:array];
        }
    }
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize size = CGSizeMake(SCREEN_WIDTH-16,2000);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};    
    CGSize labelsize = [_announcement.message boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return labelsize.height + 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_announcement.img.length > 0) {
        if (indexPath.row == 0) {
            ZXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            __block NSArray *array = [_announcement.img componentsSeparatedByString:@","];
            [cell setImageArray:array];
            cell.imageClickBlock = ^(NSInteger index) {
                [self browseImage:array type:ZXImageTypeFresh index:index];
            };
            return cell;
        }
    }
    ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
    [cell.titleLabel setText:_announcement.message];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"read"]) {
        ZXReadAnnouncementViewController *vc = segue.destinationViewController;
        vc.mid = _announcement.mid;
    }
}


@end
