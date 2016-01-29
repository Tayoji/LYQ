//
//  ZhiVisitorDynamicController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/11.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ZhiVisitorDynamicController.h"
#import "NewCustomerCell.h"
#import "OpprotunityFreqCell.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h" 
#import "MJRefresh.h"
#import "CustomDynamicModel.h"
#import "NSString+FKTools.h"
#import "ProductModal.h"
#import "ProduceDetailViewController.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "VisitorDynamicNullView.h"
#import "RedPacketMainController.h"
#import <MessageUI/MessageUI.h>
#import "SetRedPacketController.h"
#import "CustomModel.h"
#define pageSize @"10"
//
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface ZhiVisitorDynamicController ()<UITableViewDelegate,UITableViewDataSource, NullViewDelegate, MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong)NSMutableArray * customDyamicArray;
@property (nonatomic, assign)int pageNum;
@property (nonatomic, assign)BOOL isDone;
@property (nonatomic, strong)VisitorDynamicNullView * nullView;
@property (nonatomic, strong)NSString * totalCount;


@property (nonatomic, strong)UIButton * backToTopBtn;
@end

@implementation ZhiVisitorDynamicController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [MobClick beginLogPageView:@"ZhiVisitorDynamicController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ZhiVisitorDynamicController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"客人动态";
    self.view.backgroundColor = [UIColor colorWithRed:(247.0/255.0) green:(247.0/255.0) blue:(247.0/255.0) alpha:1];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nullView];
    [self.view addSubview:self.backToTopBtn];
    self.backToTopBtn.hidden = NO;
    [self initPull];
}
-(NSMutableArray *)customDyamicArray{
    if (!_customDyamicArray) {
        _customDyamicArray = [NSMutableArray array];
    }
    return _customDyamicArray;
}

-(UIButton *)backToTopBtn{
    if (!_backToTopBtn) {
        _backToTopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _backToTopBtn.frame = CGRectMake(kScreenSize.width - 50, kScreenSize.height - 164, 30, 30);
        [_backToTopBtn setBackgroundImage:[UIImage imageNamed:@"shangjiana"] forState:UIControlStateNormal];
        [_backToTopBtn addTarget:self action:@selector(backTOTop) forControlEvents:UIControlEventTouchUpInside];
        _backToTopBtn.hidden = YES;
    }
    return _backToTopBtn;
}

- (void)loadDataSourceFrom:(int)type{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * params = @{};
    if (self.visitorDynamicFromType == VisitorDynamicTypeFromCustom) {
        NSLog(@"%@", self.AppSkbUserId.class);
        if ([self.AppSkbUserId isEqualToString:@""]) {
            self.AppSkbUserId = @"NOID";
        }
        params = @{@"PageIndex":[NSString stringWithFormat:@"%d", self.pageNum],@"PageSize":pageSize, @"AppSkbUserId":self.AppSkbUserId};
    }else if(self.visitorDynamicFromType == VisitorDynamicTypeFromMessageCenter){
        params = @{@"PageIndex":[NSString stringWithFormat:@"%d", self.pageNum],@"PageSize":pageSize};
    }
    [IWHttpTool postWithURL:@"Customer/GetCustomerDynamicList" params:params success:^(id json) {

        if ([json[@"IsSuccess"]integerValue]) {
            NSLog(@"%@", json);
            self.totalCount = json[@"TodayCount"];
            ((UILabel *)_tableView.tableHeaderView).text = [NSString stringWithFormat:@"今日动态数： %@", self.totalCount];
            if (self.pageNum*[pageSize integerValue]>[json[@"TotalCount"]integerValue]) {
                self.isDone = YES;
            }
            if (type == 1) {
                [self.customDyamicArray removeAllObjects];
            }
            for (NSDictionary * dic in json[@"AppCustomerDynamicList"]) {
                CustomDynamicModel *model = [CustomDynamicModel modelWithDic:dic];
                [self.customDyamicArray addObject:model];
            }
            //当从管客户进入客户动态里面，根据是否开通IM客户展示发红包或者邀请开通旅游顾问
            if (self.customDyamicArray.count==0) {
                if (self.visitorDynamicFromType == VisitorDynamicTypeFromCustom) {
                    if ([self.model.IsOpenIM isEqualToString:@"1"]) {
                        [self.nullView showNullViewToView:self.view Type:nullTypeSendRedPacket];
                    }else{
                        [self.nullView showNullViewToView:self.view Type:nullTyeInviteVisitor];
                    }
                }
            }else{
                [self.nullView hideNullViewFromView:self.view];
            }

        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadData];
        [self tableViewEndRefreshing];
    } failure:^(NSError * eror) {
    }];
}

#pragma mark - 刷新和分页
- (void)initPull{
    
    self.pageNum = 1;
    [self.tableView addHeaderWithTarget:self action:@selector(headRefish)dateKey:nil];
    [self.tableView headerBeginRefreshing];
    [self.tableView addFooterWithTarget:self action:@selector(foodRefish)];
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
    self.tableView.footerPullToRefreshText = @"上拉刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    [self loadDataSourceFrom:1];
}
-(void)headRefish{
    self.pageNum = 1;
    self.isDone = NO;
    [self loadDataSourceFrom:1];
}
- (void)foodRefish{
    self.pageNum++;
    if (self.isDone) {
        [self.tableView footerEndRefreshing];
    }else{
        [self loadDataSourceFrom:2];
    }
}
- (void)tableViewEndRefreshing{
    [self.tableView footerEndRefreshing];
    [self.tableView headerEndRefreshing];
}
#pragma mark - UITableViewDelegate&&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.customDyamicArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomDynamicModel * model = self.customDyamicArray[indexPath.section];
    NSLog(@"DynamicType=%@", model.DynamicType);
    return [self heightWithDynamicType:model];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.customDyamicArray.count) {
    CustomDynamicModel * model = self.customDyamicArray[indexPath.section];
    static NSString * str = @"NewCustomerCell";
    NewCustomerCell * cell =[tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    cell.model = model;
        if (self.visitorDynamicFromType == VisitorDynamicTypeFromCustom) {
            cell.NAV = self.NaV;
            cell.cellvisitorDynamicFromType = CellVisitorDynamicTypeFromCustom;
        }else{
            cell.NAV = self.navigationController;
            cell.cellvisitorDynamicFromType = CellVisitorDynamicTypeFromMessageCenter;
        }
    if (self.visitorDynamicFromType == VisitorDynamicTypeFromCustom) {
        cell.MessageButton.hidden = YES;
    }else if(self.visitorDynamicFromType == VisitorDynamicTypeFromMessageCenter){
        cell.MessageButton.hidden = NO;
    }
    return cell;
    }
    return nil;

}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, kScreenSize.width-20, kScreenSize.height-64) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"NewCustomerCell" bundle:nil] forCellReuseIdentifier:@"NewCustomerCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"OpprotunityFreqCell" bundle:nil] forCellReuseIdentifier:@"OpprotunityFreqCell"];
        _tableView.tableFooterView = [[UIView alloc] init];
        
        UILabel * topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 35)];
        topLable.font = [UIFont systemFontOfSize:14];
        topLable.textColor = [UIColor grayColor];
        topLable.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255 alpha:1.0];
        _tableView.tableHeaderView = topLable;
        
    }
    return _tableView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomDynamicModel * model = self.customDyamicArray[indexPath.section];
    NSLog(@"%@----%@----%@", model.DynamicType, model.DynamicContent,model.HeadUrl);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([model.DynamicType intValue] == 1||[model.DynamicType intValue] == 2){
        
    }else if([model.DynamicType intValue] == 3||[model.DynamicType intValue] == 9||[model.DynamicType intValue] == 11){
        
    }else if([model.DynamicType intValue] == 4||[model.DynamicType intValue] == 5||[model.DynamicType intValue] == 6||[model.DynamicType intValue] == 7||[model.DynamicType intValue] == 8||[model.DynamicType intValue] == 10){
//        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
//        [MobClick event:@"ShouKeBao_customerDynamicMessageListClick" attributes:dict];
//        
//        NSString * productUrl = model.ProductdetailModel.LinkUrl;
//        ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
//        NSLog(@"%@", productUrl);
//        detail.produceUrl = productUrl;
//        detail.fromType = FromZhiVisitorDynamic;
//        detail.shareInfo = model.ProductdetailModel.ShareInfo;
//        [self.navigationController pushViewController:detail animated:YES];
    }

}

//动态类型
//1直客绑定;2直客登录;3直客搜索产品;9直客验证留下电话号码-A;11绑定微信
//
//4直客浏览线路达二次;5直客浏览产品;6直客收藏产品;7直客分享产品;8点击在线预订未下单;10直客浏览产品留下手机号-C
- (float)heightWithDynamicType:(CustomDynamicModel *)model{
    if ([model.DynamicType intValue] == 1 || [model.DynamicType intValue] == 2||[model.DynamicType intValue] == 3||[model.DynamicType intValue] == 9||[model.DynamicType intValue]==11){
        return 72+[model.DynamicTitleV2 heigthWithsysFont:14 withWidth:self.tableView.frame.size.width - 20];
    }else{
        return 184+[model.DynamicTitleV2 heigthWithsysFont:14 withWidth:self.tableView.frame.size.width - 20];
    }
}


//没有客户动态的时候显示的界面
-(VisitorDynamicNullView *)nullView{
    if (!_nullView) {
        _nullView = [[VisitorDynamicNullView alloc]init];
        _nullView.delegate = self;
    }
    return _nullView;
}
//空界面邀请按钮点击
- (void)ClickInviteVisitor{
    NSLog(@"邀请");
    
//    MFMessageComposeViewController *MFMessageVC = [[MFMessageComposeViewController alloc] init];
//    MFMessageVC.body = self.InvitationInfo;
//    if (![NSString stringIsEmpty:self.model.Mobile]) {
//        MFMessageVC.recipients = @[self.model.Mobile];
//    }
//    MFMessageVC.messageComposeDelegate = self;
//    [self.NaV presentViewController:MFMessageVC animated:YES completion:nil];

    
        if([MFMessageComposeViewController canSendText]){// 判断设备能不能发送短信
//            [[[UIAlertView alloc]initWithTitle:@"aa" message:self.model.Mobile delegate:nil cancelButtonTitle:nil otherButtonTitles:@"enSUre", nil]show];
            MFMessageComposeViewController *MFMessageVC = [[MFMessageComposeViewController alloc] init];
            MFMessageVC.body = self.InvitationInfo;
            if (![NSString stringIsEmpty:self.model.Mobile]) {
                MFMessageVC.recipients = @[self.model.Mobile];
            }
            MFMessageVC.messageComposeDelegate = self;
            [self.NaV presentViewController:MFMessageVC animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"该设备不支持短信功能" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
    } else if (result == MessageComposeResultSent) {
        NSLog(@"已经发出");
    } else {
        NSLog(@"发送失败");
    }
}



//空界面发红包点击
- (void)ClickSendRedPacket{
    NSLog(@"发红包");
    SetRedPacketController *setRPacket = [[SetRedPacketController alloc] init];
    setRPacket.sendRedPacketType = sendRedPacketTypeCustom;
    setRPacket.NumOfPeopleArr = [NSMutableArray arrayWithObjects:self.AppSkbUserId, nil];
    [self.NaV pushViewController:setRPacket animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > self.tableView.frame.size.height) {
        self.backToTopBtn.hidden = NO;
    }else{
        self.backToTopBtn.hidden = YES;
    }
}
- (void)backTOTop{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
@end
