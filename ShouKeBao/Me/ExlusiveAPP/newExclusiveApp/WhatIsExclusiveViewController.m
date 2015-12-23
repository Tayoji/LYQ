//
//  WhatIsExclusiveViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/12/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "WhatIsExclusiveViewController.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "YYAnimationIndicator.h"
#import "WMAnimations.h"
#import <ShareSDK/ShareSDK.h>
#import "StrToDic.h"
#import "MBProgressHUD+MJ.h"
#define View_Width [UIScreen mainScreen].bounds.size.width
#define View_Height [UIScreen mainScreen].bounds.size.height

@interface WhatIsExclusiveViewController ()<UIWebViewDelegate>
- (IBAction)introduceReturnButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *introduceExclusiveAppTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong)YYAnimationIndicator *indicator;
@property (nonatomic, strong)UILabel *warningLab;

@end

@implementation WhatIsExclusiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:214/225.0f green:214/225.0f blue:214/225.0f alpha:1];
    
     [self setWebView];
    [WMAnimations WMNewWebWithScrollView:self.webView.scrollView];
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
   
    [_indicator setLoadText:@"拼命加载中..."];
//    if (self.url.length==0) {
//        self.url = @"http://m.lvyouquan.cn/App/AppExclusiveIntroduces";
//    }
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:self.url]]];
    [self.view addSubview:_indicator];
   
    
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
     [self.indicator startAnimation];
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_indicator stopAnimationWithLoadText:@"" withType:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
     [_indicator stopAnimationWithLoadText:@"" withType:YES];
}


-(void)setWebView{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 60, View_Width, View_Height-60)];
    webView.delegate = self;
    [webView scalesPageToFit];
    [webView.scrollView setShowsVerticalScrollIndicator:NO];
    [webView.scrollView setShowsHorizontalScrollIndicator:NO];
    self.webView = webView;
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"WhatIsExclusiveViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"WhatIsExclusiveViewController"];
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

- (IBAction)introduceReturnButton:(id)sender {
    [self.naV popViewControllerAnimated:YES];
}
@end
