//
//  OrderCell.h
//  ShouKeBao
//
//  Created by Chard on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
@class QDMenu;
@class OrderModel;
@class OrderCell;
@class OrderTmpView;

@protocol OrderCellDelegate <NSObject>
- (void)checkDetailAtIndex:(NSInteger)index;
@end

@protocol upAndDownBtnDelegate <NSObject>
- (void)DidMenumSelectDownBtn:(UIButton *)downBtn btnList:(NSMutableArray *)btnList andCurrentCell:(OrderCell *)cell;
- (void)cancleQdMenumView:(QDMenu *)qdMenuView;
@end

@interface OrderCell : MGSwipeTableCell

@property (nonatomic,strong) OrderModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) OrderTmpView *orderTmpView;

@property (nonatomic,weak) id<OrderCellDelegate> orderDelegate;
@property (nonatomic,weak) id<upAndDownBtnDelegate>upAndDownDelegate;

// 底部按钮
@property (weak, nonatomic) UIView *bottomView;
@end
