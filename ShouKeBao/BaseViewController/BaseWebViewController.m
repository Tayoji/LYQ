//
//  BaseWebViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/7/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BaseWebViewController.h"
#import "BeseWebView.h"
#import "UINavigationController+SGProgress.h"
#import "MeHttpTool.h"
#import "ShareHelper.h"
#import "NSString+FKTools.h"
@interface BaseWebViewController ()<UIWebViewDelegate, notiPopUpBox>
@property (nonatomic, copy)NSString *urlSuffix;
@property (nonatomic, copy)NSString *urlSuffix2;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix = urlSuffix;
    
    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix2 = urlSuffix2;

    [self setUpleftBarButtonItems];
    self.title = self.webTitle;
    [self.view addSubview:self.webView];
//    [self.webView scalesPageToFit];
    self.webView.scalesPageToFit = YES;
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.linkUrl]];
    [self.webView loadRequest:request];
    
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];

    
    
}

#pragma mark - getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[BeseWebView alloc] init];
        _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
        _webView.delegate = self;
    }
    return _webView;
}
-(void)setUpleftBarButtonItems
{
    [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:YES];
}

-(void)back
{
    
    if ([_webView canGoBack]) {
        
        [self.webView goBack];
    }
    else  {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)turnOff
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  - mark delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *rightUrl = request.URL.absoluteString;
    NSLog(@"rightStr is %@--------",rightUrl);
    NSRange range = [rightUrl rangeOfString:_urlSuffix];//带？
    NSRange range2 = [rightUrl rangeOfString:_urlSuffix2];//不带?
    NSRange range3 = [rightUrl rangeOfString:@"?"];
    
    if (range3.location == NSNotFound && range.location == NSNotFound) {//没有问号，没有问号后缀
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix]]]];
        //        [self doIfInWebWithUrl:rightUrl];
        return YES;
    }else if (range3.location != NSNotFound && range2.location == NSNotFound ){//有问号没有后缀
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix2]]]];
        //        [self doIfInWebWithUrl:rightUrl];
        
        return YES;
    }else{
        //        [self doIfInWebWithUrl:rightUrl];
        [_indicator startAnimation];
    }
    NSLog(@"rightStr is %@--------",rightUrl);
    if([rightUrl myContainsString:@"objectc:LYQSKBAPP_OpenShareGeneral"]){
        [self LYQSKBAPP_OpenShareGeneral:rightUrl];
    }

    
    
    return YES;
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.navigationController showSGProgressWithDuration:5 andTintColor:[UIColor colorWithRed:80/255.0 green:218/255.0 blue:85/255.0 alpha:1] andTitle:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.navigationController cancelSGProgress];
    [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.navigationController cancelSGProgress];
}


//调用分享
- (void)LYQSKBAPP_OpenShareGeneral:(NSString *)urlStr{
    //创建正则表达式；pattern规则；
    NSLog(@"urlStr = %@", urlStr);
//    if ([urlStr myContainsString:@"?"]) {
//        urlStr = [urlStr componentsSeparatedByString:@"?"][0];
//        NSLog(@"...%@ ", urlStr);
//    }
    NSString * pattern = @"ShareGeneral(.+)";
    NSRegularExpression * regex = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
    
    //测试字符串；
    NSArray * result = [regex matchesInString:urlStr options:0 range:NSMakeRange(0,urlStr.length)];
    if (result.count) {
        //获取筛选出来的字符串
        NSString * resultStr = [urlStr substringWithRange:((NSTextCheckingResult *)result[0]).range];
        resultStr = [resultStr stringByReplacingOccurrencesOfString:@"ShareGeneral(" withString:@""];
        resultStr = [resultStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        resultStr = [resultStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", resultStr);
        self.shareInfo = [NSMutableDictionary dictionaryWithDictionary:[NSString parseJSONStringToNSDictionary:resultStr]];
        

        [[ShareHelper shareHelper]shareWithshareInfo:self.shareInfo andType:@"FromTypeMoneyTree" andPageUrl:self.webView.request.URL.absoluteString];
        NSLog(@"%@", self.shareInfo);
        [ShareHelper shareHelper].delegate = self;
    }
}




@end
