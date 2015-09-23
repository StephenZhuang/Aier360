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

@interface ZXReleaseSchoolDynamicViewController ()
@property (nonatomic , assign) NSInteger selectedIndex;
@property (nonatomic , strong) NSMutableArray *contents;
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
    [ZXClass getReleaseClassListWithSid:[ZXUtils sharedInstance].currentSchool.sid uid:GLOBAL_UID block:^(NSArray *array, NSError *error) {
        [self.dataArray addObjectsFromArray:array];
        for (ZXClass *class in array) {
            [self.contents addObject:class.cname];
        }
        self.selectedIndex = 0;
        [self.tableView reloadData];
    }];
}

- (void)releaseAction
{
    [self.view endEditing:YES];
    NSString *content = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0 || content.length > self.maxLetter) {
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
            ZXClass *class = [self.dataArray objectAtIndex:_selectedIndex];
            _cid = class.cid;
            
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
    if (self.contents.count > 0) {
        [cell.hasNewLabel setText:self.contents[self.selectedIndex]];
    }
}

- (void)selectCellWithIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(&*self)weakSelf = self;
    ZXPopPicker *popPicker = [[ZXPopPicker alloc] initWithTitle:@"动态类型" contents:self.contents];
    popPicker.ZXPopPickerBlock = ^(NSInteger selectedIndex) {
        weakSelf.selectedIndex = selectedIndex;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController.view addSubview:popPicker];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark- setters and getters

- (NSMutableArray *)contents
{
    if (!_contents) {
        _contents = [[NSMutableArray alloc] init];
    }
    return _contents;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
