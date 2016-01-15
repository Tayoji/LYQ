//
//  SetRedPacketController.h
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
@class EMMessage;
typedef enum{
    sendRedPacketTypeList,
    sendRedPacketTypeChatVC,
    sendRedPacketTypeCustom
}SendRedPacketType;
@protocol SendRedPacketDelegate <NSObject>

- (void)didSendRedPacket:(EMMessage *)tempMessage;

@end

@interface SetRedPacketController : SKViewController
@property id<SendRedPacketDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITextView *RedPDescribeTextView;
@property (weak, nonatomic) IBOutlet UITextView *ExitCountryTextView;
@property (weak, nonatomic) IBOutlet UITextView *InlandTextView;
@property (weak, nonatomic) IBOutlet UITextView *RimtextView;
@property (nonatomic,strong) NSMutableArray *NumOfPeopleArr;//人数
@property (nonatomic) CGFloat InlandN;//国内游
@property (nonatomic) CGFloat RimN;//周边
@property (nonatomic) CGFloat ExitCountryN;//出境游
@property (nonatomic) CGFloat FinalMoney;
- (IBAction)GrantRPBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *NumOfRedPLabel;
@property (weak, nonatomic) IBOutlet UILabel *FinalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *SendRedPacketBtn;
@property (nonatomic, assign)SendRedPacketType sendRedPacketType;


@end
