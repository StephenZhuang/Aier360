//
//  ZXSchoolMenuCollectionReusableView.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/17.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolMenuCollectionReusableView.h"

@implementation ZXSchoolMenuCollectionReusableView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.schoolImageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.schoolImageView.layer.masksToBounds = YES;
}

- (void)configureUIWithSchool:(ZXSchool *)school
{
    [self.schoolImageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForOrigin:school.img] placeholderImage:[UIImage imageNamed:@"schoolimage_default"]];
    
    [self.schoolNameLabel setText:school.name];
    [self.imgNumButton setTitle:[NSString stringWithFormat:@"%@",@(school.num_img)] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSchoolImg)];
    [self.schoolImageView addGestureRecognizer:tap];
    self.schoolImageView.userInteractionEnabled = YES;
}

- (void)gotoSchoolImg
{
    !_schollImageBlock?:_schollImageBlock();
}
@end
