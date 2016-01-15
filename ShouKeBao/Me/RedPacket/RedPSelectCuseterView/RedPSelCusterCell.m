//
//  RedPSelCusterCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/7.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "RedPSelCusterCell.h"

@implementation RedPSelCusterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.headImageView.backgroundColor = [UIColor colorWithRed:47/255.0 green:188/255.0 blue:250/255.0 alpha:1];
    // Configure the view for the selected state
}

@end
