//
//  MyRedPDetailController.m
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/11.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "MyRedPDetailController.h"
#import "IWHttpTool.h"
@interface MyRedPDetailController ()

@end

@implementation MyRedPDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavTest"] forBarMetrics:UIBarMetricsDefault];
        self.title = @"我的红包";
    [self loadDataSource];
}
-(void)loadDataSource{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.MainString forKey:@"AppLuckMoneyMainIdList"];
    [dic setValue:@"1" forKey:@"PageIndex"];
    [dic setValue:@"10" forKey:@"PageSize"];
    NSLog(@"---%@",dic);
    [IWHttpTool WMpostWithURL:@"/Customer/GetAppLuckMoneyDetailInfoList" params:dic success:^(id json) {
        NSLog(@"------------------红包详情:%@--------------------",json);
        
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];
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
