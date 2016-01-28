//
//  APNSHelper.h
//  TravelConsultant
//
//  Created by 冯坤 on 15/11/23.
//  Copyright (c) 2015年 冯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APNSHelper : NSObject

@property (nonatomic, assign)BOOL hasNewMessage;
@property (nonatomic, assign)BOOL isNeedOpenChat;
@property (nonatomic, strong)NSString * dataStr;

@property (nonatomic, assign)BOOL isHideCheckNewVertion;
@property (nonatomic, assign)BOOL isJumpChatList;
@property (nonatomic, assign)BOOL isJumpChat;


@property (nonatomic, assign)BOOL isJumpOpenExclusiveAppIntroduce;//跳到已经开通的专属APP界面
@property (nonatomic, assign)BOOL isJumpExclusiveApp;//跳到未开通的专属APP界面

@property (nonatomic, assign)BOOL isReceiveRemoteNotification;
@property (nonatomic, strong)NSDictionary * userInfoDic;

@property (nonatomic, assign)NSString * chatName;

+(APNSHelper *)defaultAPNSHelper;

@end
