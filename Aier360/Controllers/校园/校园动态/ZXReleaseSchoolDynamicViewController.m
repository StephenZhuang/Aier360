//
//  ZXReleaseSchoolDynamicViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/25.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXReleaseSchoolDynamicViewController.h"
#import "ZXMenuCell.h"
#import "ZXPopPicker.h"
#import "ZXFile.h"
#import "ZXZipHelper.h"
#import "ZXUpDownLoadManager.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXManagedUser.h"
#import "ZXClass+ZXclient.h"
#import "ZXSquareLabel+CoreDataProperties.h"
#import "ZXSelectDynamicTypeViewController.h"

@interface ZXReleaseSchoolDynamicViewController ()
//@property (nonatomic , assign) NSInteger selectedIndex;
//@property (nonatomic , strong) NSMutableArray *contents;
@property (nonatomic , strong) ZXClass *zxclass;
@property (nonatomic , assign) long cid;
@end

@implementation ZXReleaseSchoolDynamicViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXReleaseSchoolDynamicViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)releaseAction
{
    [self.view endEditing:YES];
    NSString *content = self.contentTextView.text;
    for (ZXSquareLabel *squareLabel in self.squareLabelArray) {
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"#%@#",squareLabel.name] withString:@""];
    }
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0 || content.length > self.maxLetter) {
        return;
    }
    
    if (!self.zxclass) {
        [MBProgressHUD showText:@"请选择动态类型" toView:self.view];
        return;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (UIImage *image in self.imageArray) {
        ZXFile *file = [[ZXFile alloc] init];
        NSInteger index = [self.imageArray indexOfObject:image];
        NSString *name = [NSString stringWithFormat:@"image%@.jpg",@(index)];
        file.path = [ZXZipHelper saveImage:image withName:name];
        file.name = @"file";
        file.fileName = name;
        [array addObject:file];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"发布中" toView:self.view];
    
    [ZXUpDownLoadManager uploadImages:array type:1 completion:^(BOOL success, NSString *imagesString) {
        if (success) {
            _cid = self.zxclass.cid;
            
            NSMutableArray *oslidArray = [[NSMutableArray alloc] init];
            for (ZXSquareLabel *squareLabel in self.squareLabelArray) {
                [oslidArray addObject:[NSString stringWithFormat:@"%@",@(squareLabel.id)]];
            }
            NSString *oslids = [oslidArray componentsJoinedByString:@","];
            [ZXPersonalDynamic addSchoolDynamicWithUid:GLOBAL_UID content:content img:imagesString relativeid:0 sid:[ZXUtils sharedInstance].currentSchool.sid cid:_cid oslids:oslids address:self.address lat:self.lat lng:self.lng block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [hud turnToSuccess:@""];
                    [super releaseAction];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [hud turnToError:errorInfo];
                }
            }];
        } else {
            [hud turnToError:imagesString];
        }
    }];
}


- (void)confiureCell:(ZXMenuCell *)cell
{
    [cell.titleLabel setText:@"动态类型"];
    if (self.zxclass) {
        [cell.hasNewLabel setText:self.zxclass.cname];
    } else {
        [cell.hasNewLabel setText:@"请选择"];
    }
    cell.hasNewLabel.layer.borderColor = [UIColor colorWithRed:232/255.0 green:229/255.0 blue:226/255.0 alpha:1.0].CGColor;
    cell.hasNewLabel.layer.borderWidth = 1;
}

- (void)selectCellWithIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(&*self)weakSelf = self;
    ZXSelectDynamicTypeViewController *vc = [ZXSelectDynamicTypeViewController viewControllerFromStoryboard];
    vc.selectTypeBlock = ^(ZXClass *selectedClass) {
        weakSelf.zxclass = selectedClass;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark- setters and getters

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
