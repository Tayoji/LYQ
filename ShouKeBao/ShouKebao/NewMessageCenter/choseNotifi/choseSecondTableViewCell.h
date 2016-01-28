//
//  choseSecondTableViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/25.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModal.h"
#import "MGSwipeTableCell.h"
#import "ChoseModel.h"
@interface choseSecondTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIView *viewBackG;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *choseLSmal;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@property (weak, nonatomic) IBOutlet UILabel *choseEveryDayL;
@property (weak, nonatomic) IBOutlet UITableView *tableViewDetail;
@property (nonatomic, strong)ChoseModel *model;
@property (nonatomic, strong)NSMutableArray *arrData;
+ (instancetype)cellWithTableView:(UITableView *)tableView naV:(UINavigationController *)naV;

@end
