//
//  ZXIndustryViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/28.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXIndustryViewController.h"

@interface ZXIndustryViewController ()

@end

@implementation ZXIndustryViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXIndustryViewController"];
}

#pragma mark- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑职业";
    [self.tableView setSeparatorColor:[UIColor colorWithRed:237/255.0 green:235/255.0 blue:229/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark- tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.industryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *industry = [self.industryArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:industry];
    NSString *imageName = [industry stringByReplacingOccurrencesOfString:@"/" withString:@":"];
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *industry = [self.industryArray objectAtIndex:indexPath.row];
    !_SelectIndustryBlock?:_SelectIndustryBlock(industry);
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- getters and setters
- (NSArray *)industryArray
{
    if (!_industryArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Industry" ofType:@"plist"];
        _industryArray = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _industryArray;
}

@end
