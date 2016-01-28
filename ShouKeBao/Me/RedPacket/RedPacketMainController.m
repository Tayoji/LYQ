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
#import "NewExclusiveAppIntroduceViewController.h"
#define UserInfoKeyLYGWIsOpenVIP @"LVGWIsOpenVIP"//是否开通银牌以上顾问
#define kScreenSize [UIScreen mainScreen].bounds.size

#define fourSize ([UIScreen mainScreen].bounds.size.height == 480)
#define fiveSize ([UIScreen mainScreen].bounds.size.height == 568)
#define sixSize ([UIScreen mainScreen].bounds.size.height == 667)
#define sixPSize ([UIScreen mainScreen].bounds.size.height > 668)


@interface RedPacketMainController ()
@property (nonatomic,strong) UIView *RedPacketAlertView;
@property (nonatomic,strong) UIView *backGroundRPView;
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
    NSUserDefaults *guiDefault = [NSUserDefaults standardUserDefaults];
    if ([[guiDefault objectForKey:UserInfoKeyLYGWIsOpenVIP] isEqualToString:@"0"]) {
        //没有开通
        [self.view.window addSubview:self.backGroundRPView];
        [self.view.window  addSubview:self.RedPacketAlertView];
    }else{
        SelectCustomerController *selectCustomer = [[SelectCustomerController alloc] init];
        selectCustomer.FromWhere = FromeRedPacket;
        [self.navigationController pushViewController:selectCustomer animated:YES];

    }
}

- (IBAction)RPacketRuleBtn:(UIButton *)sender {
    NSLog(@"红包规则介绍");
    RuleWebViewController *cont = [[RuleWebViewController alloc] init];
    cont.linkUrl = @"http://m.lvyouquan.cn/App/AppLuckMoneyRule";
    cont.webTitle = @"红包规则介绍";
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cont];
    [self.navigationController pushViewController:cont animated:YES];
}
-(void)BtnOfCancal:(UIButton *)button{
    [self.RedPacketAlertView removeFromSuperview];
    [self.backGroundRPView removeFromSuperview];
    if (button.tag == 2001) {
        
        NewExclusiveAppIntroduceViewController *exc = [[NewExclusiveAppIntroduceViewController alloc] init];
        exc.naVC = self.navigationController;
        [self.navigationController pushViewController:exc animated:YES];
    }
    //    }else if(button.tag == 2002){
    //        [self.RedPacketAlertView removeFromSuperview];
    //        [self.backGroundRPView removeFromSuperview];
    //    }
    
}
-(UIView *)backGroundRPView{
    if (!_backGroundRPView) {
        _backGroundRPView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        _backGroundRPView.backgroundColor = [UIColor blackColor];
        _backGroundRPView.alpha = 0.5;
    }
    return _backGroundRPView;
}
-(UIView *)RedPacketAlertView{
    if (!_RedPacketAlertView) {
        _RedPacketAlertView = [[UIView alloc] initWithFrame:CGRectMake(30, kScreenSize.height/3, kScreenSize.width-60, 200)];
        _RedPacketAlertView.layer.masksToBounds = YES;
        _RedPacketAlertView.layer.cornerRadius = 7;
        _RedPacketAlertView.backgroundColor = [UIColor whiteColor];
        UIImageView *HeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width-60, 200)];
        HeadImageView.userInteractionEnabled = YES;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_RedPacketAlertView.frame.size.width-40, 10, 25, 25)];
        [btn setImage:[UIImage imageNamed:@"WowOfRedPacketCanal"] forState:UIControlStateNormal];
        btn.tag = 2002;
        [btn addTarget:self action:@selector(BtnOfCancal:) forControlEvents:UIControlEventTouchUpInside];
        [HeadImageView addSubview:btn];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, HeadImageView.frame.size.height/2-20, HeadImageView.frame.size.width-20, 30)];
        label.text = @"开通专属APP,才能享受此功能!";
        label.textAlignment = NSTextAlignmentCenter;
        if (fourSize) {
                label.font = [UIFont systemFontOfSize:17];
        }else if(fiveSize){
                label.font = [UIFont systemFontOfSize:18];
        }else if(sixSize){
                label.font = [UIFont systemFontOfSize:20];
        }else{
                label.font = [UIFont systemFontOfSize:20];
        }
    
        [HeadImageView addSubview:label];
        UIButton *btn2 = [[UIButton alloc]   initWithFrame:CGRectMake(HeadImageView.frame.size.width/2-70, HeadImageView.frame.size.height-HeadImageView.frame.size.height/3, 140, 40)];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"WowOfRedPacketBtn"] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(BtnOfCancal:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn2 setTitle:@"立即申请开通" forState:UIControlStateNormal];
        btn2.tag = 2001;
        [btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [HeadImageView addSubview:btn2];
        [HeadImageView setImage:[UIImage imageNamed:@"WowOfRedPacket1"]];
        [_RedPacketAlertView addSubview:HeadImageView];
    }
    return _RedPacketAlertView;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
