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

#import "EMChatBaseBubbleView.h"

NSString *const kRouterEventChatCellBubbleTapEventName = @"kRouterEventChatCellBubbleTapEventName";

@interface EMChatBaseBubbleView ()

@end

@implementation EMChatBaseBubbleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.multipleTouchEnabled = YES;
        _backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_backImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPressed:)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    _model = model;
    
    BOOL isReceiver = !_model.isSender;
    
    NSString *imageName = isReceiver ? BUBBLE_LEFT_IMAGE_NAME : BUBBLE_RIGHT_IMAGE_NAME;
    if (model.message.ext) {
        if ([model.message.ext[@"MsgType"]isEqualToString:@"4"]) {
            imageName = @"SendRedPacket";
        }
        if (_model.isSender && [_model.message.ext[@"MsgType"]isEqualToString:@"3"]) {
            imageName =  BUBBLE_RIGHTPRODUCT_IMAGE_NAME;
        }

    }
    
    NSInteger leftCapWidth = isReceiver?BUBBLE_LEFT_LEFT_CAP_WIDTH:BUBBLE_RIGHT_LEFT_CAP_WIDTH;
    NSInteger topCapHeight =  isReceiver?BUBBLE_LEFT_TOP_CAP_HEIGHT:BUBBLE_RIGHT_TOP_CAP_HEIGHT;
//    UIImage * bgimage = [UIImage imageNamed:@"loginbg"];
//    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
//    // 指定为拉伸模式，伸缩后重新赋值
//    bgimage = [bgimage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    self.backImageView.image = bgimage;
    self.backImageView.image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}

#pragma mark - public

+ (CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    return 30;
}

- (void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventChatCellBubbleTapEventName userInfo:@{KMESSAGEKEY:self.model}];
}

- (void)progress:(CGFloat)progress
{
    [_progressView setProgress:progress animated:YES];
}

@end
