//
//  ZXSelectLocationViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface ZXSelectLocationViewController : ZXRefreshTableViewController<BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch *_searcher;
}
@property (nonatomic , assign) float lat;
@property (nonatomic , assign) float lng;
@property (nonatomic , copy) void (^addressBlock)(NSString *address);
@end
