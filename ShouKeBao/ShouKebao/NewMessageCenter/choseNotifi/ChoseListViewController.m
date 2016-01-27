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

//当前的分区数组
@property (nonatomic, strong)NSMutableArray *currentLittleArray;
@property (nonatomic, strong)NSMutableArray *beforeLittleArray;

@property (nonatomic, strong)NSDictionary *beforeDic;

@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic, assign) NSInteger totalNumber;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, copy)NSString *Copies;
@property (nonatomic, copy)NSString *PushDate;
@property (nonatomic, strong)ProductModal *model;
@property (weak, nonatomic) IBOutlet UIView *nullImage;

@end

@implementation ChoseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self choseTableView];
    self.choseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.choseTableView.delegate = self;
    self.choseTableView.dataSource = self;
    [self initPull];
 
   
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array2.count*2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array = self.array2[indexPath.row/2];
    if (indexPath.row%2 == 0) {
        return 50;
    }
    return 120*array.count+75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *choseArray = self.array2[indexPath.row/2];
    if (indexPath.row%2 == 0) {
       TimeTipTableViewCell *timeTipCell =[TimeTipTableViewCell cellWithTableView:tableView];
        timeTipCell.modelC = choseArray[0];
        return timeTipCell;
    }
    choseSecondTableViewCell *cell = [choseSecondTableViewCell cellWithTableView:tableView naV:self.navigationController];
    cell.arrData =self.array2[indexPath.row/2];
    NSLog(@"%@", self.array2);
    return cell;
}

#pragma mark - 数据加载
- (void)loadChoseListNotifiViewData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld", self.pageIndex] forKey:@"PageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"PageSize"];
    NSLog(@"... %ld", self.pageIndex);
    [IWHttpTool postWithURL:@"Customer/GetEveryRecommendProduct" params:dic success:^(id json) {
        NSLog(@",,,,, %@", json);
        if (self.isRefresh) {
            [self.dataArr removeAllObjects];
            [self.array2 removeAllObjects];
            [self.currentLittleArray removeAllObjects];
            
        }
      
        NSArray *arr = json[@"AppEveryRecommendProductList"];
        self.totalNumber = [json[@"TotalCount"] integerValue];
        
        if (self.totalNumber == 0 || arr.count == 0) {
            self.nullImage.hidden = NO;
            [self.choseTableView headerEndRefreshing];
            [self.choseTableView footerEndRefreshing];
            return;
        }

        
        for (int i = 0; i<arr.count; i++) {
            NSDictionary * currentDic = arr[i];
            NSDictionary * beforeDic = @{};
            if (i == 0) {
                if (!self.isRefresh) {
                    beforeDic = self.beforeDic;
                }else{
                    beforeDic = arr[i];
                }
            }else{
                beforeDic = arr[i-1];
                self.beforeDic = currentDic;
            }
            NSLog(@"%@---%@", currentDic, beforeDic);
            ChoseModel *currentModel = [ChoseModel modalWithDict:currentDic];
            ChoseModel *beforeModel = [ChoseModel modalWithDict:beforeDic];

            if (![currentModel.PushDate isEqualToString:beforeModel.PushDate]) {
                if (!self.isRefresh) {
                    [self.array2 removeObject:self.array2.lastObject];
                }
                [self.array2 addObject:[self.currentLittleArray mutableCopy]];
                [self.currentLittleArray removeAllObjects];
            }
            [self.currentLittleArray addObject:currentModel];
            if (i == arr.count-1) {
                ChoseModel* currentArrModel = self.currentLittleArray[0];
                ChoseModel* beforeArrModel = self.array2.lastObject[0];
                if ([currentArrModel.PushDate isEqualToString:beforeArrModel.PushDate]) {
                    [self.array2 removeObject:self.array2.lastObject];
                }
                [self.array2 addObject:[self.currentLittleArray mutableCopy]];
            }
        }
          NSLog(@"array2===%@ %@...  %@", self.array2, self.currentLittleArray, self.beforeLittleArray);

        
        [self.choseTableView reloadData];
        [self.choseTableView headerEndRefreshing];
        [self.choseTableView footerEndRefreshing];
    } failure:^(NSError *eror) {
    }];
    
}





#pragma mark - 刷新
-(void)initPull{
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
    self.isRefresh = YES;
    self.pageIndex = 1;
    [self loadChoseListNotifiViewData];
    
}
- (void)foodPull{
    self.isRefresh = NO;
    self.pageIndex++;
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

-(NSMutableArray *)currentLittleArray{
    if (!_currentLittleArray) {
        _currentLittleArray = [NSMutableArray array];
    }
    return _currentLittleArray;
}
-(NSMutableArray *)beforeLittleArray{
    if (!_beforeLittleArray) {
        _beforeLittleArray = [NSMutableArray array];
    }
    return _beforeLittleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
