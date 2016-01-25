//
//  ChoseListViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "ChoseListViewController.h"
#import "TimeTipTableViewCell.h"
#import "choseSecondTableViewCell.h"
#import "MGSwipeButton.h"
#import "SwipeView.h"
#import "ProduceDetailViewController.h"
#import "IWHttpTool.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "ChoseModel.h"
#define pageSize 10

@interface ChoseListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *array2;

@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic, assign) NSInteger totalNumber;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, copy)NSString *Copies;
@property (nonatomic, copy)NSString *PushDate;
@property (nonatomic, strong)ProductModal *model;

@end

@implementation ChoseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self choseTableView];
    self.choseTableView.delegate = self;
    self.choseTableView.dataSource = self;
    [self initPull];
 
   
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array2.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2 == 0) {
        return 50;
    }
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoseModel *choseModel = self.array2[indexPath.row/2];
    if (indexPath.row%2 == 0) {
        TimeTipTableViewCell *timeTipCell =[[[NSBundle mainBundle]loadNibNamed:@"TimeTipTableViewCell" owner:nil options:nil]firstObject];
        //[TimeTipTableViewCell cellWithTableView:tableView];
        timeTipCell.modelC = choseModel;
        return timeTipCell;
    }
    choseSecondTableViewCell *cell = [choseSecondTableViewCell cellWithTableView:tableView];
    cell.model = choseModel;
//    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    cell.layer.masksToBounds = YES;
//    cell.layer.cornerRadius = 5;
//    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProduceDetailViewController *produceDetailVC = [[ProduceDetailViewController alloc]init];
    produceDetailVC.produceUrl = [self.dataArr[indexPath.row]LinkUrl];
    produceDetailVC.shareInfo = [self.dataArr[indexPath.row]ShareInfo];
    produceDetailVC.productName = [self.dataArr[indexPath.row]Name];
    [self.navigationController pushViewController:produceDetailVC animated:YES];
     [self.choseTableView deselectRowAtIndexPath:[self.choseTableView indexPathForSelectedRow] animated:YES];
}



#pragma mark - 数据加载
- (void)loadChoseListNotifiViewData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld", self.pageIndex] forKey:@"PageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"PageSize"];
    
    [IWHttpTool postWithURL:@"Customer/GetEveryRecommendProduct" params:dic success:^(id json) {
        NSLog(@",,,,, %@", json);
        if (self.isRefresh) {
            [self.dataArr removeAllObjects];
            [self.array2 removeAllObjects];
        }
      
        NSArray *arr = json[@"AppEveryRecommendProductList"];
        self.totalNumber = [json[@"TotalCount"] integerValue];
        
        for (NSDictionary *dic in arr) {
            ChoseModel *model = [ChoseModel modalWithDict:dic];
            [self.array2 addObject:model];
        }
        NSLog(@"dataArr = %@",  self.array2);
        [self.choseTableView reloadData];
        [self.choseTableView headerEndRefreshing];
        [self.choseTableView footerEndRefreshing];
    } failure:^(NSError *eror) {
    }];
    
}





#pragma mark - 刷新
-(void)initPull{
    self.pageIndex = 1;
    [self.choseTableView addHeaderWithTarget:self action:@selector(headPull)dateKey:nil];
    [self.choseTableView headerBeginRefreshing];
    [self.choseTableView addFooterWithTarget:self action:@selector(foodPull)];
    [self.choseTableView footerBeginRefreshing];
    self.choseTableView.headerPullToRefreshText = @"下拉刷新";
    self.choseTableView.headerRefreshingText = @"正在刷新中";
    self.choseTableView.footerPullToRefreshText = @"上拉刷新";
    self.choseTableView.footerRefreshingText = @"正在刷新";
}
-(void)headPull{
    [self loadChoseListNotifiViewData];
    self.isRefresh = YES;
    self.pageIndex = 1;
    
}
- (void)foodPull{
    self.isRefresh = NO;
    self.pageIndex++;
    NSLog(@",,%ld", self.pageIndex);
    if (self.pageIndex  > [self getTotalPage]) {
        [self.choseTableView footerEndRefreshing];
    }else{
        [self loadChoseListNotifiViewData];
    }
}

- (NSInteger)getTotalPage{
    NSInteger cos = self.totalNumber % pageSize;
    if (cos == 0) {
        return self.totalNumber / pageSize;
    }else{
        return self.totalNumber / pageSize + 1;
    }
}





- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)array2{
    if (!_array2) {
        _array2 = [NSMutableArray array];
    }
    return _array2;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
