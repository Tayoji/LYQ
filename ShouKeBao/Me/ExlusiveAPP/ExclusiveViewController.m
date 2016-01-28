//
//  ExclusiveViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ExclusiveViewController.h"
#import "ExclusiveTableViewCell.h"
#import <ShareSDK/ShareSDK.h>
#import "NSString+FKTools.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MeShareDetailModel.h"
#import "textStyle.h"
#import "Customers.h"
#import "MoreLvYouGuWenInfoViewController.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "NewOpenExclusiveViewController.h"
//#import "WhatIsExclusiveViewController.h"
#import "CircleHotNewsViewController.h"
#import "ProduceDetailViewController.h"
#import "ShareHelper.h"
#import "SelectCustomerController.h"
#define foureSize ([UIScreen mainScreen].bounds.size.height == 480)
#define fiveSize ([UIScreen mainScreen].bounds.size.height == 568)
#define sixSize ([UIScreen mainScreen].bounds.size.height == 667)
#define sixPSize ([UIScreen mainScreen].bounds.size.height > 668)
#define fiveHight self.view.frame.size.height/480
#define kScreenSize [UIScreen mainScreen].bounds.size
#define gap 5
@interface ExclusiveViewController ()<UITableViewDataSource, UITableViewDelegate, notiPopUpBox>
//头部
@property (weak, nonatomic) IBOutlet UIImageView *HeadImageViewSet;
@property (weak, nonatomic) IBOutlet UILabel *builtLable;
@property (weak, nonatomic) IBOutlet UILabel *penpleL;

- (IBAction)clickAdvisorToComeInLvYouGuWen:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *customerCount;
@property (weak, nonatomic) IBOutlet UIButton *adviserBtn;
//table中间
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

//专属App
- (IBAction)touchExclusiveAppButton:(id)sender;
//分享

- (IBAction)returnButton:(id)sender;
- (IBAction)shareButton:(id)sender;

@property (nonatomic, copy)NSString *IsBinding;
@property (nonatomic,strong) UIView *guideView;
@property (nonatomic,strong) UIImageView *guideImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImage;
@property (weak, nonatomic) IBOutlet UIImageView *pointImage;
@property (weak, nonatomic) IBOutlet UIView *tapView;

@property (nonatomic, strong)UIView *redDot;
@property (nonatomic,weak) UILabel *warningLab;
@property (nonatomic, copy)NSString *QRCodeAddress;

@end

@implementation ExclusiveViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [MobClick beginLogPageView:@"Me_ExclusiveViewController"];
     self.navigationController.navigationBarHidden = YES;
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"QRredDot_QRCode"]){
        _redDot.hidden = YES;
    }
     [self.view addSubview:self.returnBtn];
     [self.view addSubview:self.titleL];
     [self.view addSubview:self.shareBtn];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Me_ExclusiveViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.view.backgroundColor = [UIColor colorWithRed:204/225.0f green:204/225.0f blue:204/225.0f alpha:1];
    
    [self loadExclusiveAppData];
    [self redDot];
    
    [self.QRCodeImage addSubview:_redDot];
    
//    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"redDot_QRCodes"]){
//        _redDot.hidden = YES;
//    }

    [self setHeaderImageView];
    [self setQRCodeImage];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *SKBMeGuide = [def objectForKey:@"NewMegwGuide"];
    if ([SKBMeGuide integerValue] != 1) {// 是否第一次打开app
        //这里需要 等级顾问登记区别
        [self Guide];
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCustomerLableToComeInCustomer:)];
    [self.customerCount addGestureRecognizer:tap];
    
}
//第一次开机引导
-(void)Guide
{
    self.guideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _guideView.backgroundColor = [UIColor blackColor];
    _guideView.alpha = 0.5;
    self.guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, kScreenSize.height/12, kScreenSize.width-60, kScreenSize.height/3+kScreenSize.height/3)];
    self.guideImageView.userInteractionEnabled = YES;
    [_guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
    self.guideImageView.image = [UIImage imageNamed:@"OneKeyShare"];//OneKeyShare
    
    UIButton *shareBtn = [[UIButton alloc] init];
    if (foureSize) {
        shareBtn.frame = CGRectMake((_guideImageView.frame.size.width-_guideImageView.frame.size.width/3)/2, _guideImageView.frame.size.height-55, _guideImageView.frame.size.width/3, 40);
    }else{
        shareBtn.frame = CGRectMake((_guideImageView.frame.size.width-_guideImageView.frame.size.width/3)/2, _guideImageView.frame.size.height-70, _guideImageView.frame.size.width/3, 40);
    }
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"AnomalyBg"] forState:UIControlStateNormal];
    [shareBtn setTitle:@"一键分享" forState:UIControlStateNormal];
    shareBtn.tag = 1011;
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_guideImageView addSubview:shareBtn];
    
    NSUserDefaults *guideDefault = [NSUserDefaults standardUserDefaults];
    [guideDefault setObject:@"1" forKey:@"NewMegwGuide"];
    [guideDefault synchronize];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:_guideView];
    [[[UIApplication sharedApplication].delegate window] addSubview:_guideImageView];
}
-(void)click
{
    CATransition *an1 = [CATransition animation];
    an1.type = @"rippleEffect";
    an1.subtype = kCATransitionFromRight;//用kcatransition的类别确定cube翻转方向
    an1.duration = 0.2;
    [self.guideImageView.layer addAnimation:an1 forKey:nil];
    [self.guideView removeFromSuperview];
    [self.guideImageView removeFromSuperview];
    
}


#pragma mark - tableView-delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExclusiveTableViewCell *cell = [ExclusiveTableViewCell cellWithTableView:tableView];
    
    MeShareDetailModel *model = _dataArray[indexPath.row];
    cell.model = model;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.frame.size.height;
}

#pragma mark - 数据请求
- (void)loadExclusiveAppData{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [IWHttpTool WMpostWithURL:@"/Customer/GetAppStatisticalInformationData" params:dic success:^(id json) {
            
            [self setCustomerCount:self.customerCount str:json[@"InstalledTotal"]];
            NSLog(@"------专属App的json is %@-------",json);
            
            self.QRCodeAddress = json[@"QRCodeAddress"];
            if (self.ConsultanShareInfo.count == 0) {
                [self.ConsultanShareInfo addEntriesFromDictionary:json[@"ConsultanShareInfo"]];
            }
            
            self.IsBinding = json[@"IsBinding"];
            [self setHeaderWith:json[@"AdvisorRank"]];
                MeShareDetailModel *model = [MeShareDetailModel shareDetailWithDict:json];
                [self.dataArray addObject:model];
            NSLog(@"dataArrray = %@", self.dataArray);
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"接口请求失败 error is %@------",error);
        }];
}

//- (void)loadIsOpenAppDataThree{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [IWHttpTool WMpostWithURL:@"/Business/GetMeIndex" params:dic success:^(id json) {
//        [self.ConsultanShareInfo addEntriesFromDictionary:json[@"ConsultanShareInfo"]];
//    } failure:^(NSError *error) {
//    }];
//}


- (void)setCustomerCount:(UILabel *)customerCount str:(NSString *)string{
    UILabel *ll = [[UILabel alloc]initWithFrame:CGRectMake(50, 120*fiveHight, self.view.frame.size.width-100, 50*fiveHight)];
    ll.textAlignment = NSTextAlignmentCenter;
    ll.textColor = [UIColor whiteColor];
    ll.font = [UIFont boldSystemFontOfSize:25];
    [self.HeadImageViewSet addSubview:ll];
     _customerCount = ll;
     NSString *str = [NSString stringWithFormat:@"%@人", string];
    [textStyle textStyleLabel:_customerCount text:str FontNumber:50.0f*fiveHight AndRange:NSMakeRange(0, str.length-1) AndColor:[UIColor whiteColor]];
}

- (void)setQRCodeImage{
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushQRCodeVC)];
//    [self.QRCodeImage addGestureRecognizer:tap1];
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushQRCodeVC)];
//    [self.pointImage addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushQRCodeVC)];
        [self.tapView addGestureRecognizer:tap];
    
}

- (void)setHeaderWith:(NSString *)rank{
    switch ([rank integerValue]) {
        case 1000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"jianxi"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"见习顾问" forState:UIControlStateNormal];    
            break;
        case 2000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"tongpai"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"铜牌顾问" forState:UIControlStateNormal];
            break;
        case 3000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"yinpai"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"银牌顾问" forState:UIControlStateNormal];
            break;
        case 4000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"huangjin"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"黄金顾问" forState:UIControlStateNormal];
            break;
        case 5000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"baijin"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"白金顾问" forState:UIControlStateNormal];
            break;
        case 6000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"zuanshi"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"钻石顾问" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}




- (void)setRightShareBarItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = shareBarItem;
}
- (void)setHeaderImageView{
    [self.view addSubview:self.HeadImageViewSet];
    [self.HeadImageViewSet addSubview:self.builtLable];
    [self.HeadImageViewSet addSubview:self.penpleL];
    [self.HeadImageViewSet addSubview:self.customerCount];
    [self.HeadImageViewSet addSubview:self.adviserBtn];
    [self.HeadImageViewSet addSubview:self.QRCodeImage];
    [self.HeadImageViewSet addSubview:self.pointImage];
    [self.HeadImageViewSet addSubview:self.tapView];
    
}


-(void)shareAction:(UIButton *)button{
    if (button.tag == 1011) {
        [self.guideImageView removeFromSuperview];
        [self.guideView removeFromSuperview];
    }
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"Me_exclusiveAppShareBtnClick" attributes:dict];
    
    NSLog(@"... %@", self.ConsultanShareInfo);
    if (!self.ConsultanShareInfo.count) {
        return;
    }
    [[ShareHelper shareHelper]shareWithshareInfo:self.ConsultanShareInfo andType:@"Me_exclusiveAppShareScccessCount" andPageUrl:self.ConsultanShareInfo[@"Url"]];
    [ShareHelper shareHelper].delegate = self;
    
    
    
//    NSLog(@"____nnn  self.shareInfo = %@", self.ConsultanShareInfo);
//    id<ISSContent> publishContent = [ShareSDK content:self.ConsultanShareInfo[@"Desc"]
//                                       defaultContent:self.ConsultanShareInfo[@"Desc"]
//                                                image:[ShareSDK imageWithUrl:self.ConsultanShareInfo[@"Pic"]]
//                                                title:self.ConsultanShareInfo[@"Title"]
//                                                  url:self.ConsultanShareInfo[@"Url"]                                  description:self.ConsultanShareInfo[@"Desc"]
//                                            mediaType:SSPublishContentMediaTypeNews];
//    
//    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@",self.ConsultanShareInfo[@"Url"]] image:nil];
//    NSLog(@"%@444", self.ConsultanShareInfo);
//    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", self.ConsultanShareInfo[@"Url"]]];
//    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:button arrowDirect:UIPopoverArrowDirectionUp];
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                         [self.warningLab removeFromSuperview];
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
//                                    [MobClick event:@"Me_exclusiveAppShareScccessCount" attributes:dict];
//
//                                    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
//                                    [postDic setObject:@"0" forKey:@"ShareType"];
//                                    if (self.ConsultanShareInfo[@"Url"]) {
//                                        [postDic setObject:self.ConsultanShareInfo[@"Url"]  forKey:@"ShareUrl"];
//                                    }
//                                    if (type ==ShareTypeWeixiSession) {
//                                        
//                                    }else if(type == ShareTypeQQ){
//                                        
//                                    }else if(type == ShareTypeQQSpace){
//                                        
//                                    }else if(type == ShareTypeWeixiTimeline){
//                                    }
//
//                                    if (type == ShareTypeCopy) {
//                                        [MBProgressHUD showSuccess:@"复制成功"];
//                                    }else{
//                                        [MBProgressHUD showSuccess:@"分享成功"];
//                                    }
//                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
//                                        [MBProgressHUD hideHUD];
//                                    });
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                }else if (state == SSResponseStateCancel){
//                                    
//                                }
//                            }];
//    [self addAlert];
//    
}

//选择客人
- (void)pushChoseCustomerView:(NSString *)productJsonStr{
    SelectCustomerController *selectVC = [[SelectCustomerController alloc]init];
    selectVC.productJsonString = productJsonStr;
    selectVC.FromWhere = FromeExclusive;
    [self.navigationController pushViewController:selectVC animated:YES];
}


//
//-(void)addAlert{
//    NSArray *windowArray = [UIApplication sharedApplication].windows;
//    UIWindow *actionWindow = (UIWindow *)[windowArray lastObject];
//    // 以下就是不停的寻找子视图，修改要修改的
//    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
//    CGFloat labY = 180;
//    if (screenH == 667) {
//        labY = 260;
//    }else if (screenH == 568){
//        labY = 160;
//    }else if (screenH == 480){
//        labY = 180;
//    }else if (screenH == 736){
//        labY = 440;
//    }
//    CGFloat labW = [[UIScreen mainScreen] bounds].size.width;
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH, labW, 30)];
//    lab.text = @"分享您的专属APP";
//    lab.textColor = [UIColor blackColor];
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.font = [UIFont systemFontOfSize:12];
//    [actionWindow addSubview:lab];
//    [UIView animateWithDuration:0.38 animations:^{
//        lab.transform = CGAffineTransformMakeTranslation(0, labY-screenH - 8);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.17 animations:^{
//            lab.transform = CGAffineTransformMakeTranslation(0, labY-screenH);
//        }];
//    }];
//        self.warningLab = lab;
//    
//}

#pragma mark - 初始化
-(UIView *)redDot{
    if (!_redDot) {
        _redDot = [[UIView alloc]initWithFrame:CGRectMake(22, -2, 6, 6)];
        _redDot.backgroundColor = [UIColor redColor];
        _redDot.layer.cornerRadius = 3.0;
        _redDot.layer.masksToBounds = YES;
    }
    return _redDot;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableDictionary *)ConsultanShareInfo{
    if (!_ConsultanShareInfo) {
        _ConsultanShareInfo = [NSMutableDictionary dictionary];
    }
    return _ConsultanShareInfo;
}
//- (NSMutableDictionary *)ConsultanShareInfoApp{
//    if (!_ConsultanShareInfoApp) {
//        _ConsultanShareInfoApp = [NSMutableDictionary dictionary];
//    }
//    return _ConsultanShareInfoApp;
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

#pragma mark - 点击事件
- (IBAction)touchExclusiveAppButton:(id)sender {
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"Me_openedExclusiveAppIntroduction" attributes:dict];
    
    NewOpenExclusiveViewController *estableshedVC = [[NewOpenExclusiveViewController alloc]init];
    estableshedVC.title = @"专属APP";
    estableshedVC.isExclusiveCustomer = self.IsBinding;
    NSLog(@"。。。。 %@", self.ConsultanShareInfo);
    estableshedVC.ConsultanShareInfo = self.ConsultanShareInfo;
    estableshedVC.naVC = self.navigationController;
    [self.navigationController pushViewController:estableshedVC animated:YES];
    
}
-(void)back{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)clickAdvisorToComeInLvYouGuWen:(id)sender {
    
    MoreLvYouGuWenInfoViewController * morelvyouguwen = [[MoreLvYouGuWenInfoViewController alloc]init];
    morelvyouguwen.webTitle = @"旅游顾问";
    [self.navigationController pushViewController:morelvyouguwen animated:YES];
}
- (IBAction)returnButton:(id)sender {
    [self back];
}

- (void)clickCustomerLableToComeInCustomer:(UITapGestureRecognizer *)tap{
    Customers *customerVC = [[Customers alloc]init];
    customerVC.customerType = 2;
    customerVC.isMe = 1;
    [self.navigationController pushViewController:customerVC animated:YES];
    
}
- (void)pushQRCodeVC{
//    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
//    [MobClick event:@"Me_exclusiveAppDataQR" attributes:dict];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"QRredDot_QRCode"];
//    CircleHotNewsViewController *WRCodeVC = [[CircleHotNewsViewController alloc]init];
    ProduceDetailViewController *WRCodeVC = [[ProduceDetailViewController alloc]init];
    WRCodeVC.m = 1;
    WRCodeVC.produceUrl = self.QRCodeAddress;
//    WRCodeVC.formTypeExclusive = @"QRCodeAddress";
    WRCodeVC.titleName = @"QRCodeAddress";
    if (self.QRCodeAddress) {
        [self.navigationController pushViewController:WRCodeVC animated:YES];
    }
}

- (IBAction)shareButton:(id)sender {
//    if ([self.ConsultanShareInfo count] == 0) {
//        [self loadIsOpenAppDataThree];
//    }
     [self shareAction:sender];
}
@end
