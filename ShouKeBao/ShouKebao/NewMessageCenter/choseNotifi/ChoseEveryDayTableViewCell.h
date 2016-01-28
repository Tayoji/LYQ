//
//  ChoseEveryDayTableViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/22.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModal.h"
#import "MGSwipeTableCell.h"

#define gap 10

@class ProductModal;
@interface ChoseEveryDayTableViewCell : MGSwipeTableCell
@property (nonatomic,assign) BOOL isFlash;
@property (nonatomic,assign) BOOL quanIsZero;
@property (nonatomic,assign) BOOL fanIsZero;
@property (strong, nonatomic) ProductModal *modal;
@property (nonatomic,assign) BOOL isHistory;

+(instancetype)cellWithTableView:(UITableView *)tableView;


@end
