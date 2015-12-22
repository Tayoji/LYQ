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
    
    if ([self.formType isEqualToString:@"QRCodeAddress"]) {
        self.introduceExclusiveAppTitle.text = @"我的店铺二维码";
    }

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

- (void)setshareBarItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = shareBarItem;
}

-(void)shareAction:(UIButton *)btn{
    
    NSDictionary *shareDic = [NSDictionary dictionary];
//    shareDic = [StrToDic dicCleanSpaceWithDict:[self.shareArr lastObject]];
    if (!shareDic.count) {
        return;
    }
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareDic[@"Desc"]
                                       defaultContent:shareDic[@"Desc"]
                                                image:[ShareSDK imageWithUrl:shareDic[@"Pic"]]
                                                title:shareDic[@"Title"]
                                                  url:shareDic[@"Url"]                                  description:shareDic[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@",shareDic[@"Url"]] image:nil];
    NSLog(@"%@444", shareDic);
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", shareDic[@"Url"]]];
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:btn  arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                [self.warningLab removeFromSuperview];
                                if (state == SSResponseStateSuccess)
                                {
                                    
                                    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
                                    [postDic setObject:@"0" forKey:@"ShareType"];
                                    if (shareDic[@"Url"]) {
                                        [postDic setObject:shareDic[@"Url"]  forKey:@"ShareUrl"];
                                    }
                                    [postDic setObject:self.webView.request.URL.absoluteString forKey:@"PageUrl"];
                                    if (type ==ShareTypeWeixiSession) {
                                        
                                    }else if(type == ShareTypeQQ){
                                        
                                    }else if(type == ShareTypeQQSpace){
                                        
                                    }else if(type == ShareTypeWeixiTimeline){
                                    }                                    //产品详情
                                    if (type == ShareTypeCopy) {
                                        [MBProgressHUD showSuccess:@"复制成功"];
                                    }else{
                                        [MBProgressHUD showSuccess:@"分享成功"];
                                    }
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                                        [MBProgressHUD hideHUD];
                                    });
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }else if (state == SSResponseStateCancel){
                                    
                                }
                            }];
    
    NSLog(@"%@",shareDic[@"Url"]);
    [self addAlert];
    
}

-(void)addAlert{
    NSArray *windowArray = [UIApplication sharedApplication].windows;
    UIWindow *actionWindow = (UIWindow *)[windowArray lastObject];
    // 以下就是不停的寻找子视图，修改要修改的
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat labY = 180;
    if (screenH == 667) {
        labY = 260;
    }else if (screenH == 568){
        labY = 160;
    }else if (screenH == 480){
        labY = 180;
    }else if (screenH == 736){
        labY = 440;
    }
    CGFloat labW = [[UIScreen mainScreen] bounds].size.width;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH, labW, 30)];
    lab.text = @"您分享出去的内容对外只显示门市价";
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [actionWindow addSubview:lab];
    [UIView animateWithDuration:0.38 animations:^{
        lab.transform = CGAffineTransformMakeTranslation(0, labY-screenH - 8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.17 animations:^{
            lab.transform = CGAffineTransformMakeTranslation(0, labY-screenH);
        }];
    }];
    self.warningLab = lab;
    
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
