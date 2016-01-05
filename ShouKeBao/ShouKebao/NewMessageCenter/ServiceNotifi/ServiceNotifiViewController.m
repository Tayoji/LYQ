//
//  ServiceNotifiViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/4.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "ServiceNotifiViewController.h"
#import "ServiceNotifiTableViewCell.h"
#import "TimerCell.h"
@interface ServiceNotifiViewController ()
@end

@implementation ServiceNotifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"业务通知";
    [self serviceNotifiRightBarItem];
   
    
    
    
    
    
    
    
    
    
    
    
}

#pragma mark - UITableViewDelegate&&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//   
//    
//    
//}


-(void)serviceNotifiRightBarItem{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(pushEditView)];
    self.navigationItem.rightBarButtonItem= barItem;
}

- (void)pushEditView{
    
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
