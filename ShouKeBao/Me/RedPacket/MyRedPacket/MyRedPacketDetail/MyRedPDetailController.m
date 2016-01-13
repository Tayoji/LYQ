//
//  MyRedPDetailController.m
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/11.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "MyRedPDetailController.h"
#import "IWHttpTool.h"
#import "MyRedPcketDetailCell.h"
#import "NoRedPacketDetailCell.h"
#import "UIScrollView+MJRefresh.h"
#import "UIImageView+WebCache.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface MyRedPDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UILabel *TitleLabel;
@property(nonatomic)UILabel *PriceTotalLabel;
@property(nonatomic)UILabel *LuckContentLabel;
@property(nonatomic)UILabel *DateTimeLabel;
@property(nonatomic)UILabel *MixLabel;
@property(nonatomic)UILabel *DescribeLabel;

@property(nonatomic)UILabel *OutLuckMixLabel;
@property(nonatomic)UILabel *OutTotalPriceLabel;
@property(nonatomic)UILabel *InsideuckMixLabel;
@property(nonatomic)UILabel *InsideTotalPriceLabel;
@property(nonatomic)UILabel *NearbyLuckMixLabel;
@property(nonatomic)UILabel *NearbyTotalPriceLabel;

@property(nonatomic)UILabel *LuckMoneyGetCountLabael;

@property (nonatomic,strong) NSMutableArray *cellDataArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *headView;

@property (nonatomic,assign) int pageIndex;
@property (nonatomic, assign)BOOL isRefresh;
@end

@implementation MyRedPDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pageIndex = 1;
    self.isRefresh = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavTest"] forBarMetrics:UIBarMetricsDefault];
        self.title = @"我的红包";
    //填充头区域数据
    NSLog(@"--%@",self.lastData);
    self.TitleLabel.text = self.lastData[@"Title"];
    self.PriceTotalLabel.text = [NSString stringWithFormat:@"%@元",self.lastData[@"PriceTotal"]];
    self.LuckContentLabel.text = self.lastData[@"LuckContent"];
    self.DateTimeLabel.text = self.lastData[@"DateTime"];
    self.MixLabel.text = [NSString stringWithFormat:@"%@/%@个",self.lastData[@"UnGetCount"],self.lastData[@"GetCount"]];
    [self loadDataSource];
    [self.view addSubview:self.tableView];
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
        [self.cellDataArr removeAllObjects];
        self.isRefresh = NO;
        self.pageIndex = 1;
        [self  loadDataSource];
    }
    
}
-(void)footRefresh
{
    if (self.isRefresh) {
        self.pageIndex ++;
        [self loadDataSource];
        self.isRefresh = NO;
    }
    
    
}

-(void)loadDataSource{
    NSString *IDsStr = self.lastData[@"AppLuckMoneyMainId"];
    NSLog(@"---%@",IDsStr);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:IDsStr forKey:@"AppLuckMoneyMainIds"];
    [dic setValue:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"PageIndex"];
    [dic setValue:@"10" forKey:@"PageSize"];
    NSLog(@"---%@",dic);
    [IWHttpTool WMpostWithURL:@"/Customer/GetAppLuckMoneyDetailInfoList" params:dic success:^(id json) {
        NSLog(@"------------------红包详情:%@--------------------",json);
        
        if (!self.isRefresh) {
            self.isRefresh = YES;
        }
        self.DescribeLabel.text = json[@"Title"];//红包描述
        self.OutLuckMixLabel.text = [NSString stringWithFormat:@"%@/%@个",[json[@"AppLuckMoneyThreeList"] objectForKey:@"OutGetLuckMoneyCount"],[json[@"AppLuckMoneyThreeList"] objectForKey:@"OutLuckMoneyCount"] ];//出境游
        self.OutTotalPriceLabel.text = [NSString stringWithFormat:@"%@元",[json[@"AppLuckMoneyThreeList"] objectForKey:@"OutTotalPrice"]];
        
        self.InsideuckMixLabel.text = [NSString stringWithFormat:@"%@/%@个",[json[@"AppLuckMoneyThreeList"] objectForKey:@"InsideGetLuckMoneyCount"],[json[@"AppLuckMoneyThreeList"] objectForKey:@"InsideuckMoneyCount"]];//国内游
        self.InsideTotalPriceLabel.text = [NSString stringWithFormat:@"%@元",[json[@"AppLuckMoneyThreeList"] objectForKey:@"InsideTotalPrice"]];
        
        self.NearbyLuckMixLabel.text = [NSString stringWithFormat:@"%@/%@个",[json[@"AppLuckMoneyThreeList"] objectForKey:@"NearbyGetLuckMoneyCount"],[json[@"AppLuckMoneyThreeList"] objectForKey:@"NearbyLuckMoneyCount"]];//周边游
        self.NearbyTotalPriceLabel.text = [NSString stringWithFormat:@"%@元",[json[@"AppLuckMoneyThreeList"] objectForKey:@"NearbyTotalPrice"]];

        self.LuckMoneyGetCountLabael.text = [NSString stringWithFormat:@"%@人已领取",[json[@"AppLuckMoneyThreeList"] objectForKey:@"LuckMoneyGetCount"]];
        
        for (NSDictionary *dic in json[@"AppLuckMoneyDetailModelList"]) {
            [self.cellDataArr addObject:dic];
            
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}
#pragma mark -UITableViewDataSource && UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.cellDataArr[indexPath.row];
    NSLog(@"--%@",dataDic[@"LuckMoneyType"]);
    if ([dataDic[@"LuckMoneyType"]  isEqual: @"0"]) {//待领取
        tableView.rowHeight = 80;
        NoRedPacketDetailCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"NoRedPacketDetailCell" owner:nil options:nil]firstObject];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        NSLog(@"%@",cell.HeadtitLabel.text);
            if (![dataDic[@"HearUrl"]  isEqual: @""]) {
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"HearUrl"]]];
                cell.HeadtitLabel.alpha = 0;
            }else{
                
                if ([dataDic[@"FirstName"]   isEqual: @""]) {
                    cell.HeadtitLabel.text = @"空";
                }else{
                    cell.HeadtitLabel.text = dataDic[@"FirstName"];

                }
            }
        cell.NumLabel.text  = dataDic[@"Mobile"];
        cell.StateLabel.text = @"待领取";
        if ([dataDic[@"Area"]  isEqual: @"1"]) {
            cell.PriceLabel.text = [NSString stringWithFormat:@"国内券%@元",dataDic[@"LuckMoneyPrice"]];
        }else if([dataDic[@"Area"]  isEqual: @"2"]){
            cell.PriceLabel.text = [NSString stringWithFormat:@"出境券%@元",dataDic[@"LuckMoneyPrice"]];

        }else if([dataDic[@"Area"]  isEqual: @"3"]){
            cell.PriceLabel.text = [NSString stringWithFormat:@"周边券%@元",dataDic[@"LuckMoneyPrice"]];

        }else{
            cell.PriceLabel.text = [NSString stringWithFormat:@"邮轮卷%@元",dataDic[@"LuckMoneyPrice"]];
        }
        return cell;
    }else if([dataDic[@"LuckMoneyType"]  isEqual: @"1"]){//未使用
        tableView.rowHeight = 100;
        MyRedPcketDetailCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRedPcketDetailCell" owner:nil options:nil]firstObject];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        NSLog(@"%@",cell.headtitLabel.text);
            if (![dataDic[@"HearUrl"]  isEqual: @""]) {
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"HearUrl"]]];
                cell.headtitLabel.alpha = 0;
            }else{
                if ([dataDic[@"FirstName"]   isEqual: @""]) {
                    cell.headtitLabel.text = @"空";
                }else{
                    cell.headtitLabel.text = dataDic[@"FirstName"];
                    
                }
            }
        cell.StateLabel.text = @"未使用";
        cell.NumberLabel.text = dataDic[@"Mobile"];
        cell.DataLabel.text = dataDic[@"GetDate"];
        if ([dataDic[@"Area"]  isEqual: @"1"]) {
            cell.PriceLabel.text = [NSString stringWithFormat:@"国内券%@元",dataDic[@"LuckMoneyPrice"]];
        }else if([dataDic[@"Area"]  isEqual: @"2"]){
            cell.PriceLabel.text = [NSString stringWithFormat:@"出境券%@元",dataDic[@"LuckMoneyPrice"]];
            
        }else if([dataDic[@"Area"]  isEqual: @"3"]){
            cell.PriceLabel.text = [NSString stringWithFormat:@"周边券%@元",dataDic[@"LuckMoneyPrice"]];

        }else{
            cell.PriceLabel.text = [NSString stringWithFormat:@"邮轮卷%@元",dataDic[@"LuckMoneyPrice"]];
        }
        cell.CardIdLabel.alpha = 0;
        return cell;
    }else if([dataDic[@"LuckMoneyType"]  isEqual: @"2"]){//已使用
        tableView.rowHeight = 100;
        MyRedPcketDetailCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"" owner:nil options:nil]firstObject];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        NSLog(@"%@",cell.headtitLabel.text);
            if (![dataDic[@"HearUrl"]  isEqual: @""]) {
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"HearUrl"]]];
                cell.headtitLabel.alpha = 0;
            }else{
                if ([dataDic[@"FirstName"]   isEqual: @""]) {
                    cell.headtitLabel.text = @"空";
                }else{
                    cell.headtitLabel.text = dataDic[@"FirstName"];
                    
                }
            }
        cell.StateLabel.text = [NSString stringWithFormat:@"%@使用",dataDic[@"LuckMoneyUesTime"]];
        cell.NumberLabel.text = dataDic[@"Mobile"];
        cell.DataLabel.text = dataDic[@"GetDate"];
        cell.CardIdLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"OrderCode"]];
        if ([dataDic[@"Area"]  isEqual: @"1"]) {
            cell.PriceLabel.text = [NSString stringWithFormat:@"国内券%@元",dataDic[@"LuckMoneyPrice"]];
        }else if([dataDic[@"Area"]  isEqual: @"2"]){
            cell.PriceLabel.text = [NSString stringWithFormat:@"出境券%@元",dataDic[@"LuckMoneyPrice"]];
            
        }else if([dataDic[@"Area"]  isEqual: @"3"]){
            cell.PriceLabel.text = [NSString stringWithFormat:@"周边券%@元",dataDic[@"LuckMoneyPrice"]];
            
        }else{
            cell.PriceLabel.text = [NSString stringWithFormat:@"邮轮卷%@元",dataDic[@"LuckMoneyPrice"]];
        }
        return cell;
    }else if([dataDic[@"LuckMoneyType"]  isEqual: @"3"]){//已过期
        tableView.rowHeight = 800;
        NoRedPacketDetailCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"NoRedPacketDetailCell" owner:nil options:nil]firstObject];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        NSLog(@"%@",cell.HeadtitLabel.text);
            if (![dataDic[@"HearUrl"]  isEqual: @""]) {
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"HearUrl"]]];
                cell.HeadtitLabel.alpha = 0;
            }else{
                if ([dataDic[@"FirstName"]   isEqual: @""]) {
                    cell.HeadtitLabel.text = @"空";
                }else{
                    cell.HeadtitLabel.text = dataDic[@"FirstName"];
                    
                }
            }
        cell.StateLabel.text = @"已过期";
        cell.NumLabel.text = dataDic[@"Mobile"];
        
        if ([dataDic[@"Area"]  isEqual: @"1"]) {
            cell.PriceLabel.text = [NSString stringWithFormat:@"国内券%@元",dataDic[@"LuckMoneyPrice"]];
        }else if([dataDic[@"Area"]  isEqual: @"2"]){
            cell.PriceLabel.text = [NSString stringWithFormat:@"出境券%@元",dataDic[@"LuckMoneyPrice"]];
            
        }else if([dataDic[@"Area"]  isEqual: @"3"]){
            cell.PriceLabel.text = [NSString stringWithFormat:@"周边券%@元",dataDic[@"LuckMoneyPrice"]];
            
        }else{
            cell.PriceLabel.text = [NSString stringWithFormat:@"邮轮卷%@元",dataDic[@"LuckMoneyPrice"]];
        }
        return cell;
    }
    
    
    return nil;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headView;
        _tableView.rowHeight = 100;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 274)];
        _headView.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:self.TitleLabel];
        [_headView addSubview:self.PriceTotalLabel];
        [_headView addSubview:self.LuckContentLabel];
        [_headView addSubview:self.DateTimeLabel];
        [_headView addSubview:self.MixLabel];
        [_headView addSubview:self.DescribeLabel];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 113, kScreenSize.width-10, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        view.alpha = 0.5;
        [_headView addSubview:view];
        UILabel *outLabel = [[UILabel   alloc] initWithFrame:CGRectMake(10, 119, 70, 30)];
        outLabel.text = @"出境券";
        [_headView addSubview:outLabel];
        [_headView addSubview:self.OutTotalPriceLabel];
        [_headView addSubview:self.OutLuckMixLabel];
        
        UILabel *InLabel = [[UILabel   alloc] initWithFrame:CGRectMake(10, 154, 70, 30)];
        InLabel.text = @"国内券";
        [_headView addSubview:InLabel];
        [_headView addSubview:self.InsideTotalPriceLabel];
        [_headView addSubview:self.InsideuckMixLabel];
        
        UILabel *NearLabel = [[UILabel   alloc] initWithFrame:CGRectMake(10, 189, 70, 30)];
        NearLabel.text = @"周边券";
        [_headView addSubview:NearLabel];
        [_headView addSubview:self.NearbyLuckMixLabel];
        [_headView addSubview:self.NearbyTotalPriceLabel];
        
        UIView *minView = [[UIView alloc] initWithFrame:CGRectMake(0, 224, kScreenSize.width, 50)];
        UIView *vview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 1)];
        vview.backgroundColor = [UIColor lightGrayColor];
        vview.alpha = 0.5;
        [minView addSubview:vview];
        minView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1];
        [minView addSubview:self.LuckMoneyGetCountLabael];
        UIView *vview2 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenSize.width, 1)];
        vview2.backgroundColor = [UIColor lightGrayColor];
        vview2.alpha = 0.5;
        [minView addSubview:vview2];
        [_headView addSubview:minView];
    }
    return _headView;
}
-(UILabel *)TitleLabel{
    if (!_TitleLabel) {
        _TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 100, 30)];
    }
    return _TitleLabel;
}
-(UILabel *)PriceTotalLabel{
    if (!_PriceTotalLabel) {
        _PriceTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width-100, 8, 80, 30)];
        _PriceTotalLabel.textAlignment = NSTextAlignmentRight;
    }
    return _PriceTotalLabel;
}
-(UILabel *)LuckContentLabel{
    if (!_LuckContentLabel) {
        _LuckContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, 100, 30)];
        _LuckContentLabel.textColor = [UIColor lightGrayColor];
        _LuckContentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _LuckContentLabel;
}
-(UILabel *)DateTimeLabel{
    if (!_DateTimeLabel) {
        _DateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 43, 150, 30)];
        _DateTimeLabel.textColor = [UIColor lightGrayColor];
        _DateTimeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _DateTimeLabel;
}
-(UILabel *)MixLabel{
    if (!_MixLabel) {
        _MixLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width-100, 43, 80, 30)];
        _MixLabel.textColor = [UIColor lightGrayColor];
        _MixLabel.font = [UIFont systemFontOfSize:15];
        _MixLabel.textAlignment = NSTextAlignmentRight;
    }
    return _MixLabel;
}
-(UILabel *)DescribeLabel{
    if (!_DescribeLabel) {
        _DescribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 78, kScreenSize.width/3, 30)];
        _DescribeLabel.textColor = [UIColor lightGrayColor];
    }
    return _DescribeLabel;
}
-(UILabel *)OutLuckMixLabel{
    if (!_OutLuckMixLabel) {
        _OutLuckMixLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2-50, 119, 100, 30)];
        _OutLuckMixLabel.textColor = [UIColor lightGrayColor];
        _OutLuckMixLabel.font = [UIFont systemFontOfSize:15];
        _OutLuckMixLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _OutLuckMixLabel;
}
-(UILabel *)OutTotalPriceLabel{
    if (!_OutTotalPriceLabel) {
        _OutTotalPriceLabel = [[UILabel  alloc] initWithFrame:CGRectMake(kScreenSize.width-120, 119, 100, 30)];
        _OutTotalPriceLabel.font = [UIFont systemFontOfSize:15];
        _OutTotalPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _OutTotalPriceLabel;
}
-(UILabel *)InsideuckMixLabel{
    if (!_InsideuckMixLabel) {
        _InsideuckMixLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2-50, 154, 100, 30)];
        _InsideuckMixLabel.textColor = [UIColor lightGrayColor];
        _InsideuckMixLabel.font = [UIFont systemFontOfSize:15];
        _InsideuckMixLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _InsideuckMixLabel;
}
-(UILabel *)InsideTotalPriceLabel{
    if (!_InsideTotalPriceLabel) {
        _InsideTotalPriceLabel = [[UILabel  alloc] initWithFrame:CGRectMake(kScreenSize.width-120, 154, 100, 30)];
        _InsideTotalPriceLabel.font = [UIFont systemFontOfSize:15];
        _InsideTotalPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _InsideTotalPriceLabel;
}
-(UILabel *)NearbyLuckMixLabel{
    if (!_NearbyLuckMixLabel) {
        _NearbyLuckMixLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2-50, 189, 100, 30)];
        _NearbyLuckMixLabel.textColor = [UIColor lightGrayColor];
        _NearbyLuckMixLabel.font = [UIFont systemFontOfSize:15];
        _NearbyLuckMixLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _NearbyLuckMixLabel;
}
-(UILabel *)NearbyTotalPriceLabel{
    if (!_NearbyTotalPriceLabel) {
        _NearbyTotalPriceLabel = [[UILabel  alloc] initWithFrame:CGRectMake(kScreenSize.width-120, 189, 100, 30)];
        _NearbyTotalPriceLabel.font = [UIFont systemFontOfSize:15];
        _NearbyTotalPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _NearbyTotalPriceLabel;
}
-(UILabel *)LuckMoneyGetCountLabael{
    if (!_LuckMoneyGetCountLabael) {
        _LuckMoneyGetCountLabael = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenSize.width/2, 30)];
        _LuckMoneyGetCountLabael.textColor =[UIColor lightGrayColor];
        _LuckMoneyGetCountLabael.font = [UIFont systemFontOfSize:15];
    }
    return _LuckMoneyGetCountLabael;
}
-(NSMutableArray *)cellDataArr{
    if (!_cellDataArr) {
        _cellDataArr = [[NSMutableArray alloc] init];
    }
    return _cellDataArr;
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
