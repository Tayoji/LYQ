//
//  SetRedPacketController.h
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@interface SetRedPacketController : SKViewController
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITextView *RedPDescribeTextView;
@property (weak, nonatomic) IBOutlet UITextView *ExitCountryTextView;
@property (weak, nonatomic) IBOutlet UITextView *InlandTextView;
@property (weak, nonatomic) IBOutlet UITextView *RimtextView;
- (IBAction)GrantRPBtn:(UIButton *)sender;

@end
