//
//  MyRedPcketDetailCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/12.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "MyRedPcketDetailCell.h"
#import "OrderDetailViewController.h"
@implementation MyRedPcketDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)CardIdButton:(UIButton *)sender {
    
    OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detail.url = self.UrlStr;
    detail.title = @"订单详情";
    [self.nav pushViewController:detail animated:YES];
}
@end
