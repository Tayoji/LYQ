//
//  TimerCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TimerCell.h"

@implementation TimerCell

- (void)awakeFromNib {
    
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
