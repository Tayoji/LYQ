//
//  NewOpenExclusiveViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/12/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NewOpenExclusiveViewController.h"
#import "ExclusiveShareView.h"
#import "noOpenExclusiveAppView.h"
#import <ShareSDK/ShareSDK.h>
#import "StrToDic.h"
#import "ProductModal.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "IWHttpTool.h"
#import "ExclusiveViewController.h"
#import "WhatIsExclusiveViewController.h"
#define KHeight_Scale    [UIScreen mainScreen].bounds.size.height/480.0f
@interface NewOpenExclusiveViewController ()<UIScrollViewDelegate>
- (IBAction)returnButton:(id)sender;
- (IBAction)introduceButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *shareBackground;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVew;
@property (weak, nonatomic) IBOutlet UIImageView *squarenessView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *questionButton;

@end

@implementation NewOpenExclusiveViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"NewOpenExclusiveViewController"];
    self.navigationController.navigationBarHidden = YES;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"OpenAppGuide"] isEqualToString:@"1"]) {
        
    }else{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"OpenAppGuide"];
        [IWHttpTool WMpostWithURL:@"/Customer/OpenGiveCashRollAppLyq" params:nil success:^(id json) {
            if ([json[@"IsSuccess"] isEqualToString:@"1"]) {
                NSLog(@"请求成功");
            }
            
        } failure:nil];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"NewOpenExclusiveViewController"];
    if ([self.firstComeInFromGetcashClickBtn isEqualToString:@"zzm"]) {
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"Me_getCashSuccess" attributes:dict];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollVew.delegate = self;

    if ([self.ConsultanShareInfo count] == 0) {
         [self loadIsOpenAppDataTwince];
    }else{
         [self shareView];
    }
   
    if ([UIScreen mainScreen].bounds.size.height==667) {
        self.scrollVew.contentSize = CGSizeMake(0, self.view.frame.size.height+200);
    }else if ([UIScreen mainScreen].bounds.size.height == 480){
        self.scrollVew.contentSize = CGSizeMake(0, self.view.frame.size.height+100);
    }else{
        self.scrollVew.contentSize = CGSizeMake(0, self.view.frame.size.height+155*KHeight_Scale);
    }
   
   

}

//- (void)setBackButton:(UIButton *)backButton{
//    _backButton = backButton;
//    self.backButton.backgroundColor = [UIColor blackColor];
//    self.backButton.alpha = 0.3;
//    self.backButton.layer.masksToBounds = YES;
//    self.backButton.layer.cornerRadius = 3;
//}
//- (void)setQuestionButton:(UIButton *)questionButton{
//    _questionButton = questionButton;
//    self.questionButton.backgroundColor = [UIColor blackColor];
//    self.questionButton.alpha = 0.3;
//    self.questionButton.layer.masksToBounds = YES;
//    self.questionButton.layer.cornerRadius = 3;
//}

- (void)shareView{
    
    NSLog(@" _____________分享 %@", self.ConsultanShareInfo);
    NSDictionary *tmp = [StrToDic dicCleanSpaceWithDict:self.ConsultanShareInfo];
    //    ProductModal *model = _dataArr[0];
    //    NSDictionary *temp = [StrToDic dicCleanSpaceWithDict:model.ShareInfo];
    // NSDictionary *  tmp = @{@"Desc":@"aa", @"Pic":@"http://r.lvyouquan.cn/ppkImageCombo.aspx?w=120&f=http%3a%2f%2fr.lvyouquan.cn%2fKEPicFolder%2fdefault%2fattached%2fimage%2f20141031%2f20141031171258_5481.jpg",@"Title":@"dassda", @"Url":@"http://skb.lvyouquan.cn/mg/53af38b41b3440af83e2b4de5cfd094c/113d033a35a94e35b2b62527bc4208c4/Product/e74d6f2dea8444e09c214b5ad61f9771?source=share_app&viewsource=1&isshareapp=1&apptype=1&version=1.4.0.0&appuid=bdc45124fa474c7889414b55449e573e&substation=10"};

    //构造分享内容
    id<ISSContent>publishContent = [ShareSDK content:tmp[@"Desc"]
                                      defaultContent:tmp[@"Desc"]
                                               image:[ShareSDK imageWithUrl:tmp[@"Pic"]]
                                               title:tmp[@"Title"]
                                                 url:tmp[@"Url"]                                             description:tmp[@"Desc"]
                                           mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@",self.ConsultanShareInfo[@"Url"]] image:nil];
    
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", self.ConsultanShareInfo[@"Url"]]];
        [ExclusiveShareView shareWithContent:publishContent backgroundShareView:self.shareBackground naVC:self.naVC andUrl:tmp[@"Url"]];
}

#pragma mark - 加载数据
- (void)loadIsOpenAppDataTwince{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [IWHttpTool WMpostWithURL:@"/Business/GetMeIndex" params:dic success:^(id json) {
        NSLog(@"------是否专属的json is %@-------",json);

        [self.ConsultanShareInfo addEntriesFromDictionary:json[@"ConsultanShareInfo"]];
        [self shareView];
        
//        NSLog(@"///// %@", self.ConsultanShareInfo);
    } failure:^(NSError *error) {
        NSLog(@"接口请求失败 error is %@------",error);
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

- (IBAction)returnButton:(id)sender {
    ExclusiveViewController *exclusiveVC = [[ExclusiveViewController alloc]init];
    exclusiveVC.naV = self.naVC;
    exclusiveVC.ConsultanShareInfo = self.ConsultanShareInfo;
    NSLog(@"....%@", exclusiveVC.ConsultanShareInfo);
    [self.naVC pushViewController:exclusiveVC animated:NO];
    

}

- (IBAction)introduceButton:(id)sender {
    WhatIsExclusiveViewController *whatISExclisiveVC = [[WhatIsExclusiveViewController alloc]init];
    whatISExclisiveVC.url = @"http://m.lvyouquan.cn/App/AppExclusiveIntroduces";
    whatISExclisiveVC.naV = self.naVC;
    [self.naVC pushViewController:whatISExclisiveVC animated:YES];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }

    if (offset > 0) {
        
//        [self.squarenessView addSubview:self.backButton];
//        [self.squarenessView addSubview:self.questionButton];
        self.squarenessView.hidden = NO;
        self.squarenessView.alpha = offset*0.01;
        [self.view addSubview:self.backButton];
        [self.view addSubview:self.questionButton];
       
    }else{
        self.squarenessView.hidden = YES;
        [self.scrollVew addSubview:self.backButton];
        [self.scrollVew addSubview:self.questionButton];
    }
    
    
}
@end
