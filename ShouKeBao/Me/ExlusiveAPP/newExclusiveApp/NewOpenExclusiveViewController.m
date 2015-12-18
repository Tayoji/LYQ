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
@interface NewOpenExclusiveViewController ()
- (IBAction)returnButton:(id)sender;
- (IBAction)introduceButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *shareBackground;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVew;

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


- (void)shareView{
    
    NSLog(@" _____________分享 %@", self.ConsultanShareInfo);
    NSDictionary *tmp = [StrToDic dicCleanSpaceWithDict:self.ConsultanShareInfo];
    //    ProductModal *model = _dataArr[0];
    //    NSDictionary *temp = [StrToDic dicCleanSpaceWithDict:model.ShareInfo];
    
    //构造分享内容
    id<ISSContent>publishContent = [ShareSDK content:tmp[@"Desc"]
                                      defaultContent:tmp[@"Desc"]
                                               image:[ShareSDK imageWithUrl:tmp[@"Pic"]]
                                               title:tmp[@"Title"]
                                                 url:tmp[@"Url"]                                             description:tmp[@"Desc"]
                                           mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@",self.ConsultanShareInfo[@"Url"]] image:nil];
    
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", self.ConsultanShareInfo[@"Url"]]];
    
    NSLog(@"....//// url = %@", tmp[@"Url"]);
    
    [ExclusiveShareView shareWithContent:publishContent backgroundShareView:self.shareBackground naVC:self.naVC andUrl:tmp[@"Url"]];
}

#pragma mark - 加载数据
- (void)loadIsOpenAppDataTwince{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [IWHttpTool WMpostWithURL:@"/Business/GetMeIndex" params:dic success:^(id json) {
        NSLog(@"------是否专属的json is %@-------",json);

        [self.ConsultanShareInfo addEntriesFromDictionary:json[@"ConsultanShareInfo"]];
        [self shareView];
        
        NSLog(@"///// %@", self.ConsultanShareInfo);
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
    whatISExclisiveVC.naV = self.naVC;
    [self.naVC pushViewController:whatISExclisiveVC animated:YES];
    
}
@end
