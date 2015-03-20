//
//  ZXAddParentViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

@interface ZXAddParentViewController : ZXBaseViewController<UITableViewDelegate, UITableViewDataSource ,ABPeoplePickerNavigationControllerDelegate ,UITextFieldDelegate ,UIActionSheetDelegate>
{
    NSString *phoneNum;
    NSString *sex;
    NSString *relation;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , assign) NSInteger gid;
@property (nonatomic , assign) NSInteger csid;
@end
