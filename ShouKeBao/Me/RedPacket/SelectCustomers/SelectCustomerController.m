//
//  SelectCustomerController.m
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "SelectCustomerController.h"
#import "IWHttpTool.h"
#import "UIScrollView+MJRefresh.h"
#import "CustomModel.h"
#import "SetRedPacketController.h"
#define pageSize 10
#define kScreenSize [UIScreen mainScreen].bounds.size

@interface SelectCustomerController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *lowView;
@property (nonatomic,strong) UIButton *AllSelectedBtn;
@property (nonatomic,strong) UIButton *determineBtn;
@property (nonatomic,assign) int pageIndex;// 当前页
@property (nonatomic,copy) NSString *totalCount;
@property (nonatomic,copy) NSString *searchK;
@property (nonatomic,assign) BOOL isAll;
@property (nonatomic, assign)BOOL isNUll;

@end

@implementation SelectCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAll = NO;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"选择客人";
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
    //浮动图
    [self.lowView addSubview:self.AllSelectedBtn];
    [self.lowView addSubview:self.determineBtn];
    [self.view addSubview:self.lowView];
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
    if (self.isNUll) {
        
        self.searchK = @"";
    }
    self.pageIndex = 1;
//加载数据
    NSLog(@"加载数据");
    [self.tableView headerEndRefreshing];
//    [self  loadDataSource];
}
-(void)footRefresh
{
    self.pageIndex ++;
    
   [self.tableView footerEndRefreshing];
    
    
}
//- (NSInteger)getEndPage
//{
//    NSInteger cos = [self.totalCount integerValue] % pageSize;
//    if (cos == 0) {
//        return [self.totalCount integerValue] / pageSize;
//    }else{
//        return [self.totalCount integerValue] / pageSize + 1;
//        
//    }
//}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kScreenSize.width, kScreenSize.height-60-50-50) style:UITableViewStyleGrouped];
        _tableView.separatorInset = UIEdgeInsetsZero;
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
    }
    return _tableView;
}

//-(void)loadDataSource{
//
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:[NSString stringWithFormat:@"%d", self.pageIndex] forKey:@"PageIndex"];
//    [dic setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"PageSize"];
//    [dic setObject:@"7" forKey:@"SortType"];
//    [dic setObject:self.searchK forKey:@"SearchKey"];
//    [dic setObject:@"4" forKey:@"CustomerType"];
//    
//    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomerList" params:dic success:^(id json){
//        NSLog(@"------管客户json is %@-------",json);
//        NSMutableArray *arrs = [NSMutableArray array];
////        self.totalNumber = json[@"TotalCount"];
//        
//        arrs = json[@"CustomerList"];
//        
//        if (arrs.count == 0){
//            
//        }else{
//            
//            for (NSDictionary *dic in json[@"CustomerList"]) {
//                
//                CustomModel *model = [CustomModel modalWithDict:dic];
//                
//            }
//        }
//        
//        [self.tableView reloadData];
//        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];
//        
//    } failure:^(NSError *error) {
//        NSLog(@"-------管客户第一个接口请求失败 error is %@------",error);
//    }];
//    
//}
#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [_searchBar setShowsCancelButton:YES];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenSize.width, kScreenSize.height-50)];
    view.backgroundColor = [UIColor blueColor];
    view.tag = 1001;
    [self.view addSubview:view];

    for(id cc in [searchBar.subviews[0] subviews]){
        
        if([cc isKindOfClass:[UIButton class]]){
            
            UIButton *btn = (UIButton *)cc;
            
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    self.navigationController.navigationBarHidden=YES;


    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitleColor:[UIColor colorWithRed:68/255.0 green:122/255.0 blue:208/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    for (UIView *searchbuttons in [[searchBar.subviews objectAtIndex:0] subviews])
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton *)searchbuttons;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"取消"];
            NSMutableDictionary *muta = [NSMutableDictionary dictionary];
            [muta setObject:[UIColor colorWithRed:68/255.0 green:122/255.0 blue:208/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
            [muta setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
            [attr addAttributes:muta range:NSMakeRange(0, 2)];
            [cancelButton setAttributedTitle:attr forState:UIControlStateNormal];
        }
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.navigationController.navigationBarHidden = NO;
    [searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
    UITableView *vvv = [self.view viewWithTag:1001];
    [vvv removeFromSuperview];
}
-(void)BtnClick:(UIButton *)button{
    if (button.tag == 101) {//确定按钮
        SetRedPacketController *setRPacket = [[SetRedPacketController alloc] init];
        [self.navigationController pushViewController:setRPacket animated:YES];
        
    }else if(button.tag == 102){//全选
        if (_isAll) {
            [_AllSelectedBtn setImage:[UIImage imageNamed:@"InvoiceAllBtn"] forState:UIControlStateNormal];
            _isAll = NO;
        }else{
            [_AllSelectedBtn setImage:[UIImage imageNamed:@"InvoiceClickAll"] forState:UIControlStateNormal];
            _isAll = YES;

        }
    }
}
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,kScreenSize.width , 50)];
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
        [_searchBar setBarTintColor:[UIColor whiteColor]];
        [_searchBar setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1]];

    }
    return _searchBar;
}
//-(UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kScreenSize.width, kScreenSize.height-60-50-60)];
//    }
//    return _tableView;
//}
-(UIButton *)AllSelectedBtn{
    if (!_AllSelectedBtn) {
        _AllSelectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 2, 80, 40)];
        [_AllSelectedBtn setTitle:@"全选" forState:UIControlStateNormal];
//        _AllSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:1];
        [_AllSelectedBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [_AllSelectedBtn setTitleColor:[UIColor colorWithRed:65.0/255.0 green:121.0/255.0 blue:253.0/255.0 alpha:1] forState:UIControlStateNormal];
        _AllSelectedBtn.tag = 102;
        [_AllSelectedBtn setImage:[UIImage imageNamed:@"InvoiceAllBtn"] forState:UIControlStateNormal];
        [_AllSelectedBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 8,55)];
        [_AllSelectedBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        [_AllSelectedBtn setImage:[UIImage imageNamed:@"InvoiceClickAll"] forState:UIControlStateSelected];
    }
    return _AllSelectedBtn;
}
-(UIView *)lowView{
    if (!_lowView) {
        _lowView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-60-50, kScreenSize.width, 50)];
        _lowView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:243.0/255.0 alpha:1];
    }
    return _lowView;
}
-(UIButton *)determineBtn{
    if (!_determineBtn) {
        _determineBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width-80, 2, 80, 40)];
        [_determineBtn setTitle:@"确定(0)" forState:UIControlStateNormal];
        [_determineBtn setTitleColor:[UIColor colorWithRed:65.0/255.0 green:121.0/255.0 blue:253.0/255.0 alpha:1] forState:UIControlStateNormal];
        _determineBtn.tag = 101;
        [_determineBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _determineBtn;
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
