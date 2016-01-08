//
//  VisitorDynamicNullView.h
//  ShouKeBao
//
//  Created by 冯坤 on 16/1/7.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    nullTyeInviteVisitor,
    nullTypeSendRedPacket
}NullType;
@protocol NullViewDelegate <NSObject>

- (void)ClickInviteVisitor;
- (void)ClickSendRedPacket;

@end



@interface VisitorDynamicNullView : UIView

@property (nonatomic, assign)id<NullViewDelegate>delegate;

- (void)showNullViewToView:(UIView *)View Type:(NullType)nullType;

- (void)hideNullViewFromView:(UIView *)View;


@end
