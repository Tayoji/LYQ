//
//  TimeTipTableViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/25.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "TimeTipTableViewCell.h"

@implementation TimeTipTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellID = @"TimeTipTableViewCell";
    TimeTipTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"TimeTipTableViewCell" owner:nil options:nil]firstObject];
    if (cell == nil) {
        cell = [[TimeTipTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


- (void)setModelC:(ChoseModel *)modelC{
    _modelC = modelC;
    _timeL.text = modelC.PushDateText;
}

- (void)setTimeL:(UILabel *)timeL{
    _timeL = timeL;
    timeL.layer.masksToBounds = YES;
    timeL.layer.cornerRadius = 5;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
//    CGFloat width = self.contentView.frame.size.width;
//    CGFloat height = self.contentView.frame.size.height;
//    self.timeL.frame = CGRectMake((width-120)/2, 13, 120, 25);
}


- (void)awakeFromNib {
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
