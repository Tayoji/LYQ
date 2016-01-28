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

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 50
#define INSETS 8

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE + 15)];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photo"] forState:UIControlStateNormal];
    [_photoButton setTitle:@"照片" forState:UIControlStateNormal];
    //设置图片等的文字偏移量
    _photoButton.imageEdgeInsets = UIEdgeInsetsMake(5,5,15,0);
    _photoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _photoButton.titleEdgeInsets = UIEdgeInsetsMake(55, -45, 0, 0);
    [_photoButton setTitleColor:[UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0] forState:UIControlStateNormal];
    _photoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photoSelected"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    
//    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_locationButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_location"] forState:UIControlStateNormal];
//    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
//    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_locationButton];
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE + 15)];
    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
    [_takePicButton setTitle:@"拍摄" forState:UIControlStateNormal];
    
    _takePicButton.imageEdgeInsets = UIEdgeInsetsMake(5,5,15,0);
    _takePicButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _takePicButton.titleEdgeInsets = UIEdgeInsetsMake(55, -45, 0, 0);
    [_takePicButton setTitleColor:[UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0] forState:UIControlStateNormal];
    _takePicButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    
//fkfk
    _SendRedPacket =[UIButton buttonWithType:UIButtonTypeCustom];
    [_SendRedPacket setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE*2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE +15)];
    [_SendRedPacket setImage:[UIImage imageNamed:@"SendRedPacket2"] forState:UIControlStateNormal];
    [_SendRedPacket setImage:[UIImage imageNamed:@"SendRedPacket2"] forState:UIControlStateHighlighted];
    [_SendRedPacket setTitle:@"红包" forState:UIControlStateNormal];

    
    [_SendRedPacket addTarget:self action:@selector(takeRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
    //设置图片等的文字偏移量
    _SendRedPacket.imageEdgeInsets = UIEdgeInsetsMake(5,5,15,0);
    _SendRedPacket.titleLabel.font = [UIFont systemFontOfSize:14];
    _SendRedPacket.titleEdgeInsets = UIEdgeInsetsMake(55, -45, 0, 0);
    [_SendRedPacket setTitleColor:[UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0] forState:UIControlStateNormal];
    _SendRedPacket.titleLabel.textAlignment = NSTextAlignmentCenter;

    
    [self addSubview:_SendRedPacket];

    
    CGRect frame = self.frame;
    if (type == ChatMoreTypeChat) {
        frame.size.height = 150;
        _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_audioCallButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCall"] forState:UIControlStateNormal];
        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCallSelected"] forState:UIControlStateHighlighted];
        [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_audioCallButton];
        
        _videoCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_videoCallButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_SIZE + 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCall"] forState:UIControlStateNormal];
        [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCallSelected"] forState:UIControlStateHighlighted];
        [_videoCallButton addTarget:self action:@selector(takeRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_videoCallButton];
    }
    else if (type == ChatMoreTypeGroupChat)
    {
        frame.size.height = 80;
    }
    self.frame = frame;
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

- (void)takeRedPacketAction{
    
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewRedPacketAction:)]) {
        [_delegate moreViewRedPacketAction:self];
    }
}


@end
