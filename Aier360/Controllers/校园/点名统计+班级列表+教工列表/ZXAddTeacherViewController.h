//
//  ZXAddTeacherViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/13.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

@interface ZXAddTeacherViewController : ZXBaseViewController<UITableViewDelegate, UITableViewDataSource ,ABPeoplePickerNavigationControllerDelegate ,UITextFieldDelegate ,UIActionSheetDelegate>
{
    NSString *name;
    NSString *phoneNum;
    NSString *classes;
    NSString *classids;
    NSString *sex;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , assign) NSInteger gid;
@end
