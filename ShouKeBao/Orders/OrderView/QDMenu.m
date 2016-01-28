//
//  QDMenu.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QDMenu.h"
#import "UIImage+QD.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "ButtonList.h"
@interface QDMenu() <UITableViewDataSource,UITableViewDelegate>

@end

@implementation QDMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImageWithName:@"bubble" left:0.6 top:0.5];
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOpacity = 1;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.anchorPoint = CGPointMake(0, 0);
    }
    return self;
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -67, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - private
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.tip.length) {
        self.tableView.frame = CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10);
    }else{
        self.tableView.frame = CGRectMake(0, 5, self.frame.size.width, self.frame.size.height-5);
    }
    
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation1.duration = 0.3;
    
    animation1.values = @[@(0.1),@(1.05),@(1.0)];

    [self.layer addAnimation:animation1 forKey:nil];
}

- (void)removeFromSuperview
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"...%d", self.dataSource.count);
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"menucell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tintColor = [UIColor colorWithRed:249/255.0 green:132/255.0 blue:12/255.0 alpha:1];
    }
    if (!self.tip.length) {
        if (_currentIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = self.dataSource[indexPath.row][@"Text"];
        
    }else{
        tableView.layer.masksToBounds = YES;
        tableView.layer.cornerRadius = 3;
        ButtonList *bb = self.dataSource[indexPath.row];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, tableView.frame.size.width-10, 40)];
        l.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:l];
        l.text = bb.text;
//        cell.textLabel.text = bb.text;
        
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tip.length) {
        return 40;
    }else{
        return 45;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.tip.length) {
        // 取消前一个选中的，就是单选啦
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
        // 选中操作
        UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        // 保存选中的
        _currentIndex = indexPath.row;
        switch (indexPath.row) {
            case 0:{
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"OrderAllSX" attributes:dict];
            }
                break;
            case 1:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"OrderTodaySX" attributes:dict];
                
                
            }
                break;
            case 2:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"OrderYesterdaySX" attributes:dict];
                
            }
                break;
            case 3:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"OrderLastWeekSX" attributes:dict];
                
            }
                break;
            case 4:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"OrderLastTwoWeekSX" attributes:dict];
                
            }
                break;
            case 5:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"OrderLastMonthSX" attributes:dict];
                
            }
                break;
                
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        [_delegate menu:self didSelectRowAtIndexPath:indexPath];
    }
}

@end
