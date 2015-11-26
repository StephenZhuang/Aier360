//
//  AppDelegate.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <BaiduMapAPI/BMapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate,WXApiDelegate>
{
    EMConnectionState _connectionState;
    BMKMapManager* _mapManager;
//    UIView *welcomeView;
}

@property (strong, nonatomic) UIWindow *window;


@end

