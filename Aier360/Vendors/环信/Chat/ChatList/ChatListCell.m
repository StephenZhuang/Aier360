/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */


#import "ChatListCell.h"
//#import "UIImageView+EMWebCache.h"
#import "ChatDemoUIDefine.h"
#import "MagicalMacro.h"

@interface ChatListCell (){
    UILabel *_timeLabel;
    UILabel *_unreadLabel;
    UILabel *_detailLabel;
    UIView *_lineView;
}

@end

@implementation ChatListCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 7, 80, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor colorWithRed:161/255.0 green:157/255.0 blue:148/255.0 alpha:1.0];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_timeLabel];
        
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 35, 15, 15)];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textColor = [UIColor whiteColor];
        
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.layer.cornerRadius = 7.5;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 175, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = [UIColor colorWithRed:158/255.0 green:152/255.0 blue:139/255.0 alpha:1.0];
        [self.contentView addSubview:_detailLabel];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 1)];
        _lineView.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.imageView.frame;
    
    [self.imageView sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage];
    self.imageView.frame = CGRectMake(15, 7, 45, 45);
    self.imageView.layer.cornerRadius = 22.5;
    self.imageView.layer.masksToBounds = YES;
    
    self.textLabel.text = _name;
    self.textLabel.frame = CGRectMake(70, 7, 175, 20);
    self.textLabel.textColor = [UIColor colorWithRed:95/255.0 green:95/255.0 blue:95/255.0 alpha:1.0];
    
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    if (_unreadCount > 0) {
        if (_unreadCount < 9) {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            _unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [_unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%@",@(_unreadCount)];
    }else{
        [_unreadLabel setHidden:YES];
    }
    
    frame = _lineView.frame;
    frame.origin.y = self.contentView.frame.size.height - 1;
    frame.size.width = self.contentView.frame.size.width;
    _lineView.frame = frame;
}

-(void)setName:(NSString *)name{
    _name = name;
    self.textLabel.text = name;
}

+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
