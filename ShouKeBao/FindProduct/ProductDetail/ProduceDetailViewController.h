//
//  ProduceDetailViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
#import "BeseWebView.h"
#import "NewExclusiveAppIntroduceViewController.h"
#import "Customers.h"
typedef void (^CancelLeaveShare)(UINavigationController *na);
@class DayDetail;
@class yesterDayModel;
//@class BeseWebView;
typedef enum{
    FromQRcode,
    FromRecommend,
    FromStore,
    FromProductSearch,
    FromFindProduct,
    FromHotProduct,
    FromScanHistory,
    FromZhiVisitorDynamic
}JumpinFrom;
@protocol notiQRCToStartRuning<NSObject>
-(void)notiQRCToStartRuning;
@end
@interface ProduceDetailViewController : SKViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//@property (nonatomic, assign)BOOL isQRcode;
//@property (nonatomic, assign)BOOL isRecommend;
@property (nonatomic) NSInteger m;
@property (nonatomic, assign)JumpinFrom fromType;
@property (nonatomic, strong)NSMutableDictionary * shareInfo;
@property (nonatomic, assign)BOOL noShareInfo;
@property (copy,nonatomic) NSString *produceUrl;
@property (copy, nonatomic)NSString * titleName;
@property (copy,nonatomic) NSString *productName;
@property (nonatomic, strong) DayDetail *detail;
@property (nonatomic,copy) CancelLeaveShare canCelLeaveShare;
@property (nonatomic , strong)yesterDayModel *detail2;
@property(nonatomic,weak) id<notiQRCToStartRuning>delegate;


//弹出框
@property (strong, nonatomic) IBOutlet UIView *defineBox;
- (IBAction)cancleDefineBox:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *applyOpenVip;
- (IBAction)applyForOpenVip:(id)sender;
@property (nonatomic, copy)NSString *productId;



-(void)shareIt:(id)sender;

-(void)CancelLeaveShareBlock:(UINavigationController *)uinav;
//轮播
//@property (nonatomic, copy)NSString *CircleUrl;
@property (nonatomic, strong)UINavigationController *naV;
//专属App二维码
@property (nonatomic, copy)NSString *formTypeExclusive;

- (void)notiPopUpBoxView;
@end
