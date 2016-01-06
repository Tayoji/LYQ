//
//  ServiceNotifiTableViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/4.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceModel.h"
@interface ServiceNotifiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *circlePayBao;
@property (weak, nonatomic) IBOutlet UILabel *ditailL;
@property (weak, nonatomic) IBOutlet UILabel *lookDetailL;
@property (weak, nonatomic) IBOutlet UIButton *jianTouB;
@property (nonatomic, strong)ServiceModel *serviceModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
