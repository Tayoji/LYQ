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
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface MyReadPacketController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *DataArr;
@property (nonatomic,strong) NSMutableArray *MainIDArr;//MainIDs
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic) UILabel *UserInfoName;//名字
@property (nonatomic) UILabel *GetTotalPriceLabel;//总金额
//@property (nonatomic) UILabel *
//@property (nonatomic) UILabel *
//@property (nonatomic) UILabel *
//@property (nonatomic) UILabel *
@end

@implementation MyReadPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的红包";
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavTest"] forBarMetrics:UIBarMetricsDefault];
    //填充用户信息
//    [self.UserInfoHeaderPic sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLYGWHeaderPic]]];
    self.UserInfoName.text = [NSString stringWithFormat:@"%@共发出",[[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKeyLYGWName]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self creatNavOfRight];
    [self loadDataSource];
}

-(void)loadDataSource{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"pageIndex"];
    [dic setValue:@"5" forKey:@"pageSize"];
    [dic setValue:@"2" forKey:@"LuckMoneyType"];
    [IWHttpTool WMpostWithURL:@"/Customer/GetAppLuckMoneyDetailCount" params:dic success:^(id json) {
        
        NSLog(@"-------------------我的红包信息:%@------------------",json);
//        if (![json[@"GetTotalPrice"]  isEqual: @""]) {
//            self.GetTotalPriceLabel.text = [NSString stringWithFormat:@"%@元",json[@"GetTotalPrice"]];
//        }
//        if (![json[@"AllCount"]  isEqual: @""]) {
//            self.AllCountLabel.text = json[@"AllCount"];
//        }
//        if (![json[@"GetTotalCount"]  isEqual: @""]) {
//            self.GetTotalCountLabel.text = json[@"GetTotalCount"];
//        }
//        if (![json[@"GetTotalPrice"]  isEqual: @""]) {
//            self.UseTotalCount.text = json[@"GetTotalPrice"];
//        }
        NSArray *listArr = json[@"AppLuckMoneyDetailList"];
        for (NSDictionary *dic in listArr) {
            [self.MainIDArr addObject:[dic objectForKey:@"AppLuckMoneyMainId"]];
            [self.DataArr addObject:dic];
            
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}
-(void)creatNavOfRight{
    UIButton *myBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [myBtn setImage:[UIImage imageNamed:@"RedPacketHelp"] forState:UIControlStateNormal];
    myBtn.tag = 106;
    [myBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:myBtn];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)BtnClick:(UIButton *)button{
    NSLog(@"又是问号");
}
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
    cell.mixLabel.text = [NSString stringWithFormat:@"%@/%@个",[dic objectForKey:@"UnGetCount"],[dic objectForKey:@"GetCount"]];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyRedPDetailController *detail = [[MyRedPDetailController alloc] init];
   detail.MainString = self.MainIDArr[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 500)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width/2-50, 20, 100, 100)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:@""]];
    }
    return _tableView;
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
