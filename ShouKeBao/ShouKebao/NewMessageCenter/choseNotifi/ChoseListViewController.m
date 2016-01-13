//
//  ChoseListViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "ChoseListViewController.h"
#import "ProductCell.h"
#import "MGSwipeButton.h"
#import "SwipeView.h"
#import "ProduceDetailViewController.h"
#import "IWHttpTool.h"
#import "MJRefresh.h"
#define pageSize 10

@interface ChoseListViewController ()<UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (strong, nonatomic) IBOutlet UIView *choseView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *choseL;
@property (weak, nonatomic) IBOutlet UILabel *choseTextL;

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
     _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, /*self.choseTableView.frame.size.height*/1200 + 50);
    _choseTableView.frame = CGRectMake(10, 50, self.view.frame.size.width-20, _scrollView.contentSize.height-50);
    _choseTableView.scrollEnabled = NO;
    _choseTableView.tableHeaderView = _choseView;
    [self initPull];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductCell *cell = [ProductCell cellWithTableView:tableView];
   // self.model = _dataArr[indexPath.row];
   // cell.modal = model;
    cell.delegate = self;
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.rightButtons = [self createRightButtons:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProduceDetailViewController *produceDetailVC = [[ProduceDetailViewController alloc]init];
//    produceDetailVC.productId = self.model.productId;
    [self.navigationController pushViewController:produceDetailVC animated:YES];
     [self.choseTableView deselectRowAtIndexPath:[self.choseTableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - 数据加载
- (void)loadChoseListNotifiViewData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%d", self.pageIndex] forKey:@"PageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"PageSize"];
    
    [IWHttpTool postWithURL:@"Customer/GetEveryRecommendProduct" params:dic success:^(id json) {
        NSLog(@",,,,, %@", json);
        if (self.isRefresh == 1) {
            [self.dataArr removeAllObjects];
        }
        
//        self.Copies = json[@"AppEveryRecommendProductList"][@"Copies"];
//        self.PushDate = json[@"AppEveryRecommendProductList"][@"PushDate"];
//        self.timeTip.text = self.PushDate;
//        self.choseTextL.text = self.Copies;
        
        NSArray *arr = json[@"AppEveryRecommendProductList"]/*[@"Productdetail"]*/;
        self.totalNumber = [json[@"TotalCount"] integerValue];
        
        for (NSDictionary *dic in arr) {
            ProductModal *model = [ProductModal modalWithDict:dic];
            [self.dataArr addObject:model];
        }
        NSLog(@",,,,, %@", self.dataArr);
        [self.choseTableView reloadData];
        [self.choseTableView headerEndRefreshing];
        [self.choseTableView footerEndRefreshing];
    } failure:^(NSError *eror) {
    }];
    
}





- (NSArray *)createRightButtons:(ProductModal *)model{
    NSMutableArray * result = [NSMutableArray array];
    UIColor * colors[2] = {[UIColor clearColor], [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1]};
    for (int i = 0; i < 2; i ++){
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:nil backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"Convenience callback received (right). %d",i);
            return YES;
        }];
        if (i == 0){
            NSString *img = [model.IsFavorites isEqualToString:@"1"] ? @"uncollection_icon" : @"collection_icon";
            [button setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        }else{
            button.enabled = NO;
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [button setTitleColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1] forState:UIControlStateNormal];
        CGRect frame = button.frame;
        frame.size.height = 120;
        frame.size.width = i == 1 ? 140 : 42;
        button.frame = frame;
        if (i == 1) {
            SwipeView *swipe = [SwipeView addSubViewLable:button Model:model];
            [button addSubview:swipe];
        }
        [result addObject:button];
    }
    return result;
}
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
    self.isRefresh = 1;
    
}
- (void)foodPull{
    self.isRefresh = 0;
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


- (void)setTimeTip:(UILabel *)timeTip{
    _timeTip = timeTip;
    _timeTip.layer.masksToBounds = YES;
    _timeTip.layer.cornerRadius = 5;
    
}
- (void)setIcon:(UIImageView *)icon{
    _icon = icon;
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = 15;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
