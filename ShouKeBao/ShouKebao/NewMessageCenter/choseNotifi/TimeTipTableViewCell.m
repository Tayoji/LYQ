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
    TimeTipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TimeTipTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//
//        UILabel *timeL = [[UILabel alloc]init];
//        timeL.font = [UIFont systemFontOfSize:14.0f];
//        timeL.textAlignment = NSTextAlignmentCenter;
//        timeL.textColor = [UIColor whiteColor];
//        timeL.backgroundColor = [UIColor lightGrayColor];
//        timeL.layer.masksToBounds = YES;
//        timeL.layer.cornerRadius = 5;
//        [self.contentView addSubview:timeL];
//        self.timeL = timeL;
        
        }
    return self;
}
- (void)setModelC:(ChoseModel *)modelC{
    _modelC = modelC;
    _timeL.text = modelC.PushDate;
}

- (void)setTimeL:(UILabel *)timeL{
    _timeL = timeL;
    timeL.layer.masksToBounds = YES;
    timeL.layer.cornerRadius = 5;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    self.timeL.frame = CGRectMake((width-120)/2, 13, 120, 25);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
