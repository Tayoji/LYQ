//
//  NewCustomerCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import "NewCustomerCell.h"
#import "CustomDynamicModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+FKTools.h"
#import "ChatViewController.h"

@interface NewCustomerCell ()<UIWebViewDelegate>
{
    NSArray *_IMUserMatches;
}

@property (strong, nonatomic) IBOutlet UIWebView *WebStr;

@end

@implementation NewCustomerCell
- (void)awakeFromNib {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openIM)];
    [self.TitleImage addGestureRecognizer:tap];
    // Initialization code
}
-(void)layoutSubviews{

    self.WebStr.scrollView.scrollEnabled = NO;
    self.WebStr.scrollView.showsHorizontalScrollIndicator= NO;
    self.WebStr.scrollView.showsVerticalScrollIndicator= NO;
    self.WebStr.delegate = self;

}
-(void)setModel:(CustomDynamicModel *)model{
    _model = model;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.HeadUrl] placeholderImage:[UIImage imageNamed:@"customtouxiang"]];
    if ([model.DynamicType intValue]==1) {
        self.TitleImage.image = [UIImage imageNamed:@"dongtaixin"];
    }else if([model.DynamicType intValue]==2){
        self.TitleImage.image = [UIImage imageNamed:@"dongtaizhanghu"];
    }else {
        self.TitleImage.image = [UIImage imageNamed:@"dongtaichanpin"];
    }
    self.TimeLabel.text = model.CreateTimeText;
    
    //设置webView样式
    NSString *webviewText = @"<style>body{margin:0;background-color:transparent;font:14px/18px Custom-Font-Name}a:link { color: #507daf;text-decoration:none; } a:visited { color: #507daf;text-decoration:none; } a:hover { color: #507daf;text-decoration:none; } a:active { color: #507daf; text-decoration:none;}</style>";
    NSString *htmlString = [webviewText stringByAppendingFormat:@"%@", self.model.DynamicTitle];
    [self.WebStr loadHTMLString:htmlString baseURL:nil]; //在 WebView 中显示本地的字符串
    
    self.custNameLabel.text = model.NickName;
    self.custNumLabel.text = model.CustomerMobile;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString * urlStr = request.URL.absoluteString;
    if ([urlStr myContainsString:@"Appevent_OpenIM"]) {
        [self openIM];
        return NO;
    }
    return YES;
}
//跳转IM界面
-(void)openIM{
    NSLog(@"%@", self.model.AppSkbUserId);
    ChatViewController * charV = [[ChatViewController alloc]initWithChatter:self.model.AppSkbUserId conversationType:eConversationTypeChat];
    [self.NAV pushViewController:charV animated:YES];
}
@end
