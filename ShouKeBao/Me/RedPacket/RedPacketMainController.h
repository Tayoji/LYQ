//
//  RedPacketMainController.h
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketMainController : UIViewController
- (IBAction)backBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)MyRedPacketBtn:(UIButton *)sender;
- (IBAction)AppointRPacketBtn:(UIButton *)sender;
- (IBAction)RPacketRuleBtn:(UIButton *)sender;
@property (nonatomic,copy) NSString *TelGuide;
@end
