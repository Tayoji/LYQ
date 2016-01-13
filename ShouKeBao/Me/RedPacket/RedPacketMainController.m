//
//  RedPacketMainController.m
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "RedPacketMainController.h"
#import "SelectCustomerController.h"
#import "MyReadPacketController.h"
#import "RuleWebViewController.h"
#define UserInfoKeyLYGWIsOpenVIP @"LVGWIsOpenVIP"//是否开通银牌以上顾问

@interface RedPacketMainController ()

@end

@implementation RedPacketMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"RedPacketBackg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    [self.backButton setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateNormal];
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(-1, -10, 0, 50);
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:15];

}

- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (IBAction)MyRedPacketBtn:(UIButton *)sender {
    NSLog(@"我的红包");
    MyReadPacketController *MyreadPack = [[MyReadPacketController alloc]init];
    [self.navigationController pushViewController:MyreadPack animated:YES];
}

- (IBAction)AppointRPacketBtn:(UIButton *)sender {
    NSLog(@"指定发红包");
//    NSUserDefaults *guiDefault = [NSUserDefaults standardUserDefaults];
//    if ([[guiDefault objectForKey:UserInfoKeyLYGWIsOpenVIP] isEqualToString:@"0"]) {
//        //没有开通
//    
//    }else{
        SelectCustomerController *selectCustomer = [[SelectCustomerController alloc] init];
        selectCustomer.FromWhere = FromeRedPacket;
        [self.navigationController pushViewController:selectCustomer animated:YES];

//    }
}

- (IBAction)RPacketRuleBtn:(UIButton *)sender {
    NSLog(@"红包规则");
    RuleWebViewController *cont = [[RuleWebViewController alloc] init];
    cont.linkUrl = @"http://m.lvyouquan.cn/App/AppLuckMoneyProduceNote";
    cont.webTitle = @"红包生成说明";
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cont];
    [self.navigationController pushViewController:cont animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
