//
//  FKSendRedPacketView.h
//  ShouKeBao
//
//  Created by 冯坤 on 16/1/11.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageModel;
@interface FKSendRedPacketView : UIView


+ (FKSendRedPacketView *)FKSendRedPacketWithModel:(MessageModel *)model
                                          andFrame:(CGRect)frame;


@end
