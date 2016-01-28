//
//  TerraceMessageController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/6.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TerraceMessageController.h"
#import "TerraceMessCell.h"
#import "TimerCell.h"
#import "IWHttpTool.h"
#import "TerraceMessageModel.h"
#import "TerracedetailViewController.h"
#import "MBProgressHUD+MJ.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface TerraceMessageController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *noticeArray;
@end

@implementation TerraceMessageController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBao_TerraceMessageController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBao_TerraceMessageController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"平台消息";
    [self loadDataSource];
    [_tableView registerNib:[UINib nibWithNibName:@"TerraceMessCell" bundle:nil] forCellReuseIdentifier:@"TerraceMessCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TimerCell" bundle:nil] forCellReuseIdentifier:@"TimerCell"];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.showsVerticalScrollIndicator = NO;
    
}

- (void)loadDataSource{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [IWHttpTool postWithURL:@"Notice/GetNoticeList" params:nil success:^(id json) {
        if ([json[@"IsSuccess"]integerValue]) {
            NSArray * noticeList = json[@"NoticeList"];
            NSLog(@"%@", json);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            for (NSDictionary * dic in noticeList) {
                TerraceMessageModel * model = [TerraceMessageModel modelWithDic:dic];
                [self.noticeArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError * eror) {
    }];
}
-(NSMutableArray *)noticeArray{
    if (!_noticeArray) {
        _noticeArray = [NSMutableArray array];
    }
    return _noticeArray;
}

#pragma mark - UITableViewDelegate&&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.noticeArray.count*2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2 == 0) {
        return 50;
    }
    if (kScreenSize.width == 320) {
        return 269;
    }else if (kScreenSize.width == 375) {
        return 286;
    }else if(kScreenSize.width == 414){
        return 299;
    }
    return 299;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimerCell *cell;
    TerraceMessCell *trcell;
    TerraceMessageModel * model = self.noticeArray[indexPath.row/2];
    if (indexPath.row%2 == 0) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"TimerCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.TimerLabel.text = model.CreatedDateText;
        return cell;
    }
    trcell = [tableView dequeueReusableCellWithIdentifier:@"TerraceMessCell" forIndexPath:indexPath];
    trcell.model = model;
    return trcell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBao_serviceNotice1" attributes:dict];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TerraceMessageModel * model = self.noticeArray[indexPath.row/2];
    TerracedetailViewController * detailVC = [[TerracedetailViewController alloc]init];
    detailVC.linkUrl = model.LinkUrl;
    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
