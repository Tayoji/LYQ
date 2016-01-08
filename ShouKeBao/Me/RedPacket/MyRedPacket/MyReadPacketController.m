//
//  MyReadPacketController.m
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/8.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "MyReadPacketController.h"
#import "UIImageView+WebCache.h"
#import "UserInfo.h"
#import "IWHttpTool.h"
@interface MyReadPacketController ()

@end

@implementation MyReadPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的红包";
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavTest"] forBarMetrics:UIBarMetricsDefault];
    //填充用户信息
    [self.UserInfoHeaderPic sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLYGWHeaderPic]]];
    self.UserInfoName.text = [NSString stringWithFormat:@"%@共发出",[[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKeyLYGWName]];
    [self creatNavOfRight];
    [self loadDataSource];
}
-(void)loadDataSource{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"pageIndex"];
    [dic setValue:@"5" forKey:@"pageSize"];
    [dic setValue:@"2" forKey:@"LuckMoneyType"];
    [IWHttpTool WMpostWithURL:@"" params:dic success:^(id json) {
        NSLog(@"-------------------我的红包信息:%@------------------",json);
        
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}
-(void)creatNavOfRight{
    UIButton *myBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [myBtn setImage:[UIImage imageNamed:@"RedPacketHelp"] forState:UIControlStateNormal];
    myBtn.tag = 106;
    [myBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:myBtn];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)BtnClick:(UIButton *)button{
    NSLog(@"又是问号");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
