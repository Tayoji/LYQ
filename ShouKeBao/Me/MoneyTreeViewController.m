//
//  MoneyTreeViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/7/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MoneyTreeViewController.h"
#import "MeHttpTool.h"
#import "BeseWebView.h"
#import <ShareSDK/ShareSDK.h>
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ShareHelper.h"
#import "NSString+FKTools.h"
@interface MoneyTreeViewController ()<UIWebViewDelegate, notiPopUpBox>
@property(nonatomic,weak) UILabel *warningLab;

@end

@implementation MoneyTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataSource];
    //self.navigationItem.leftBarButtonItem = leftItem;
    self.webView.delegate  = self;
}
#pragma mark - loadDataSource
- (void)loadDataSource
{
    [MeHttpTool getMeIndexWithParam:@{} success:^(id json) {
        if (json) {
            NSLog(@"-----%@",json);
            [self loadWithUrl:json[@"MoneyTreeUrl"]];
            self.linkUrl = json[@"MoneyTreeUrl"];
        }
    }failure:^(NSError *error){
        
    }];
}


-(void)setShateButtonHidden:(BOOL)hidden{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(shareIt:)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (hidden) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
    self.navigationItem.rightBarButtonItem = shareBarItem;
    }
}



#pragma mark - loadWebView
- (void)loadWithUrl:(NSString *)url
{
//        url = @"http://www.myie9.com/useragent/";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
//        NSLog(@"xxxxxx");
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }
    BOOL isNeedShareButton = [[self.webView stringByEvaluatingJavaScriptFromString:@"isShowShareButtonForApp()"]intValue];
    if (isNeedShareButton) {
        [self setShateButtonHidden:NO];
    }else{
        [self setShateButtonHidden:YES];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:webView.request.URL.absoluteString forKey:@"PageUrl"];
    NSLog(@"%@", dic);
    [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
        NSLog(@"-----分享返回数据json is %@------",json);
        NSString *str =  json[@"ShareInfo"][@"Desc"];
        //            [[[UIAlertView alloc]initWithTitle:str message:@"11" delegate:nil cancelButtonTitle:json[@"ShareInfo"][@"Url"] otherButtonTitles:nil, nil]show];
        if(str.length>1){
            // [self.shareInfo removeAllObjects];
            self.shareInfo = json[@"ShareInfo"];
            NSLog(@"%@99999", self.shareInfo);
            
        }
    } failure:^(NSError *error) {
        
        NSLog(@"分享请求数据失败，原因：%@",error);
    }];

    [super webViewDidFinishLoad:webView];
}


@end
