//
//  ZhiVisitorDynamicController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/11.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ZhiVisitorDynamicController.h"
#import "NewCustomerCell.h"
#import "OpportunitykeywordCell.h"
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
#define pageSize @"10"
//
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface ZhiVisitorDynamicController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray * customDyamicArray;
@property (nonatomic, assign)int pageNum;
@property (nonatomic, assign)BOOL isDone;

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
    [self initPull];
}
-(NSMutableArray *)customDyamicArray{
    if (!_customDyamicArray) {
        _customDyamicArray = [NSMutableArray array];
    }
    return _customDyamicArray;
}
- (void)loadDataSourceFrom:(int)type{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * params = @{@"PageIndex":[NSString stringWithFormat:@"%d", self.pageNum],@"PageSize":pageSize};
    [IWHttpTool postWithURL:@"Customer/GetCustomerDynamicList" params:params success:^(id json) {
        [self tableViewEndRefreshing];
        if ([json[@"IsSuccess"]integerValue]) {
            NSLog(@"%@", json);
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
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.tableView reloadData];
        }
    } failure:^(NSError * eror) {
    }];
}

#pragma mark - 刷新和分页
- (void)initPull{
    self.pageNum = 1;
    [self.tableView addHeaderWithTarget:self action:@selector(headRefish)dateKey:nil];
    [self.tableView addFooterWithTarget:self action:@selector(foodRefish)];
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
    self.tableView.footerPullToRefreshText = @"上拉刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self loadDataSourceFrom:1];
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
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomDynamicModel * model = self.customDyamicArray[indexPath.section];
    NSLog(@"DynamicType=%@", model.DynamicType);
    return [self heightWithDynamicType:model];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomDynamicModel * model = self.customDyamicArray[indexPath.section];
    if ([model.DynamicType intValue] == 1||[model.DynamicType intValue] == 2||[model.DynamicType intValue] == 3||[model.DynamicType intValue] == 9){
        static NSString * str = @"NewCustomerCell";
        NewCustomerCell * cell =[tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        cell.model = model;
        cell.NAV = self.navigationController;
        return cell;
    }else /*if([model.DynamicType intValue] == 3||[model.DynamicType intValue] == 9){
        static NSString * str = @"OpportunitykeywordCell";

        OpportunitykeywordCell * cell =[tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        cell.NAV = self.navigationController;
        cell.model = model;
        return cell;
    }else*/{
        static NSString * str = @"OpprotunityFreqCell";
        OpprotunityFreqCell * cell =[tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        cell.model = model;
        cell.NAV = self.navigationController;
        return cell;
    }
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, kScreenSize.width-20, kScreenSize.height-64) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"NewCustomerCell" bundle:nil] forCellReuseIdentifier:@"NewCustomerCell"];
//        [_tableView registerNib:[UINib nibWithNibName:@"OpportunitykeywordCell" bundle:nil] forCellReuseIdentifier:@"OpportunitykeywordCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"OpprotunityFreqCell" bundle:nil] forCellReuseIdentifier:@"OpprotunityFreqCell"];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomDynamicModel * model = self.customDyamicArray[indexPath.section];
    NSLog(@"%@----%@", model.DynamicType, model.DynamicContent);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([model.DynamicType intValue] == 1||[model.DynamicType intValue] == 2){
        
    }else if([model.DynamicType intValue] == 3||[model.DynamicType intValue] == 9){
    }else{
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"ShouKeBao_customerDynamicMessageListClick" attributes:dict];
        
        NSString * productUrl = model.ProductdetailModel.LinkUrl;
        ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
        NSLog(@"%@", productUrl);
        detail.produceUrl = productUrl;
        detail.fromType = FromZhiVisitorDynamic;
        detail.shareInfo = model.ProductdetailModel.ShareInfo;
        [self.navigationController pushViewController:detail animated:YES];
    }

}

//动态类型
//1直客绑定;2直客登录;3直客搜索产品;9直客验证留下电话号码-A
//
//4直客浏览线路达二次;5直客浏览产品;6直客收藏产品;7直客分享产品;8点击在线预订未下单;10直客浏览产品留下手机号-C
- (float)heightWithDynamicType:(CustomDynamicModel *)model{
    if ([model.DynamicType intValue] == 1 || [model.DynamicType intValue] == 2||[model.DynamicType intValue] == 3||[model.DynamicType intValue] == 9){
        return 65+[model.DynamicTitle heigthWithsysFont:12 withWidth:kScreenSize.width - 52];
    }else/* if([model.DynamicType intValue] == 1||[model.DynamicType intValue] == 3){
        return 95+[model.DynamicContent heigthWithsysFont:14 withWidth:kScreenSize.width - 60];
    }else if([model.DynamicType intValue] == 9){
        return 100+[model.DynamicContent heigthWithsysFont:14 withWidth:kScreenSize.width - 60];
    }else*/{
        return 150+[model.DynamicTitle heigthWithsysFont:12 withWidth:kScreenSize.width - 52];
    }
}

@end
