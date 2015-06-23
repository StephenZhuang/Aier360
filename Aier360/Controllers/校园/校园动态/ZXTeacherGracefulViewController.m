//
//  ZXTeacherGracefulViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherGracefulViewController.h"
#import "ZXTeacherCharisma+ZXclient.h"
#import "ZXTeacherGracefulDetailViewController.h"
#import "ZXTeacherGraceCell.h"
#import "MagicalMacro.h"

@interface ZXTeacherGracefulViewController ()

@end

@implementation ZXTeacherGracefulViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXTeacherGracefulViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"教师风采";
    
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addTeacher)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    CGFloat itemWidth = (SCREEN_WIDTH - 45) / 2;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    layout.itemSize = CGSizeMake(itemWidth, 195);
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    [self.collectionView setCollectionViewLayout:layout animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)addTeacher
{
    [self performSegueWithIdentifier:@"add" sender:nil];
}

- (void)loadData
{
    [ZXTeacherCharisma getTeacherListWithSid:[ZXUtils sharedInstance].currentSchool.sid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

#pragma mark - collectionview delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXTeacherGraceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ZXTeacherCharisma *teacher = [self.dataArray objectAtIndex:indexPath.row];
    [cell.headImageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:teacher.img] placeholderImage:[UIImage imageNamed:@"head_default"]];
    cell.headImageView.layer.cornerRadius = 42.5;
    cell.headImageView.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    [cell.nameLabel setText:teacher.name];
    [cell.infoLabel setText:teacher.desinfo];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detail"]) {
        ZXTeacherGraceCell *cell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        ZXTeacherCharisma *teacher = self.dataArray[indexPath.row];
        ZXTeacherGracefulDetailViewController *vc = segue.destinationViewController;
        vc.teacher = teacher;
    }
}


@end
