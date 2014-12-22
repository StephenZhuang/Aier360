//
//  ZXHomeworkViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomeworkViewController.h"
#import "ZXHomework+ZXclient.h"
#import "ZXHomeworkDetailViewController.h"
#import "ZXAddHomeworkViewController.h"
#import "ZXImageCell.h"
#import "ZXHomeworkCell.h"
#import "ZXHomeworkToolCell.h"
#import "ZXClass+ZXclient.h"
#import "ZXClassPickerCell.h"
#import "UIViewController+ZXPhotoBrowser.h"

@interface ZXHomeworkViewController ()

@end

@implementation ZXHomeworkViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Homework" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXHomeworkViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster) {
        cid = 0;
        dropTitle = [[[NSBundle mainBundle] loadNibNamed:@"ZXDropTitleView" owner:self options:nil] firstObject];
        [dropTitle setTitle:@"全部班级" forState:UIControlStateNormal];
        [dropTitle addTarget:self action:@selector(showClassPicker:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setTitleView:dropTitle];
        
        _classArray = [[NSMutableArray alloc] init];
        ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
        [ZXClass getClassListWithSid:appStateInfo.sid block:^(NSArray *array, NSError *error) {
            [_classArray addObjectsFromArray:array];
            ZXClass *class = [[ZXClass alloc] init];
            class.cid = 0;
            class.cname = @"全部班级";
            [_classArray insertObject:class atIndex:0];
            
            [_collectionView reloadData];
            if (_classArray.count > 0) {
                self.currentClass = [_classArray firstObject];
                [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                
                [self.tableView headerBeginRefreshing];
            }
        }];
    } else {
        self.title = @"亲子任务";
        cid = [ZXUtils sharedInstance].currentAppStateInfo.cid;
        [self.tableView headerBeginRefreshing];
    }
    
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"school_message"] style:UIBarButtonItemStyleBordered target:self action:@selector(goToMessage)];
    if (CURRENT_IDENTITY == ZXIdentityClassMaster) {
        UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_release"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreAction)];
        self.navigationItem.rightBarButtonItems = @[more,message];
    } else {
        self.navigationItem.rightBarButtonItem = message;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)goToMessage
{
    [self performSegueWithIdentifier:@"message" sender:nil];
}

- (void)moreAction
{
    ZXAddHomeworkViewController *vc = [ZXAddHomeworkViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addHeader
{
    [self.tableView addHeaderWithCallback:^(void) {
        if (!hasMore) {
            [self.tableView setFooterHidden:NO];
        }
        page = 1;
        hasMore = YES;
        [self loadData];
    }];
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    if (cid == 0) {
        [ZXHomework getAllClassHomeworkListWithUid:GLOBAL_UID sid:appStateInfo.sid page:page page_size:pageCount block:^(NSArray *array, NSError *error) {
            [self configureArray:array];
        }];
    } else {
        [ZXHomework getClassHomeworkListWithUid:GLOBAL_UID sid:appStateInfo.sid cid:cid page:page page_size:pageCount block:^(NSArray *array, NSError *error) {
            [self configureArray:array];
        }];
    }
}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZXHomework *homework = self.dataArray[section];
    if (homework.img.length > 0) {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXHomework *homework = [self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        return [ZXHomeworkCell heightByText:homework.content];
    }
    else if (indexPath.row == 1 && homework.img.length > 0) {
            NSArray *arr = [homework.img componentsSeparatedByString:@","];
            return [ZXImageCell heightByImageArray:arr];
    } else {
        //工具栏
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXHomework *homework = [self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        ZXHomeworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXHomeworkCell"];
        [cell configureUIWithHomework:homework indexPath:indexPath];
        if (CURRENT_IDENTITY == ZXIdentityClassMaster) {
            [cell.deleteButton setHidden:NO];
        } else {
            [cell.deleteButton setHidden:YES];
            [cell removeDeleteButton];
        }
        return cell;
    }
    else if (indexPath.row == 1 && homework.img.length > 0) {
        __block NSArray *arr = [homework.img componentsSeparatedByString:@","];
        ZXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImageCell"];
        cell.type = 2;
        [cell setImageArray:arr];
        cell.imageClickBlock = ^(NSInteger index) {
            [self browseImage:arr type:ZXImageTypeHomework index:index];
        };
        return cell;
    } else {
        //工具栏
        ZXHomeworkToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXHomeworkToolCell"];
        [cell configureUIWithHomework:homework indexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXHomework *homework = [self.dataArray objectAtIndex:indexPath.section];
    ZXHomeworkDetailViewController *vc = [ZXHomeworkDetailViewController viewControllerFromStoryboard];
    vc.homework = homework;
    vc.deleteBlock = ^(void) {
        [self.tableView headerBeginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)deleteAction:(UIButton *)sender
{
    ZXHomework *homework = self.dataArray[sender.tag];
    
    [ZXHomework deleteHomeworkWithHid:homework.hid block:^(BOOL success, NSString *errorInfo) {
        if (!success) {
            [MBProgressHUD showText:ZXFailedString toView:self.view];
        }
    }];
    
    [self.dataArray removeObject:homework];
    [self.tableView reloadData];
}

#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _classArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXClassPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXClassPickerCell" forIndexPath:indexPath];
    ZXClass *zxclass = self.classArray[indexPath.row];
    [cell.textLabel setText:zxclass.cname];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXClass *zxclass = self.classArray[indexPath.row];
    if (![_currentClass isEqual:zxclass]) {
        self.currentClass = zxclass;
        cid = zxclass.cid;
        [dropTitle setTitle:zxclass.cname forState:UIControlStateNormal];
        [self.tableView headerBeginRefreshing];
    }
    [self hideClassPicker];
}

- (IBAction)showClassPicker:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        [self showClassPicker];
    } else {
        [self hideClassPicker];
    }
}

- (void)showClassPicker
{
    [self addMask];
    [UIView animateWithDuration:0.25 animations:^(void) {
        _collectionView.transform = CGAffineTransformTranslate(_collectionView.transform, 0, CGRectGetHeight(_collectionView.frame));
    }];
}

- (void)addMask
{
    mask = [[UIView alloc] initWithFrame:self.view.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.3;
    [self.view insertSubview:mask belowSubview:_collectionView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideClassPicker)];
    [mask addGestureRecognizer:tap];
}

- (void)hideClassPicker
{
    [UIView animateWithDuration:0.25 animations:^(void) {
        _collectionView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        [mask removeFromSuperview];
        [dropTitle setSelected:NO];
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
