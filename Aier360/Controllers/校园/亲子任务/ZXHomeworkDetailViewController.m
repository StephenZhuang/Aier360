//
//  ZXHomeworkDetailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomeworkDetailViewController.h"
#import "ZXHomeworkCell.h"
#import "ZXImageCell.h"
#import "ZXCommentCountCell.h"
#import "ZXHomeworkCommentCell.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXPraiseListViewController.h"
#import "ZXHomeworkReadViewController.h"
#import "ZXZipHelper.h"
#import "ZXFoodImagePickerViewController.h"
#import "UIViewController+ZXPhotoBrowser.h"

@interface ZXHomeworkDetailViewController (){
    NSInteger chid;
    NSString *rname;
    NSInteger commentIndex;
}
@property (nonatomic , weak) IBOutlet ZXEmojiPicker *emojiPicker;
@property (nonatomic , weak) IBOutlet UIButton *emojiButton;
@property (nonatomic , weak) IBOutlet UIButton *cameraButton;
@property (nonatomic , weak) IBOutlet UITextField *commentTextField;
@property (nonatomic , weak) IBOutlet UIView *toolView;
@property (nonatomic , strong) NSMutableArray *imageArray;
@end

@implementation ZXHomeworkDetailViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Homework" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXHomeworkDetailViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"详情";
    _emojiPicker.emojiBlock = ^(NSString *text) {
        _commentTextField.text = [_commentTextField.text stringByAppendingString:text];
    };
    self.imageArray = [[NSMutableArray alloc] init];
}

- (void)loadData
{
    [ZXHomework getHomeworkDetailWithUid:GLOBAL_UID hid:_hid block:^(ZXHomework *homework, NSError *error) {
        _homework = homework;
        [self.dataArray removeAllObjects];
        for (ZXHomeworkComment *comment in homework.hcList) {
            [self.dataArray addObject:comment];
            if (comment.hcrList) {
                [self.dataArray addObjectsFromArray:comment.hcrList];
            }
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

- (void)addFooter{}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_homework.img.length > 0) {
            return 2;
        } else {
            return 1;
        }
    } else if (section == 1) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            return [ZXHomeworkCell heightByText:_homework.content];
        } else {
                //图片
            NSArray *arr = [_homework.img componentsSeparatedByString:@","];
            return [ZXImageCell heightByImageArray:arr];
        }
    } else if (indexPath.section == 1){
        return 65;
    } else {
        NSObject *object = [self.dataArray objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[ZXHomeworkComment class]]) {
            ZXHomeworkComment *comment = (ZXHomeworkComment *)object;
            if (comment.img.length > 0) {
                NSArray *arr = [comment.img componentsSeparatedByString:@","];
                return [ZXHomeworkCommentCell heightByEmojiText:comment.content imageArray:arr];
            } else {
                return [ZXDynamicCommentCell heightByEmojiText:comment.content];
            }
        } else {
            ZXHomeworkCommentReply *commentReply = (ZXHomeworkCommentReply *)object;
            return [ZXDynamicCommentCell heightByEmojiText:commentReply.content];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            ZXHomeworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXHomeworkCell"];
            [cell configureUIWithHomework:_homework indexPath:indexPath];
            if (CURRENT_IDENTITY == ZXIdentityClassMaster) {
                [cell.deleteButton setHidden:NO];
            } else {
                [cell.deleteButton setHidden:YES];
                [cell removeDeleteButton];
            }
            return cell;
        } else {
            //图片
            ZXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImageCell"];
            __block NSArray *arr = [_homework.img componentsSeparatedByString:@","];
            cell.type = ZXImageTypeHomework;
            [cell setImageArray:arr];
            cell.imageClickBlock = ^(NSInteger index) {
                [self browseImage:arr type:ZXImageTypeHomework index:index];
            };
            return cell;
        }
    } else if (indexPath.section == 1){
        ZXCommentCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCommentCountCell"];
        if (_homework.reading > 0) {
            [cell.praiseCountLabel setText:[NSString stringWithFormat:@"%i人已阅",_homework.reading]];
            [cell.praiseDetailButton setHidden:NO];
        } else {
            [cell.praiseCountLabel setText:@"还没有人阅读过"];
            [cell.praiseDetailButton setHidden:YES];
        }
        [cell.commentCountLabel setText:[NSString stringWithFormat:@"评论(%i):",_homework.comment]];
        return cell;
    } else {
        ZXHomeworkCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXHomeworkCommentCell"];
        if ([[self.dataArray objectAtIndex:indexPath.row] isKindOfClass:[ZXHomeworkComment class]]) {
            ZXHomeworkComment *comment = [self.dataArray objectAtIndex:indexPath.row];
            [cell configureUIWithHomeworkComment:comment];
            if (comment.img.length > 0) {
                __block NSArray *arr = [comment.img componentsSeparatedByString:@","];
                
                cell.imageClickBlock = ^(NSInteger index) {
                    [self browseImage:arr type:ZXImageTypeHomework index:index];
                };
            }
        } else {
            [cell configureUIWithHomeworkCommentReply:[self.dataArray objectAtIndex:indexPath.row]];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        commentIndex = indexPath.row;
        if ([[self.dataArray objectAtIndex:indexPath.row] isKindOfClass:[ZXHomeworkComment class]]) {
            ZXHomeworkComment *comment = [self.dataArray objectAtIndex:indexPath.row];
            if (comment.uid == GLOBAL_UID) {
                [MBProgressHUD showText:@"不能回复自己" toView:self.view];
            } else {
                chid = comment.chid;
                rname = comment.cname;
                _commentTextField.placeholder = [NSString stringWithFormat:@"回复 %@:",comment.cname];
                [_commentTextField becomeFirstResponder];
                [_cameraButton setHidden:YES];
            }
        } else if ([[self.dataArray objectAtIndex:indexPath.row] isKindOfClass:[ZXHomeworkCommentReply class]]) {
            ZXHomeworkCommentReply *comment = [self.dataArray objectAtIndex:indexPath.row];
            if (comment.uid == GLOBAL_UID) {
                [MBProgressHUD showText:@"不能回复自己" toView:self.view];
            } else {
                chid = comment.chid;
                rname = comment.cname;
                _commentTextField.placeholder = [NSString stringWithFormat:@"回复 %@:",comment.cname];
                [_commentTextField becomeFirstResponder];
                [_cameraButton setHidden:YES];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)commentAction:(id)sender
{
    [self.view endEditing:YES];
    [_emojiButton setSelected:NO];
    if (_emojiPicker.showing) {
        [_emojiPicker hide];
        self.toolView.transform = CGAffineTransformIdentity;
    }
    NSString *content = [[_commentTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0 && _imageArray.count == 0) {
        [_cameraButton setHidden:NO];
        _commentTextField.placeholder = @"发布评论";
        chid = 0;
        rname = @"";
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    //TODO: 判断教师还是家长
    NSInteger type = 0;
    if (appStateInfo.tid > 0) {
        type = 1;
    } else {
        type = 2;
    }
    if (chid == 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSString *filePath = nil;
            if (_imageArray.count > 0) {
                filePath = [ZXZipHelper archiveImages:_imageArray];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                
                [ZXHomework commentHomeworkWithHid:_homework.hid sid:appStateInfo.sid content:content type:type uid:GLOBAL_UID touid:_homework.uid tid:appStateInfo.tid filePath:filePath block:^(BOOL success, NSString *errorInfo) {
                    if (success) {
                        [hud turnToSuccess:@""];
                        _commentTextField.text = @"";
                        _commentTextField.placeholder = @"发布评论";
                        chid = 0;
                        rname = @"";
                        [_imageArray removeAllObjects];
                    } else {
                        [hud turnToError:errorInfo];
                    }
                }];
            });
        });
        
        
        
    } else {
        NSObject *object = [self.dataArray objectAtIndex:commentIndex];
        if ([object isKindOfClass:[ZXHomeworkComment class]]) {
            ZXHomeworkComment *comment = (ZXHomeworkComment *)object;
            [ZXHomework replyCommentWithChid:chid sid:appStateInfo.sid content:content type:type uid:GLOBAL_UID tid:appStateInfo.tid crhid:0 touid:comment.uid block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [hud turnToSuccess:@""];
                    _commentTextField.text = @"";
                    _commentTextField.placeholder = @"发布评论";
                    chid = 0;
                    rname = @"";
                    [_cameraButton setHidden:NO];
                } else {
                    [hud turnToError:errorInfo];
                }
            }];
        } else if ([object isKindOfClass:[ZXHomeworkCommentReply class]]) {
            ZXHomeworkCommentReply *reply = (ZXHomeworkCommentReply *)object;
            [ZXHomework replyCommentWithChid:chid sid:appStateInfo.sid content:content type:type uid:GLOBAL_UID tid:appStateInfo.tid crhid:reply.crhid touid:reply.uid block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [hud turnToSuccess:@""];
                    _commentTextField.text = @"";
                    _commentTextField.placeholder = @"发布评论";
                    chid = 0;
                    rname = @"";
                    [_cameraButton setHidden:NO];
                } else {
                    [hud turnToError:errorInfo];
                }
            }];
        }
        
    }
    
    
}

- (IBAction)showPicker:(UIButton *)sender
{
    [self.view endEditing:YES];
    [_emojiButton setSelected:NO];
    if (_emojiPicker.showing) {
        [_emojiPicker hide];
        self.toolView.transform = CGAffineTransformIdentity;
    }
    ZXFoodImagePickerViewController *vc = [ZXFoodImagePickerViewController viewControllerFromStoryboard];
    [vc showOnViewControlelr:self];
    vc.pickBlock = ^(NSArray *array) {
        [_imageArray removeAllObjects];
        [_imageArray addObjectsFromArray:array];
        [self commentAction:nil];
    };
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self commentAction:nil];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_emojiButton setSelected:NO];
    if (_emojiPicker.showing) {
        [_emojiPicker hide];
        self.toolView.transform = CGAffineTransformIdentity;
    }
}

- (IBAction)emojiAction:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    [self.view endEditing:YES];
    if (sender.selected) {
        [_emojiPicker show];
        [UIView animateWithDuration:0.25 animations:^{
            self.toolView.transform = CGAffineTransformTranslate(self.toolView.transform, 0, - CGRectGetHeight(_emojiPicker.frame));
        }];
    } else {
        [_emojiPicker hide];
        [UIView animateWithDuration:0.25 animations:^{
            self.toolView.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (IBAction)deleteAction:(UIButton *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:nil];
    [ZXHomework deleteHomeworkWithHid:_homework.hid block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [hud turnToSuccess:@""];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
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
    if ([segue.identifier isEqualToString:@"read"]) {
        ZXHomeworkReadViewController *vc = [segue destinationViewController];
        vc.hid = _homework.hid;
    }
}

@end
