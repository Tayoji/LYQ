//
//  TimeTipTableViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/25.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoseModel.h"

@interface TimeTipTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (nonatomic, strong)ChoseModel *modelC;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
