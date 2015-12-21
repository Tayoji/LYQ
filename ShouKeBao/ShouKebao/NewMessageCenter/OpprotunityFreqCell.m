//
//  OpprotunityFreqCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import "OpprotunityFreqCell.h"
#import "CustomDynamicModel.h"
#import "UIImageView+WebCache.h"
#import "ProductModal.h"
#import "NSString+FKTools.h"
#import "ChatViewController.h"
@interface OpprotunityFreqCell ()<UIWebViewDelegate>
{
    NSArray *_IMUserMatches;
}

@property (strong, nonatomic) IBOutlet UIWebView *WebStr;
@property (strong, nonatomic) IBOutlet UIImageView *diImage;
@property (strong, nonatomic) IBOutlet UILabel *diY;
@property (strong, nonatomic) IBOutlet UIImageView *liImage;
@property (strong, nonatomic) IBOutlet UILabel *liY;

@property (strong, nonatomic) IBOutlet UIImageView *songImage;
@property (strong, nonatomic) IBOutlet UILabel *songY;
@end

@implementation OpprotunityFreqCell

- (void)awakeFromNib {

}
-(void)layoutSubviews{
    self.WebStr.scrollView.scrollEnabled = NO;
    self.WebStr.scrollView.showsHorizontalScrollIndicator= NO;
    self.WebStr.scrollView.showsVerticalScrollIndicator= NO;
    self.WebStr.delegate = self;
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString * urlStr = request.URL.absoluteString;
    if ([urlStr myContainsString:@"Appevent_OpenIM"]) {
        [self openIM];
        return NO;
    }
    return YES;
}

-(void)setModel:(CustomDynamicModel *)model{

    _model = model;
    [self.HeadImage sd_setImageWithURL:[NSURL URLWithString:model.ProductdetailModel.PicUrl] placeholderImage:[UIImage imageNamed:@"customtouxiang"]];
    self.TitleImage.image = [UIImage imageNamed:@"dongtaichanpin"];
    self.TimerLabel.text = model.CreateTimeText;
    
    
    
    NSString *webviewText = @"<style>body{margin:0;background-color:transparent;font:14px/18px Custom-Font-Name}a:link { color: #ff0000;text-decoration:none; } a:visited { color: #ff0000;text-decoration:none; } a:hover { color: #ff0000;text-decoration:none; } a:active { color: #ff0000; text-decoration:none;}</style>";
    NSString *htmlString = [webviewText stringByAppendingFormat:@"%@", self.model.DynamicTitle];
    [self.WebStr loadHTMLString:htmlString baseURL:nil]; //在 WebView 中显示本地的字符串


    self.topTitleLab.text = model.DynamicTitle;
    self.DiLabel.text = model.ProductdetailModel.PersonAlternateCash;
    self.SongLabel.text = model.ProductdetailModel.SendCashCoupon;
    self.ProfitLabel.text = model.ProductdetailModel.PersonProfit;
    self.MenShiLabel.text = model.ProductdetailModel.PersonPrice;
    self.SameJobLabel.text = model.ProductdetailModel.PersonPeerPrice;
    self.NumberLabel.text = model.ProductdetailModel.Code;
    self.BodyLabel.text = model.ProductdetailModel.Name;
    NSLog(@"%@--%@--%@", model.ProductdetailModel.PersonCashCoupon, model.ProductdetailModel.PersonBackPrice, model.ProductdetailModel.PersonProfit);
    if (![model.ProductdetailModel.IsComfirmStockNow intValue]) {
        self.sandian.hidden = YES;
    }
    if ([model.ProductdetailModel.PersonCashCoupon isEqualToString:@""]) {
        self.diImage.hidden = YES;
        self.diY.hidden = YES;
    }
    if ([model.ProductdetailModel.PersonBackPrice isEqualToString:@""]) {
        self.songImage.hidden = YES;
        self.songY.hidden = YES;
    }
    if ([model.ProductdetailModel.PersonProfit isEqualToString:@""]) {
        self.liImage.hidden = YES;
        self.liY.hidden = YES;
    }
}
//跳转IM界面
-(void)openIM{
    NSLog(@"%@", self.model.AppSkbUserId);
    ChatViewController * charV = [[ChatViewController alloc]initWithChatter:self.model.AppSkbUserId conversationType:eConversationTypeChat];
    [self.NAV pushViewController:charV animated:YES];
}

@end
