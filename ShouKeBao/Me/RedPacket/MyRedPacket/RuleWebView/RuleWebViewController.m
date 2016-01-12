//
//  RuleWebViewController.m
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/12.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "RuleWebViewController.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface RuleWebViewController ()

@end

@implementation RuleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.s
    self.navigationController.navigationBarHidden = NO;
//    [self.view addSubview:self.WebView];
//    [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"www.baidu.com"]]];
    
}
//-(UIWebView *)WebView{
//    if (!_WebView) {
//        _WebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,kScreenSize.width, kScreenSize.height-64)];
//    }
//    return _WebView;
//}
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
