//
//  ZXJoinTeacherViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXJoinTeacherViewController.h"
#import "ZXCustomSelectViewController.h"
#import "ZXCustomTextFieldViewController.h"
#import "BaseModel+ZXJoinSchool.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXJoinTeacherViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"加入学校(2/2)";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.dataArray addObjectsFromArray:@[@"",@"",@""]];
    _titleArray = @[@"你的姓名",@"职务",@"所在班级"];
    _placeholderArray = @[@"请填写你的姓名",@"请选择你的职务",@"请选择你要加入的班级"];
    [self.tableView reloadData];
    
    [ZXClass getClassListWithSid:_school.sid block:^(NSArray *array ,NSError *error) {
        _classArray = [[NSMutableArray alloc] init];
        [_classArray addObjectsFromArray:array];
    }];
    
    [ZXPosition getPositionListWithSid:_school.sid block:^(NSArray *array ,NSError *error) {
        _positionArray = [[NSMutableArray alloc] init];
        [_positionArray addObjectsFromArray:array];
    }];
}

- (void)addHeader{}
- (void)addFooter{}

- (void)submit
{
    NSString *name = self.dataArray[0];
    if (name.length == 0 || _selectedPosition == nil) {
        [MBProgressHUD showText:@"请将资料填写完整" toView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"提交中" toView:self.view];
    [ZXBaseModel teacherJoinSchoolWithUid:[ZXUtils sharedInstance].user.uid schoolId:_school.sid gid:_selectedPosition.gid teachername:name strcid:_selectedClass?[NSString stringWithFormat:@"%li",_selectedClass.cid]:@"" block:^(ZXBaseModel *baseModel,NSError *error) {
        if (baseModel) {
            if (baseModel.s) {
                [hud turnToSuccess:@"提交成功，等待审核"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [hud turnToError:baseModel.error_info];
            }
        } else {
            [hud hide:YES];
        }
    }];
}

#pragma -mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"请填写你的资料";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //    view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:132 green:132 blue:134]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:_titleArray[indexPath.row]];
    [self setText:cell.detailTextLabel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self getEditedText:self.dataArray[indexPath.row] indexPath:indexPath callback:^(NSString *text) {
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:text];
        }];
    } else if (indexPath.row == 1) {
        [self getEditSelect:_positionArray indexPath:indexPath callback:^(id object) {
            ZXPosition *position = (ZXPosition *)object;
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:position.name];
            _selectedPosition = position;
        }];
    } else if (indexPath.row == 2) {
        [self getEditSelect:_classArray indexPath:indexPath callback:^(id object) {
            ZXClass *zxclass = (ZXClass *)object;
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:zxclass.cname];
            _selectedClass = zxclass;
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setText:(UILabel *)label indexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.dataArray[indexPath.row];
    if (text.length > 0) {
        [label setTextColor:[UIColor blackColor]];
    } else {
        text = _placeholderArray[indexPath.row];
        [label setTextColor:[UIColor colorWithRed:132 green:132 blue:134]];
    }
    [label setText:text];
}

- (void)getEditedText:(NSString *)fromText indexPath:(NSIndexPath *)indexPath callback:(void(^)(NSString *string))callback
{
    ZXCustomTextFieldViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZXCustomTextFieldViewController"];
    vc.text = fromText;
    vc.title = _placeholderArray[indexPath.row];
    vc.placeholder = _placeholderArray[indexPath.row];
    vc.textBlock = ^(NSString *text) {
        callback(text);
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getEditSelect:(NSMutableArray *)fromArray indexPath:(NSIndexPath *)indexPath callback:(void(^)(id object))callback
{
    ZXCustomSelectViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZXCustomSelectViewController"];
    vc.title = _placeholderArray[indexPath.row];
    vc.dataArray = fromArray;
    vc.objectBlock = ^(id object) {
        callback(object);
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
@end
