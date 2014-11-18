//
//  ZXCustomSelectViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCustomSelectViewController.h"
#import "ZXClass.h"
#import "ZXPosition.h"

@implementation ZXCustomSelectViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)addHeader{}
- (void)addFooter{}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    id object = self.dataArray[indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        [cell.textLabel setText:object];
    } else if ([object isKindOfClass:[ZXClass class]]) {
        ZXClass *zxclass = (ZXClass *)object;
        [cell.textLabel setText:zxclass.cname];
    } else if ([object isKindOfClass:[ZXPosition class]]) {
        ZXPosition *positon = (ZXPosition *)object;
        [cell.textLabel setText:positon.name];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = self.dataArray[indexPath.row];
    if (_objectBlock) {
        _objectBlock(object);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
