//
//  ZXSensitiveWordsViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/23.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSensitiveWordsViewController.h"
#import "ZXSensitiveWords.h"

@interface ZXSensitiveWordsViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZXSensitiveWordsViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InfoObserver" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = item;
    self.title = @"敏感词管理";
}

- (void)edit:(UIBarButtonItem *)sender
{
    if (self.tableView.editing) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
        self.navigationItem.rightBarButtonItem = item;
    } else {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(edit:)];
        self.navigationItem.rightBarButtonItem = item;
    }
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (void)addFooter{}

- (void)loadData
{
    [ZXSensitiveWords getAllWordsWithSid:[ZXUtils sharedInstance].currentSchool.sid block:^(NSArray *array, NSError *error) {
        [self configureArrayWithNoFooter:array];
    }];
}

- (IBAction)addWord:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加敏感词" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *string = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (string.length > 0) {
            ZXSensitiveWords *word = [[ZXSensitiveWords alloc] init];
            word.word = string;
            [self.dataArray addObject:word];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [ZXSensitiveWords addWordWithSid:[ZXUtils sharedInstance].currentSchool.sid word:string block:^(BOOL success, NSString *errorInfo) {
                
            }];
        }
    }
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXSensitiveWords *word = self.dataArray[indexPath.row];
    [cell.textLabel setText:word.word];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZXSensitiveWords *word = self.dataArray[indexPath.row];
        if (word.swid) {
            [ZXSensitiveWords deleteWordWithSwid:word.swid block:^(BOOL success, NSString *errorInfo) {
                
            }];
        }
        [self.dataArray removeObject:word];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
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
