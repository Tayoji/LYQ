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

@interface choseSecondTableViewCell()<UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)ProductModal *modelP;
@end

@implementation choseSecondTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"choseSecondTableViewCell";
    choseSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[choseSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       // [self setup];
    }
    return self;
}

- (void)setup{
    UIView *viewBackG = [[UIView alloc]init];
    self.viewBackG = viewBackG
    ;
    [self.contentView addSubview:viewBackG];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView = self.icon;
    [self.viewBackG addSubview:imageView];
    
    UILabel *choseLSmal = [[UILabel alloc]init];
    choseLSmal.textAlignment = NSTextAlignmentLeft;
    choseLSmal.text = @"每日精选";
    self.choseLSmal = choseLSmal;
    [self.viewBackG addSubview:choseLSmal];
    
    UIView *lineV = [[UIView alloc]init];
    self.lineV = lineV;
    self.lineV.backgroundColor = [UIColor blackColor];
    self.lineV.alpha = 0.2;
    [self.viewBackG addSubview:lineV];
    
    UILabel *choseEveryDayL = [[UILabel alloc]init];
    choseEveryDayL.textAlignment = NSTextAlignmentLeft;
    self.choseEveryDayL = choseLSmal;
    [self.viewBackG addSubview:choseEveryDayL];
    
    UITableView *tableView = [[UITableView alloc]init];
//    tableView.tableHeaderView = self.viewBackG;
    tableView = self.tableViewDetail;
    [self.contentView addSubview:tableView];
    self.tableViewDetail.delegate = self;
    self.tableViewDetail.dataSource = self;
    self.tableViewDetail.scrollEnabled = NO;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    self.viewBackG.frame = CGRectMake(0, 0, width, 75);
    self.icon.frame = CGRectMake(15, 0, 30, 30);
    self.choseLSmal.frame = CGRectMake(CGRectGetMaxX(self.icon.frame)+10, 5, width-(CGRectGetMaxX(self.icon.frame)+10)-10, 30);
    self.lineV.frame = CGRectMake(10, CGRectGetMaxY(self.icon.frame)+10, width-20, 1);
    self.choseEveryDayL.frame = CGRectMake(15, CGRectGetMaxY(self.lineV.frame), width-30, 30);
    self.tableViewDetail.frame = CGRectMake(0, 0, width, height);
    
}
- (void)setModel:(ChoseModel *)model{
    _model = model;
    _icon.image = [UIImage imageNamed:@"iconfont-choseToday"];
    _choseEveryDayL.text = model.PushDateText;
   self.modelP = [ProductModal modalWithDict:model.Productdetail];
    NSLog(@"... %@  %@ %@  %@", self.modelP, model.PushDateText, model.Productdetail, self.modelP);
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoseEveryDayTableViewCell *cell = [ChoseEveryDayTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.modal = self.modelP;
   
//    cell.delegate = self;
//    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
//    cell.rightButtons = [self createRightButtons:self.dataArr[indexPath.row]];
    return cell;
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
