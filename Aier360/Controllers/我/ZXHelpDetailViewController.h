//
//  ZXHelpDetailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXHelpDetailViewController : ZXBaseViewController<UIWebViewDelegate>
@property (nonatomic , weak) IBOutlet UIWebView *webView;
@property (nonatomic , copy) NSString *parameter;
@end
