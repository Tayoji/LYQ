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
#import "RedPSelCusterCell.h"
#import "SetRedPacketController.h"
#import "UIImageView+WebCache.h"
#import "EaseMob.h"
#import "APNSHelper.h"
#import "ChatSendHelper.h"
#import "MBProgressHUD+MJ.h"
#define pageSize 10
#define kScreenSize [UIScreen mainScreen].bounds.size
#define UserDefault [NSUserDefaults standardUserDefaults]

@interface SelectCustomerController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UISearchBar *searchBar;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *lowView;
//@property (nonatomic,strong) UIButton *AllSelectedBtn;
@property (nonatomic,strong) UIButton *determineBtn;
@property (nonatomic,assign) int pageIndex;// 当前页
@property (nonatomic,copy) NSString *totalCount;
@property (nonatomic,copy) NSString *searchK;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) BOOL isAll;
@property (nonatomic, assign)BOOL isRefresh;
@property (nonatomic,strong) NSMutableArray *SELCustomerArr;
@property (nonatomic,strong) UITableView *searchTableView;
@property (nonatomic,strong) UIView *historyView;
@property (nonatomic,strong) UIView *nullView;

@property (nonatomic,strong) NSMutableArray *guideHistoryArr;

@end

@implementation SelectCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([UserDefault objectForKey:@"GuideHistoryRP"]) {
        
       NSMutableArray *mutabArr = [UserDefault objectForKey:@"GuideHistoryRP"];
        [self.guideHistoryArr addObjectsFromArray:mutabArr];
    }
    self.isAll = NO;
    self.isRefresh = YES;
    self.pageIndex = 1;
    self.searchK = @"";
    [self.tableView addSubview:self.nullView];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"选择客人";
    [self iniHeader];
    [self loadDataSource];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    //浮动图
//    [self.lowView addSubview:self.AllSelectedBtn];
    [self.lowView addSubview:self.determineBtn];
    [self.view addSubview:self.lowView];
    
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
//        [self.SELCustomerArr removeAllObjects];
        [_determineBtn setTitle:[NSString stringWithFormat:@"确定(%ld/8)",self.SELCustomerArr.count] forState:UIControlStateNormal];
//        [_AllSelectedBtn setImage:[UIImage imageNamed:@"InvoiceAllBtn"] forState:UIControlStateNormal];
        self.isRefresh = NO;
        self.searchK = @"";
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
    [dic setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"PageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"PageSize"];
    [dic setObject:@"7" forKey:@"SortType"];
    [dic setObject:self.searchK forKey:@"SearchKey"];
    [dic setObject:@"4" forKey:@"CustomerType"];
    
    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomerList" params:dic success:^(id json){
        NSLog(@"------红包客户json is %@-------",json);
        NSMutableArray *arrs = [NSMutableArray array];
        arrs = json[@"CustomerList"];
        if (!self.isRefresh) {
            [self.dataArr removeAllObjects];
            self.isRefresh = YES;
//            [self.SELCustomerArr removeAllObjects];
        }
//        [self.SELCustomerArr removeAllObjects];
        [_determineBtn setTitle:[NSString stringWithFormat:@"确定(%ld/8)",self.SELCustomerArr.count] forState:UIControlStateNormal];
        
        if (arrs.count == 0 && self.dataArr.count == 0){
            self.nullView.alpha = 1;
        }else{
            self.nullView.alpha = 0;
            for (NSDictionary *dic in arrs) {
                CustomModel *model = [CustomModel modalWithDict:dic];
                NSLog(@"%@",model.AppSkbUserId);
                [self.dataArr addObject:model];
            }
        }
        NSLog(@"dataArr:---%ld",self.dataArr.count);
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"-------管客户第一个接口请求失败 error is %@------",error);
    }];
    
    
}
#pragma  mark - UITableViewDelegage&&UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 010) {
        return self.guideHistoryArr.count;
    }
    NSLog(@"走了");
    return self.dataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 010) {
        UITableViewCell *cell1 = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 50, kScreenSize.width, 50)];
        cell1.textLabel.text = self.guideHistoryArr[indexPath.row];
        return cell1;
    }
//    RedPSelCusterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedPSelCusterCell" forIndexPath:indexPath];
    RedPSelCusterCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"RedPSelCusterCell" owner:nil options:nil] firstObject];
    CustomModel *model = self.dataArr[indexPath.row];
    cell.nameLabel.text = model.Name;
    cell.NumberLabel.text = model.Mobile;
    NSLog(@"%@",model.Mobile);
    if (!model.HeadUrl) {
        cell.NameFirstlabel.text = [model.Name substringToIndex:1];
        cell.NameFirstlabel.alpha = 1;
    }else{
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.HeadUrl]];
        cell.NameFirstlabel.alpha = 0;
    }
    if ([self.SELCustomerArr containsObject:model.AppSkbUserId]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 010) {
        return;
    }
    CustomModel *model = self.dataArr[indexPath.row];
    [self.SELCustomerArr removeObject:model.AppSkbUserId];
    [_determineBtn setTitle:[NSString stringWithFormat:@"确定(%ld/8)",self.SELCustomerArr.count] forState:UIControlStateNormal];
//    if (self.SELCustomerArr.count < self.dataArr.count) {
//        [_AllSelectedBtn setImage:[UIImage imageNamed:@"InvoiceAllBtn"] forState:UIControlStateNormal];
//        _isAll = NO;
//    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 010) {
        return;
    }
    if (self.SELCustomerArr.count != 8) {
        CustomModel *model = self.dataArr[indexPath.row];
        [self.SELCustomerArr addObject:model.AppSkbUserId];
        [_determineBtn setTitle:[NSString stringWithFormat:@"确定(%ld/8)",self.SELCustomerArr.count] forState:UIControlStateNormal];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
//    if (self.SELCustomerArr.count == self.dataArr.count) {
//        [_AllSelectedBtn setImage:[UIImage imageNamed:@"InvoiceClickAll"] forState:UIControlStateNormal];
//        _isAll = YES;
//    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [_searchBar setShowsCancelButton:YES];
    [self.view addSubview:self.historyView];

    if (self.guideHistoryArr.count != 0) {
        [_historyView addSubview:self.searchTableView];
        [self.searchTableView reloadData];
    }
    
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
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //搜索历史存本地
    NSString *sstr = [searchBar.text mutableCopy];
    [self.guideHistoryArr addObject:sstr];
    NSMutableArray *mutabArr = [[NSMutableArray alloc] init];
    [mutabArr addObjectsFromArray:self.guideHistoryArr];
    [UserDefault setObject:mutabArr forKey:@"GuideHistoryRP"];
    //请求数据
    self.searchK = searchBar.text;
    _isRefresh = NO;
    [self loadDataSource];
    self.navigationController.navigationBarHidden = NO;
    [searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
    UITableView *vvv = [self.view viewWithTag:1001];
    [vvv removeFromSuperview];
}
#pragma mark - 按钮的点击处理方法
-(void)BtnClick:(UIButton *)button{
    if (button.tag == 101) {//确定按钮
        NSLog(@"个数:%@----数组:%@",self.SELCustomerArr,self.SELCustomerArr);
        if (self.SELCustomerArr.count == 0) {
             [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有选中客人" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil]show];
        }else{
            if (self.FromWhere == FromeRedPacket) {//来自我的红包界面
                SetRedPacketController *setRPacket = [[SetRedPacketController alloc] init];
                setRPacket.sendRedPacketType = sendRedPacketTypeList;
                setRPacket.NumOfPeopleArr = self.SELCustomerArr;
                [self.navigationController pushViewController:setRPacket animated:YES];
            }else{//来自产品详情. 后台执行分享事件
                [self performSelectorInBackground:@selector(cilckEnsureFromProductShare) withObject:nil];
            }
        }
        
    }else if(button.tag == 102){//全选
        if (_isAll) {
//            [_AllSelectedBtn setImage:[UIImage imageNamed:@"InvoiceAllBtn"] forState:UIControlStateNormal];
//            [self.SELCustomerArr removeAllObjects];
//            for (NSInteger i = 0; i<self.dataArr.count; i++) {
//                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:i inSection:0];
//                [self.tableView  deselectRowAtIndexPath:indexPath animated:NO];
//            }
//            
//            NSLog(@"---%ld",self.SELCustomerArr.count);
//            _isAll = NO;
        }else{
//            [_AllSelectedBtn setImage:[UIImage imageNamed:@"InvoiceClickAll"] forState:UIControlStateNormal];
//            [self.SELCustomerArr removeAllObjects];
//            for (NSInteger i = 0; i<self.dataArr.count; i++) {
//                CustomModel *model = self.dataArr[i];
//                [self.SELCustomerArr addObject:model.AppSkbUserId];
//                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:i inSection:0];
//                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            }
//            
//            NSLog(@"---%ld",self.SELCustomerArr.count);
//            _isAll = YES;

        }
        [_determineBtn setTitle:[NSString stringWithFormat:@"确定(%ld/8)",self.SELCustomerArr.count] forState:UIControlStateNormal];

    }else if(button.tag == 105){
        
        [self.searchTableView removeFromSuperview];
        self.guideHistoryArr = nil;
        [UserDefault setObject:self.guideHistoryArr forKey:@"GuideHistoryRP"];
    }
}

#pragma - mark -  从分享页面进入点击确定按钮， 子线程执行

- (void)cilckEnsureFromProductShare{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for (NSString * chatter in self.SELCustomerArr) {
        NSDictionary *ext = @{@"MsgType":@"3",@"MsgValue":self.productJsonString};
        [ChatSendHelper sendTextMessageWithString:@"[产品分享]"
                                       toUsername:chatter
                                      messageType:eMessageTypeChat
                                requireEncryption:NO
                                              ext:ext];
    }
    if (self.SELCustomerArr.count == 1) {
        [APNSHelper defaultAPNSHelper].isJumpChat = YES;
        [APNSHelper defaultAPNSHelper].chatName = self.SELCustomerArr[0];
    }else if(self.SELCustomerArr.count > 1){
        [APNSHelper defaultAPNSHelper].isJumpChatList = YES;
    }
    [self performSelectorOnMainThread:@selector(pushInMainTheard) withObject:nil waitUntilDone:YES];
}



#pragma - mark -  跳转到首页聊天界面
- (void)pushInMainTheard{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.navigationController.tabBarController.selectedViewController = [self.navigationController.tabBarController.viewControllers objectAtIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
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
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
//-(UIButton *)AllSelectedBtn{
//    if (!_AllSelectedBtn) {
//        _AllSelectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 2, 80, 40)];
//        [_AllSelectedBtn setTitle:@"全选" forState:UIControlStateNormal];
////        _AllSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:1];
//        [_AllSelectedBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
//        [_AllSelectedBtn setTitleColor:[UIColor colorWithRed:65.0/255.0 green:121.0/255.0 blue:253.0/255.0 alpha:1] forState:UIControlStateNormal];
//        _AllSelectedBtn.tag = 102;
//        [_AllSelectedBtn setImage:[UIImage imageNamed:@"InvoiceAllBtn"] forState:UIControlStateNormal];
//        [_AllSelectedBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 8,55)];
//        [_AllSelectedBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _AllSelectedBtn;
//}
-(UIView *)lowView{
    if (!_lowView) {
        _lowView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-60-50, kScreenSize.width, 50)];
        _lowView.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:171.0/255.0 blue:252.0/255.0 alpha:1];
    }
    return _lowView;
}
-(UIButton *)determineBtn{
    if (!_determineBtn) {
        _determineBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width/2-40, 2, 80, 40)];
        [_determineBtn setTitle:[NSString stringWithFormat:@"确定(%ld/8)",self.SELCustomerArr.count] forState:UIControlStateNormal];
//        [_determineBtn setTitleColor:[UIColor colorWithRed:33.0/255.0 green:171.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _determineBtn.tag = 101;
        [_determineBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _determineBtn;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kScreenSize.width, kScreenSize.height-60-50-50) style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setEditing:YES animated:YES];
        _tableView.rowHeight = 80;
        _tableView.tag = 011;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
//        [_tableView registerNib:[UINib nibWithNibName:@"RedPSelCusterCell" bundle:nil] forCellReuseIdentifier:@"RedPSelCusterCell"];
    }
    return _tableView;
}
-(UIView *)nullView{
    if (!_nullView) {
        _nullView = [[UIView alloc] initWithFrame:CGRectMake(kScreenSize.width/2-90, 100, 160, 200)];
        _nullView.backgroundColor = [UIColor  colorWithPatternImage: [UIImage imageNamed:@"content_null" ]];
        _nullView.alpha = 0;
    }
   
    return _nullView;
}
-(UITableView *)searchTableView{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, kScreenSize.width-20, kScreenSize.height-49) style:UITableViewStylePlain];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.tag = 010;
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenSize.width-40, 50)];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(footView.frame.size.width/2-50, 0, 100, 30)];
        [btn setTitle:@"清除历史纪录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.tag = 105;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:btn];
        _searchTableView.tableFooterView = footView;
    }
    return _searchTableView;
}
-(UIView *)historyView{
    if (!_historyView) {
        _historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenSize.width, kScreenSize.height-49)];
        _historyView.tag = 1001;
        _historyView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:238.0/255.0 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 30)];
        label.text = @"历史搜索";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor lightGrayColor];
        [_historyView addSubview:label];
        if (self.guideHistoryArr.count != 0) {
            [_historyView addSubview:self.searchTableView];

        }
    }
    return _historyView;
}
-(NSMutableArray *)guideHistoryArr{
    if (!_guideHistoryArr) {
        _guideHistoryArr = [[NSMutableArray alloc] init];
    }
    return _guideHistoryArr;
}
-(NSMutableArray *)SELCustomerArr{
    if (!_SELCustomerArr) {
        _SELCustomerArr = [[NSMutableArray alloc] init];
    }
    return _SELCustomerArr;
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
