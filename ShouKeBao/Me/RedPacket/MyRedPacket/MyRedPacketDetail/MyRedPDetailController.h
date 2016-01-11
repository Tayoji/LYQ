//
//  MyRedPDetailController.h
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/11.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@interface MyRedPDetailController : SKViewController
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *LuckContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *MixLabel;
@property (weak, nonatomic) IBOutlet UILabel *DescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *OutLuckMixLabel;
@property (weak, nonatomic) IBOutlet UILabel *OutTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *InsideuckMixLabel;
@property (weak, nonatomic) IBOutlet UILabel *InsideTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *NearbyLuckMixLabel;
@property (weak, nonatomic) IBOutlet UILabel *NearbyTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *LuckMoneyGetCountLabael;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *MainString;
@end
