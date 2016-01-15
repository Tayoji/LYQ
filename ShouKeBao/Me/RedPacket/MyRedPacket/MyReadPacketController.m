//
//  MyReadPacketController.m
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/8.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "MyReadPacketController.h"
#import "UIImageView+WebCache.h"
#import "UserInfo.h"
#import "IWHttpTool.h"
#import "MyRedPacketCell.h"
#import "MyRedPDetailController.h"
#import "RuleWebViewController.h"
#import "UIScrollView+MJRefresh.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface MyReadPacketController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *DataArr;
@property (nonatomic,strong) NSMutableArray *MainIDArr;//MainIDs
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic,assign) int pageIndex;
@property (nonatomic, assign)BOOL isRefresh;

@property (nonatomic) UILabel *UserInfoName;//名字
@property (nonatomic) UILabel *GetTotalPriceLabel;//总金额
@property (nonatomic) UILabel *AllCountLabel;//发出红包
@property (nonatomic) UILabel *GetTotalCountLabel;//被领红包
@property (nonatomic) UILabel *UseTotalCount;//被用红包

@end

@implementation MyReadPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    self.isRefresh = YES;
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的红包";
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavTest"] forBarMetrics:UIBarMetricsDefault];
    //填充用户信息
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLYGWHeaderPic]]];
    self.UserInfoName.text = [NSString stringWithFormat:@"%@共发出",[[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKeyLYGWName]];
    [self.view addSubview:self.tableView];
//    [self creatNavOfRight];
    [self loadDataSource];
    [self iniHeader];
}
#pragma mark - 刷新
-(void)iniHeader
{       //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headRefresh) dateKey:nil];
    //上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
    //设置文字
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
}
-(void)headRefresh
{
    if (self.isRefresh) {
        self.isRefresh = NO;
        self.pageIndex = 1;
        [self  loadDataSource];
    }
    
}
-(void)footRefresh
{
        self.pageIndex ++;
        [self loadDataSource];
}
-(void)loadDataSource{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
    [dic setValue:@"10" forKey:@"pageSize"];
    [dic setValue:@"2" forKey:@"LuckMoneyType"];
    [IWHttpTool WMpostWithURL:@"/Customer/GetAppLuckMoneyDetailCount" params:dic success:^(id json) {
        
        NSLog(@"-------------------我的红包信息:%@------------------",json);
        if (!self.isRefresh) {
            self.isRefresh = YES;
            [self.DataArr removeAllObjects];
        }
        if (![json[@"GetTotalPrice"]  isEqual: @""]) {
            self.GetTotalPriceLabel.text = json[@"GetTotalPrice"];
        }
        if (![json[@"AllCount"]  isEqual: @""]) {
            self.AllCountLabel.text = json[@"AllCount"];
        }
        if (![json[@"GetTotalCount"]  isEqual: @""]) {
            self.GetTotalCountLabel.text = json[@"GetTotalCount"];
        }
        if (![json[@"GetTotalPrice"]  isEqual: @""]) {
            self.UseTotalCount.text = json[@"GetTotalPrice"];
        }
        NSArray *listArr = json[@"AppLuckMoneyDetailList"];
        for (NSDictionary *dic in listArr) {
            [self.MainIDArr addObject:[dic objectForKey:@"AppLuckMoneyMainId"]];
            [self.DataArr addObject:dic];
            
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}
//-(void)creatNavOfRight{
//    UIButton *myBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    [myBtn setImage:[UIImage imageNamed:@"RedPacketHelp"] forState:UIControlStateNormal];
//    myBtn.tag = 106;
//    [myBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:myBtn];
//    self.navigationItem.rightBarButtonItem = item;
//}
//-(void)BtnClick:(UIButton *)button{
//    NSLog(@"又是问号");
//    RuleWebViewController *cont = [[RuleWebViewController alloc] init];
//    cont.webTitle = @"红包规则介绍";
//    cont.linkUrl = @"http://m.lvyouquan.cn/App/AppLuckMoneyRule";
//    [self.navigationController pushViewController:cont animated:YES];
//}
#pragma mark - UITableViewDataSource&&UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyRedPacketCell *   cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRedPacketCell" owner:nil options:nil]firstObject];
    NSDictionary *dic = self.DataArr[indexPath.row];
    cell.TitleLabel.text = [dic objectForKey:@"Title"];
    cell.DataTimeLabel.text = [dic objectForKey:@"DateTime"];
    cell.PriceLabel.text = [dic objectForKey:@"PriceTotal"];
    cell.LuckContent.text = [dic objectForKey:@"LuckContent"];
    cell.mixLabel.text = [NSString stringWithFormat:@"%@/%@个",[dic objectForKey:@"GetCount"],[dic objectForKey:@"UnGetCount"]];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyRedPDetailController *detail = [[MyRedPDetailController alloc] init];
//    detail.MainString = self.MainIDArr[indexPath.row];
//    detail.lastData = self.DataArr[indexPath.row];
    detail.MainIDsStr =[self.DataArr[indexPath.row] objectForKey:@"AppLuckMoneyMainId"];
    [self.navigationController pushViewController:detail animated:YES];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 80;
        //头视图
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 300)];
        view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1];
        [view addSubview:self.imageview];
        [view addSubview:self.UserInfoName];
        [view addSubview:self.GetTotalPriceLabel];
        [view addSubview:self.AllCountLabel];
        
        UILabel *DownLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 260, 80, 35)];
        DownLabel1.textAlignment = NSTextAlignmentCenter;
        DownLabel1.font = [UIFont systemFontOfSize:20];
        DownLabel1.textColor = [UIColor lightGrayColor];
        DownLabel1.text = @"发出红包";
        [view addSubview:DownLabel1];
        [view addSubview:self.GetTotalCountLabel];
        
        UILabel *DownLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2-40, 260, 80, 35)];
        DownLabel2.textAlignment = NSTextAlignmentCenter;
        DownLabel2.font = [UIFont systemFontOfSize:20];
        DownLabel2.textColor = [UIColor lightGrayColor];
        DownLabel2.text = @"被领红包";
        [view addSubview:DownLabel2];
        [view addSubview:self.UseTotalCount];
        
        UILabel *DownLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width-30-80, 260, 80, 35)];
        DownLabel3.textAlignment = NSTextAlignmentCenter;
        DownLabel3.font = [UIFont systemFontOfSize:20];
        DownLabel3.textColor = [UIColor lightGrayColor];
        DownLabel3.text = @"被用红包";
        [view addSubview:DownLabel3];
        _tableView.tableHeaderView = view;
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

-(UIImageView *)imageview{
    if (!_imageview) {
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width/2-55, 15, 110, 110)];
        _imageview.backgroundColor = [UIColor lightGrayColor];
        _imageview.layer.masksToBounds = YES;
        _imageview.layer.cornerRadius = 55;
    }
    return _imageview;
}
-(UILabel *)UserInfoName{
    if (!_UserInfoName) {
        _UserInfoName = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2-80, 130, 160, 30)];
        _UserInfoName.textAlignment = NSTextAlignmentCenter;
        _UserInfoName.font = [UIFont systemFontOfSize:18];
        _UserInfoName.textColor = [UIColor lightGrayColor];
    }
    return _UserInfoName;
}
-(UILabel *)GetTotalPriceLabel{
    if (!_GetTotalPriceLabel) {
        _GetTotalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2-100, 170, 200, 30)];
        _GetTotalPriceLabel.font = [UIFont systemFontOfSize:30];
        _GetTotalPriceLabel.textAlignment = NSTextAlignmentCenter;
        _GetTotalPriceLabel.textColor = [UIColor colorWithRed:223.0/255.0 green:67.0/255.0 blue:55.0/255.0 alpha:1];
        _GetTotalPriceLabel.text = @"0";
    }
    return _GetTotalPriceLabel;
}
-(UILabel *)AllCountLabel{
    if (!_AllCountLabel) {
        _AllCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220, 80, 35)];
        _AllCountLabel.textAlignment = NSTextAlignmentCenter;
        _AllCountLabel.textColor = [UIColor lightGrayColor];
        _AllCountLabel.font = [UIFont systemFontOfSize:23];
        _AllCountLabel.text = @"0";
    }
    return _AllCountLabel;
}
-(UILabel *)GetTotalCountLabel{
    if (!_GetTotalCountLabel) {
        _GetTotalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2-40, 220, 80, 35)];
        _GetTotalCountLabel.textAlignment = NSTextAlignmentCenter;
        _GetTotalCountLabel.textColor = [UIColor lightGrayColor];
        _GetTotalCountLabel.font = [UIFont systemFontOfSize:23];
        _GetTotalCountLabel.text = @"0";
    }
    return _GetTotalCountLabel;
}
-(UILabel *)UseTotalCount{
    if (!_UseTotalCount) {
        _UseTotalCount = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width-30-80, 220, 80, 35)];
        _UseTotalCount.textAlignment = NSTextAlignmentCenter;
        _UseTotalCount.textColor = [UIColor lightGrayColor];
        _UseTotalCount.font = [UIFont systemFontOfSize:23];
        _UseTotalCount.text = @"0";
    }
    return _UseTotalCount;
}
-(NSMutableArray *)DataArr{
    if (!_DataArr) {
        _DataArr = [[NSMutableArray alloc] init];
    }
    return _DataArr;
}
-(NSMutableArray *)MainIDArr{
    if (!_MainIDArr) {
        _MainIDArr = [[NSMutableArray alloc]init];
    }
    return _MainIDArr;
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

@end
