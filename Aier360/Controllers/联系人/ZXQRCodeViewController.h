//
//  ZXQRCodeViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/26.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ZXQRCodeViewController : ZXBaseViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UIImageView * imageView;
    
    BOOL hasCameraRight;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@end
