//
//  ZXFoodListViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFoodListViewController.h"
#import "ZXDailyFood+ZXclient.h"
#import "ZXFoodTitleView.h"
#import "ZXFoodImageCell.h"
#import "ZXFoodImagePickerViewController.h"
#import "ZXZipHelper.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXAddFoodViewController.h"
#import "ZXUpDownLoadManager.h"
#import "ZXFoodClassImageViewController.h"

@interface ZXFoodListViewController ()
{
    NSInteger dailyFoodState;
}

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *topAlign;
@property (nonatomic , weak) IBOutlet UIButton *releasedButton;
@property (nonatomic , weak) IBOutlet UIButton *unreleasedButton;
@property (nonatomic , weak) IBOutlet UIView *slidView;
@end

@implementation ZXFoodListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"每日餐饮";
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXFoodTitleView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"titleView"];
    
    if ([ZXUtils sharedInstance].identity == ZXIdentitySchoolMaster) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_release"] style:UIBarButtonItemStyleBordered target:self action:@selector(addFood)];
        self.navigationItem.rightBarButtonItem = item;
    } else {
        _topAlign.constant = -44;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
    
    dailyFoodState = 1;
}

- (void)addFood
{
    [self performSegueWithIdentifier:@"add" sender:nil];
}

- (IBAction)editFood:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"edit" sender:sender];
}

- (IBAction)deleteFood:(UIButton *)sender
{
    ZXDailyFood *food = self.dataArray[sender.tag];
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXDailyFood deleteFoodWithDfid:food.dfid sid:appStateInfo.sid block:^(BOOL success, NSString *errorInfo) {
        if (!success) {
            [MBProgressHUD showText:ZXFailedString toView:self.view];
        }
    }];
    [self.dataArray removeObject:food];
    [self.tableView reloadData];
}

- (IBAction)lookImage:(UIButton *)sender
{
    ZXDailyFood *food = self.dataArray[sender.tag];
    ZXFoodClassImageViewController *vc = [ZXFoodClassImageViewController viewControllerFromStoryboard];
    vc.dfid = food.dfid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)releaseAction:(UIButton *)sender
{
    if (!sender.selected) {
        sender.selected = YES;
        _unreleasedButton.selected = NO;
        dailyFoodState = sender.tag;
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView headerBeginRefreshing];
    }
}

- (IBAction)unreleaseAction:(UIButton *)sender
{
    if (!sender.selected) {
        sender.selected = YES;
        _releasedButton.selected = NO;
        dailyFoodState = sender.tag;
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView headerBeginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (IBAction)foodStateAction:(UIButton *)sender
{
    dailyFoodState = sender.tag;
    [self.tableView headerBeginRefreshing];
}

- (void)loadData
{
    //TODO: 学校管理员以外的人也能看到，接口要改
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXDailyFood getFoodListWithSid:appStateInfo.sid cid:appStateInfo.cid dailyFoodState:dailyFoodState page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        
        if (array) {
            if (page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < pageCount) {
                hasMore = NO;
                [self.tableView setFooterHidden:YES];
            }
        } else {
            hasMore = NO;
            [self.tableView reloadData];
            [self.tableView setFooterHidden:YES];
        }
        if (page == 1) {
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZXDailyFood *food = self.dataArray[section];
    //TODO: 这里的分割方式有很大的问题，容易造成低级bug，已经提过，不改，以后出了问题可以甩锅
    //分割方法 餐点：食物\\n餐点：食物
    if ([food.content hasSuffix:@"\\n"]) {
        food.content = [food.content substringToIndex:food.content.length - 2];
    }
    NSArray *arr = [food.content componentsSeparatedByString:@"\\n"];
    if ([ZXUtils sharedInstance].identity == ZXIdentitySchoolMaster) {
        return arr.count;
    } else if ([ZXUtils sharedInstance].identity == ZXIdentityClassMaster) {
        if (food.img.length > 0 || [self isToday:food.ddate]) {
            return arr.count + 1;
        }
    } else {
        if (food.img.length > 0) {
            return arr.count + 1;
        }
    }
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDailyFood *food = self.dataArray[indexPath.section];
    if ([ZXUtils sharedInstance].identity == ZXIdentityClassMaster) {
        if (food.img.length > 0 || [self isToday:food.ddate]) {
            if (indexPath.row == 0) {
                return 135;
            }
        }
    } else if ([ZXUtils sharedInstance].identity == ZXIdentitySchoolMaster) {
        return 64;
    } else {
        if (food.img.length > 0) {
            if (indexPath.row == 0) {
                return 135;
            }
        }
    }
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZXFoodTitleView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"titleView"];
    if (view == nil) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"ZXFoodTitleView" owner:self options:nil] firstObject];
    }
    ZXDailyFood *food = self.dataArray[section];
    [view.timeButton setTitle:food.ddate forState:UIControlStateNormal];
    if ([ZXUtils sharedInstance].identity == ZXIdentitySchoolMaster) {
        [view.editButton setHidden:(dailyFoodState == 1)];
        [view.releasedImage setHidden:(dailyFoodState == 0)];
        [view.imageButton setHidden:!(dailyFoodState == 1 && food.hasImg)];
        [view.deleteButton setHidden:(dailyFoodState == 1)];
        view.editButton.tag = section;
        view.deleteButton.tag = section;
        view.imageButton.tag = section;
    } else {
        [view.editButton setHidden:YES];
        [view.releasedImage setHidden:YES];
        [view.deleteButton setHidden:YES];
        [view.imageButton setHidden:YES];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([ZXUtils sharedInstance].identity == ZXIdentitySchoolMaster) {
        return [self configureTableView:tableView SchoolMasterCell:indexPath];
    } else {
        return [self configureTableView:tableView ClassMasterCell:indexPath];
    }
}

- (UITableViewCell *)configureTableView:(UITableView *)tableView SchoolMasterCell:(NSIndexPath *)indexPath
{
    ZXDailyFood *food = self.dataArray[indexPath.section];
    NSArray *arr = [food.content componentsSeparatedByString:@"\\n"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
    NSArray *array = [arr[indexPath.row] componentsSeparatedByString:@"："];
    [cell.textLabel setText:[array firstObject]];
    if (array.count > 1) {
        [cell.detailTextLabel setText:array[1]];
    }
    return cell;
}

- (UITableViewCell *)configureTableView:(UITableView *)tableView ClassMasterCell:(NSIndexPath *)indexPath
{
    ZXDailyFood *food = self.dataArray[indexPath.section];
    NSArray *arr = [food.content componentsSeparatedByString:@"\\n"];
    if (food.img.length > 0 || ([self isToday:food.ddate] && CURRENT_IDENTITY == ZXIdentityClassMaster)) {
        if (indexPath.row == 0) {
            ZXFoodImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"picCell"];
            if (food.img.length > 0) {
                NSArray *imgArr = [food.img componentsSeparatedByString:@","];
                NSMutableArray *imageUrlArr = [[NSMutableArray alloc] init];
                for (NSString *img in imgArr) {
                    [imageUrlArr addObject:[ZXImageUrlHelper imageUrlForEat:img]];
                }
                [cell.logoImage sd_setImageWithURL:imageUrlArr[0]];
                cell.logoImage.layer.contentsGravity = kCAGravityResizeAspectFill;
                cell.logoImage.clipsToBounds = YES;
                [cell.numView setHidden:NO];
                [cell.numLabel setText:[NSString stringWithFormat:@"共%i张",imageUrlArr.count]];
            } else {
                [cell.numView setHidden:YES];
                [cell.logoImage setImage:[UIImage imageNamed:@"food_picadd"]];
            }
            
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
            NSArray *array = [arr[indexPath.row - 1] componentsSeparatedByString:@"："];
            [cell.textLabel setText:[array firstObject]];
            if (array.count > 1) {
                [cell.detailTextLabel setText:array[1]];
            }
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
        NSArray *array = [arr[indexPath.row] componentsSeparatedByString:@"："];
        [cell.textLabel setText:[array firstObject]];
        if (array.count > 1) {
            [cell.detailTextLabel setText:array[1]];
        }
        return cell;
    }
}

- (BOOL)isToday:(NSString *)dayString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate new];
    NSString *today = [formatter stringFromDate:date];
    return [dayString isEqualToString:today];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDailyFood *food = self.dataArray[indexPath.section];
    if (!([ZXUtils sharedInstance].identity == ZXIdentitySchoolMaster)) {
        if (indexPath.row == 0) {
            if (food.img.length > 0) {
                NSMutableArray *photos = [[NSMutableArray alloc] init];
                NSMutableArray *thumbs = [[NSMutableArray alloc] init];

                NSArray*arr = [food.img componentsSeparatedByString:@","];
                for (NSString *img in arr) {
                    [photos addObject:[MWPhoto photoWithURL:[ZXImageUrlHelper imageUrlForEat:img]]];
                    [thumbs addObject:[MWPhoto photoWithURL:[ZXImageUrlHelper imageUrlForEat:img]]];
                }
                self.photos = photos;
                self.thumbs = thumbs;
                BOOL displayActionButton = NO;
                BOOL displaySelectionButtons = NO;
                BOOL displayNavArrows = NO;
                BOOL enableGrid = NO;
                BOOL startOnGrid = NO;
                MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
                browser.displayActionButton = displayActionButton;
                browser.displayNavArrows = displayNavArrows;
                browser.displaySelectionButtons = displaySelectionButtons;
                browser.alwaysShowControls = displaySelectionButtons;
                browser.zoomPhotosToFill = YES;
                browser.enableGrid = enableGrid;
                browser.startOnGrid = startOnGrid;
                browser.enableSwipeToDismiss = YES;
                [browser setCurrentPhotoIndex:0];
                [self.navigationController pushViewController:browser animated:YES];
            } else if ([self isToday:food.ddate] && [ZXUtils sharedInstance].identity == ZXIdentityClassMaster) {
                [self showPicker:indexPath.section];
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 64; //sectionHeaderHeight
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPicker:(NSInteger)section
{
    ZXFoodImagePickerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZXFoodImagePickerViewController"];
    [vc showOnViewControlelr:self];
    __weak __typeof(&*self)weakSelf = self;
    vc.pickBlock = ^(NSArray *array) {
        NSMutableArray *imageUrlArray = [[NSMutableArray alloc] init];
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"请稍候" toView:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
            for (UIImage *image in array) {
                [imageUrlArray addObject:[ZXZipHelper saveImage:image withName:[NSString stringWithFormat:@"image%i",[array indexOfObject:image]]]];
            }
            NSString *filePath = [ZXZipHelper archiveImagesWithImageUrls:imageUrlArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面

                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:@"newzipfile.zip" forKey:@"photoName"];
                [parameters setObject:[NSNumber numberWithInteger:[ZXUtils sharedInstance].currentAppStateInfo.cid] forKey:@"cid"];
                ZXDailyFood *food = self.dataArray[section];
                [parameters setObject:[NSNumber numberWithInteger:food.dfid] forKey:@"dfid"];
                NSURL *url = [NSURL URLWithString:@"nxadminjs/image_uploadDailyfoodImgApp.shtml?" relativeToURL:[ZXApiClient sharedClient].baseURL];
                
                //上传宝宝用餐图片
                [ZXUpDownLoadManager uploadTaskWithUrl:url.absoluteString path:filePath parameters:parameters progress:nil name:@"file" fileName:@"newzipfile.zip" mimeType:@"application/octet-stream" completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
                    if (error) {
                        [hud turnToError:@"提交失败"];
                    } else {
                        [hud turnToSuccess:@"发布成功"];
                        if (responseObject != nil) {
                            NSString *headimg = [responseObject objectForKey:@"headimg"];
                            [food setImg:headimg];
                            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
                        }
                    }
                }];
            });
        });
    };
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;
    if ([segue.identifier isEqualToString:@"edit"]) {
        UIButton *button = sender;
        ZXDailyFood *food = self.dataArray[button.tag];
        
        ZXAddFoodViewController *vc = segue.destinationViewController;
        vc.addSuccessBlock = ^(void) {
            [weakSelf.tableView headerBeginRefreshing];
        };
        vc.food = food;
    } else if ([segue.identifier isEqualToString:@"add"]) {
        ZXAddFoodViewController *vc = segue.destinationViewController;
        vc.addSuccessBlock = ^(void) {
            [weakSelf.tableView headerBeginRefreshing];
        };
    }
}
@end
