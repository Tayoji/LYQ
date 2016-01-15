//
//  EMChatCustomBubbleView.m
//  TravelConsultant
//
//  Created by 冯坤 on 15/12/29.
//  Copyright © 2015年 冯坤. All rights reserved.
//

#import "EMChatCustomBubbleView.h"
#import "FKProductModel.h"
#import "ProductModal.h"
#import "JSONKit.h"
#import "FKReceiveProductLinkView.h"
#import "FKSendRedPacketView.h"
#import "NSString+FKTools.h"
NSString *const kRouterEventSendProductEventName = @"kRouterEventSendProductEventName";
NSString *const kRouterEventOpenRedPacketEventName = @"kRouterEventOpenRedPacketEventName";
@interface EMChatCustomBubbleView()
//推送专辑和产品
@property (nonatomic, strong)FKProductModel * FKmodel;

//产品链接发送给顾问
@property (nonatomic, strong)ProductModal * FKProductModel;


@end
@implementation EMChatCustomBubbleView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];


}

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    if (self.model.message.ext) {
        [self sizeToFit];
        CGRect frame = self.bounds;
        frame.size.width -= BUBBLE_ARROW_WIDTH;
        frame = CGRectInset(frame, BUBBLE_VIEW_PADDING, BUBBLE_VIEW_PADDING);
        if (self.model.isSender) {
            frame.origin.x = BUBBLE_VIEW_PADDING;
        }else{
            frame.origin.x = BUBBLE_VIEW_PADDING + BUBBLE_ARROW_WIDTH;
        }
        frame.origin.y = BUBBLE_VIEW_PADDING;

        for (UIView * view in self.subviews) {
            [view removeFromSuperview];
        }

        // MsgType = 1 推送产品；
        if ([self.model.message.ext[@"MsgType"]isEqualToString:@"1"]) {
        }else if([self.model.message.ext[@"MsgType"]isEqualToString:@"3"]){//MsgType = 3 发送产品链接
            NSLog(@"%@", self.model.message.ext[@"MsgValue"]);
            NSDictionary * dic = @{};
            if ([self.model.message.ext[@"MsgValue"]isKindOfClass:[NSString class]]) {
                dic = [self parseJSONStringToNSDictionary:self.model.message.ext[@"MsgValue"]];
            }else{
                dic = self.model.message.ext[@"MsgValue"];
            }
            self.FKProductModel = [ProductModal modalWithDict:dic];
            FKReceiveProductLinkView  * FKV = [FKReceiveProductLinkView FKProductViewWithModel:self.FKProductModel andFrame:frame];
            [self addSubview:FKV];

        }else if([self.model.message.ext[@"MsgType"]isEqualToString:@"4"]){
            CGRect aframe = self.bounds;
            aframe.size.width -= 9 ;
            aframe = CGRectInset(aframe, 0, 0);
            if (self.model.isSender) {
                aframe.origin.x = 0;
            }else{
                aframe.origin.x =  8;
            }
            aframe.origin.y = 0;
            FKSendRedPacketView * FKV = [FKSendRedPacketView FKSendRedPacketWithModel:self.model andFrame:aframe];
            [self addSubview:FKV];
        }else{
        }
    }

    
}
-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {

    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    return responseJSON;
}

+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    if (object.message.ext) {
        if ([object.message.ext[@"MsgType"]isEqualToString:@"1"]) {
            return 2 * BUBBLE_VIEW_PADDING + 285;
        }
        if ([object.message.ext[@"MsgType"]isEqualToString:@"3"]) {
            return 2 * BUBBLE_VIEW_PADDING + 110;
        }
        if ([object.message.ext[@"MsgType"]isEqualToString:@"4"]) {
            return 2 * BUBBLE_VIEW_PADDING + 130;
        }
        
    }
    return 0;
}

-(void)bubbleViewPressed:(id)sender
{
    if ([self.model.message.ext[@"MsgType"]isEqualToString:@"1"]) {

    }else if ([self.model.message.ext[@"MsgType"]isEqualToString:@"3"]) {
        NSDictionary * dict = @{@"model":self.FKProductModel};
        NSLog(@"%@", self.FKProductModel.LinkUrl);
        [self routerEventWithName:kRouterEventSendProductEventName userInfo:dict];
        
    }else if ([self.model.message.ext[@"MsgType"]isEqualToString:@"4"]) {
        NSDictionary * dict = @{@"URL":self.model};
        [self routerEventWithName:kRouterEventOpenRedPacketEventName userInfo:dict];
    }
}
-(CGSize)sizeThatFits:(CGSize)size{
    if (self.model.message.ext) {
        if ([self.model.message.ext[@"MsgType"]isEqualToString:@"1"]) {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width - 120 + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING, 285);
        }
        if ([self.model.message.ext[@"MsgType"]isEqualToString:@"3"]) {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width - 120 + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING, 110);
        }
        if ([self.model.message.ext[@"MsgType"]isEqualToString:@"4"]) {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width - 120 + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING, 120);

        }
    }
    return CGSizeMake(0, 0);
}



@end
