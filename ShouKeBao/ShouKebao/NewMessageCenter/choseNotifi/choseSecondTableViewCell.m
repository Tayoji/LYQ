//
//  choseSecondTableViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/25.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "choseSecondTableViewCell.h"
#import "ChoseEveryDayTableViewCell.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "MGSwipeButton.h"
#import "SwipeView.h"
#import "ProductModal.h"
#import "ProduceDetailViewController.h"
static id _naV;
@interface choseSecondTableViewCell()<UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)ProductModal *modelP;
@end

@implementation choseSecondTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView naV:(UINavigationController *)naV{
    _naV = naV;
    choseSecondTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"choseSecondTableViewCell" owner:nil options:nil]firstObject];
    static NSString *cellID = @"choseSecondTableViewCell";
    if (cell == nil) {
        cell = [[choseSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setTableViewDetail:(UITableView *)tableViewDetail{
    _tableViewDetail = tableViewDetail;
    tableViewDetail.delegate = self;
    tableViewDetail.dataSource = self;
    tableViewDetail.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tableViewDetail.layer.borderWidth = 0.7;
    tableViewDetail.layer.masksToBounds = YES;
    tableViewDetail.layer.cornerRadius = 10;
    tableViewDetail.scrollEnabled = NO;
}
//- (void)setModel:(ChoseModel *)model{
//    _model = model;
//    _choseEveryDayL.text = model.Copies;
//}
- (void)setArrData:(NSMutableArray *)arrData{
    _arrData = arrData;
    for (int i = 0; i < arrData.count; i++) {
        ProductModal *model = [ProductModal modalWithDict:[self.arrData[i]Productdetail]];
        [self.dataArr addObject:model];
    }
    _choseEveryDayL.text = [arrData[0] valueForKey:@"Copies"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.viewBackG;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoseEveryDayTableViewCell *cell = [ChoseEveryDayTableViewCell cellWithTableView:tableView];
    cell.modal = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.delegate = self;
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    cell.rightButtons = [self createRightButtons:self.dataArr[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProduceDetailViewController *produceDetailVC = [[ProduceDetailViewController alloc]init];
    produceDetailVC.produceUrl = [self.dataArr[indexPath.row]LinkUrl];
    produceDetailVC.shareInfo = [self.dataArr[indexPath.row]ShareInfo];
    produceDetailVC.productName = [self.dataArr[indexPath.row]Name];
    [_naV pushViewController:produceDetailVC animated:YES];
    [self.tableViewDetail deselectRowAtIndexPath:[self.tableViewDetail indexPathForSelectedRow] animated:YES];
}


#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction{
    return YES;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings{
    return [NSArray array];
}
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion{
    
    NSIndexPath *indexPath = [self.tableViewDetail indexPathForCell:cell];
    ProductModal *model = _dataArr[indexPath.row];
    NSString *result = [NSString stringWithFormat:@"%d",![model.IsFavorites integerValue]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:model.ID forKey:@"ProductID"];
    [dic setObject:result forKey:@"IsFavorites"];
    
    [IWHttpTool WMpostWithURL:@"/Product/SetProductFavorites" params:dic success:^(id json) {
        if ([model.IsFavorites isEqualToString:@"0"]) {
        }
        if ([json[@"IsSuccess"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"操作成功"];
            model.IsFavorites = [NSString stringWithFormat:@"%d",![model.IsFavorites integerValue]];
            [self.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
            [self.tableViewDetail reloadData];
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"产品收藏网络请求失败");
    }];
    
    return YES;
}

#pragma mark - 滑动布局
- (NSArray *)createRightButtons:(ProductModal *)model{
    NSMutableArray * result = [NSMutableArray array];
    UIColor * colors[2] = {[UIColor clearColor], [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1]};
    for (int i = 0; i < 2; i ++){
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:nil backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"Convenience callback received (right). %d",i);
            return YES;
        }];
        if (i == 0){
            NSString *img = [model.IsFavorites isEqualToString:@"1"] ? @"uncollection_icon" : @"collection_icon";
            [button setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        }else{
            button.enabled = NO;
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [button setTitleColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1] forState:UIControlStateNormal];
        CGRect frame = button.frame;
        frame.size.height = 120;
        frame.size.width = i == 1 ? 140 : 42;
        button.frame = frame;
        if (i == 1) {
            SwipeView *swipe = [SwipeView addSubViewLable:button Model:model];
            [button addSubview:swipe];
        }
        [result addObject:button];
    }
    return result;
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
