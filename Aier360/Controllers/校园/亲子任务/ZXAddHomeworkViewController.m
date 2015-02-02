//
//  ZXAddHomeworkViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddHomeworkViewController.h"
#import "ZXImagePickCell.h"
#import "ZXZipHelper.h"
#import "ZXUpDownLoadManager.h"
#import "ZXHomework+ZXclient.h"
#import "ZXAnnouncement+ZXclient.h"

@interface ZXAddHomeworkViewController ()
{
    MBProgressHUD *hud;
    NSInteger _people;
    NSInteger _mesLeft;
    NSInteger _currentCount;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , weak) IBOutlet UITextField *titleTextField;
@property (nonatomic , weak) IBOutlet UIPlaceHolderTextView *contentTextView;
@property (nonatomic , weak) IBOutlet UILabel *letterNumLabel;

@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic , strong) NSMutableArray *imageUrlArray;
@property (nonatomic , weak) IBOutlet UIButton *smsButton;
@property (nonatomic , weak) IBOutlet UILabel *tipLabel;
@end

@implementation ZXAddHomeworkViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Homework" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXAddHomeworkViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布任务";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    _imageArray = [[NSMutableArray alloc] init];
    _imageUrlArray = [[NSMutableArray alloc] init];
    _currentCount = 0;
    
    [_contentTextView setPlaceholder:@"发布内容(必填)"];

    ZXAppStateInfo *appstateinfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXAnnouncement getSmsCountWithSid:appstateinfo.sid cid:appstateinfo.cid sendType:3 block:^(NSInteger totalMessage , NSInteger mesCount, NSError *error) {
        _people = totalMessage;
        _mesLeft = mesCount;
        [self tipLabelChangeText:totalMessage mesCount:mesCount];
    }];
}

- (void)tipLabelChangeText:(NSInteger)totalMessage mesCount:(NSInteger)mesCount
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"同时发送短信" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor],   NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(剩余短信%i条,本次需消耗%i条)",mesCount ,totalMessage] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:132 green:132 blue:134],   NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    [string appendAttributedString:string2];
    [_tipLabel setAttributedText:string];
}

- (void)submit
{
    [self.view endEditing:YES];
    NSString *title = _titleTextField.text;
    NSString *content = [_contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (title.length == 0 && content.length == 0) {
        [MBProgressHUD showText:@"请将信息填写完整" toView:self.view];
        return;
    }
    
    int line = (int)ceilf(_currentCount / 64.0);
    if (line * _people > _mesLeft && _smsButton.selected) {
        [MBProgressHUD showText:@"短信条数不足" toView:self.view];
        return;
    }
    
    hud = [MBProgressHUD showWaiting:@"上传中" toView:nil];
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *filePath = nil;
        if (_imageArray.count > 0) {
            for (UIImage *image in _imageArray) {
                NSInteger i = [_imageArray indexOfObject:image];
                NSString *imageUrl = [ZXZipHelper saveImage:image withName:[NSString stringWithFormat:@"%i.png",i]];
                [_imageUrlArray addObject:imageUrl];
            }
            filePath = [ZXZipHelper archiveImagesWithImageUrls:_imageUrlArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
            [ZXHomework addHomeworkWithSid:appStateInfo.sid content:content title:title cid:appStateInfo.cid tid:appStateInfo.tid isSendPhone:_smsButton.selected filePath:filePath block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [hud turnToSuccess:@""];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [hud turnToError:errorInfo];
                }
            }];
            
            
        });
    });
    
    
}

- (IBAction)smsAction:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}
#pragma -mark textfield delegate
- (void)textChanged:(NSNotification *)notification
{
    [_letterNumLabel setText:[NSString stringWithFormat:@"已经输入%i字",_contentTextView.text.length]];
    _currentCount = _contentTextView.text.length;
    int line = (int)ceilf(_currentCount / 64.0);
    [self tipLabelChangeText:_people * line mesCount:_mesLeft];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_contentTextView becomeFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZXImagePickCell heightByImageArray:_imageArray];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(&*self)weakSelf = self;
    ZXImagePickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImagePickCell"];
    [cell setImageArray:_imageArray];
    cell.clickBlock = ^(NSIndexPath *indexPath) {
        [weakSelf.view endEditing:YES];
        if (indexPath.row == _imageArray.count) {
            [weakSelf showActionSheet];
        } else {
            [weakSelf showDeleteActionSheet:indexPath.row];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)showActionSheet
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

- (void)showDeleteActionSheet:(NSInteger)index
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    actionSheet.tag = index;
    [actionSheet showInView:self.view];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:
                    // 取消
                    return;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = NO;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    } else {
        if (buttonIndex == 0) {
            [_imageArray removeObjectAtIndex:actionSheet.tag];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_imageArray addObject:image];
    
    [self.tableView reloadData];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
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
