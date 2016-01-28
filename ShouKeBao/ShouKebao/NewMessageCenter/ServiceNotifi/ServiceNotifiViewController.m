//
//  ServiceNotifiViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/4.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "ServiceNotifiViewController.h"
#import "ServiceNotifiTableViewCell.h"
#import "TerracedetailViewController.h"
#import "NewNewsController.h"
#import "IWHttpTool.h"
#import "MJRefresh.h"
#define pageSize 10
@interface ServiceNotifiViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *nullImageView;

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic, assign) NSInteger totalNumber;
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation ServiceNotifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"业务通知";
    [self serviceNotifiRightBarItem];
    [self initPull];
    
    
    
    
    
    
    
    
    
    
    
}

#pragma mark - UITableViewDelegate&&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceNotifiTableViewCell *serviceNotiCell = [ServiceNotifiTableViewCell cellWithTableView:tableView];
    NSLog(@"... %@", _dataArr);
    ServiceModel *serviceModel = _dataArr[indexPath.row];
    serviceNotiCell.serviceModel = serviceModel;
    
    return serviceNotiCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TerracedetailViewController *TerracedetailVC = [[TerracedetailViewController alloc]init];
    TerracedetailVC.serviceLinkUrl = [self.dataArr[indexPath.row]LinkUrl];
    NSLog(@"..%@", [self.dataArr[indexPath.row]LinkUrl]);
    [self.navigationController pushViewController:TerracedetailVC animated:YES];
     [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - 数据加载
- (void)loadServiceNotifiViewData{
     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld", self.pageIndex] forKey:@"PageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"PageSize"];
    
      [IWHttpTool postWithURL:@"Notice/GetAppBusinessNoticeList" params:dic success:^(id json) {
          NSLog(@",,,,, %@", json);
          if (self.isRefresh == 1) {
              [self.dataArr removeAllObjects];
          }
          NSArray *arr = json[@"AppBusinessNoticeList"];
          self.totalNumber = [json[@"TotalCount"] integerValue];
          
          if (self.totalNumber == 0) {
              self.nullImageView.hidden = NO;
              [self.tableView headerEndRefreshing];
              [self.tableView footerEndRefreshing];
              return;
          }
          
          for (NSDictionary *dic in arr) {
              ServiceModel *model = [ServiceModel modelWithDic:dic];
              [self.dataArr addObject:model];
          }
               NSLog(@",,,,, %@", self.dataArr);
          [self.tableView reloadData];
          [self.tableView headerEndRefreshing];
          [self.tableView footerEndRefreshing];
      } failure:^(NSError *eror) {
      }];
    
}




#pragma mark - 导航设置
-(void)serviceNotifiRightBarItem{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(pushEditView)];
    self.navigationItem.rightBarButtonItem= barItem;
}

- (void)pushEditView{
    NewNewsController *settingVC = [[NewNewsController alloc]init];
    settingVC.title = @"设置";
//    settingVC.signStr = @"fromServiceVC";
    [self.navigationController pushViewController:settingVC animated:YES];
    
    
}
#pragma mark - 刷新
-(void)initPull{
    self.pageIndex = 1;
    [self.tableView addHeaderWithTarget:self action:@selector(headPull)dateKey:nil];
    [self.tableView headerBeginRefreshing];
    [self.tableView addFooterWithTarget:self action:@selector(foodPull)];
    [self.tableView footerBeginRefreshing];
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
    self.tableView.footerPullToRefreshText = @"上拉刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
}
-(void)headPull{
    
    [self loadServiceNotifiViewData];
    self.isRefresh = 1;
    
}
- (void)foodPull{
     self.isRefresh = 0;
    self.pageIndex++;
    if (self.pageIndex  > [self getTotalPage]) {
        [self.tableView footerEndRefreshing];
    }else{
        [self loadServiceNotifiViewData];
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

#pragma mark - 初始化
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
