//
//  FKRedPacketStateCell.m
//  ShouKeBao
//
//  Created by 冯坤 on 16/1/12.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "FKRedPacketStateCell.h"

@interface FKRedPacketStateCell()

@property (nonatomic, strong)UIView * grayBackgroundView;
@property (nonatomic, strong)UILabel * stateMsgLab;
@property (nonatomic, strong)UIImageView * iconImage;

@end

@implementation FKRedPacketStateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    self.backgroundColor = [UIColor clearColor];
    self.grayBackgroundView = [[UIView alloc]init];
    self.grayBackgroundView.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1];
    self.grayBackgroundView.layer.cornerRadius = 4;
    [self addSubview:self.grayBackgroundView];
    
    
    self.iconImage = [[UIImageView alloc]init];
    self.iconImage.image = [UIImage imageNamed:@"aa"];
    [self addSubview:self.iconImage];
    
    
    self.stateMsgLab = [[UILabel alloc]init];
    self.stateMsgLab.backgroundColor = [UIColor clearColor];
    self.stateMsgLab.textAlignment = NSTextAlignmentCenter;
    self.stateMsgLab.font = [UIFont systemFontOfSize:14];
    self.stateMsgLab.textColor = [UIColor whiteColor];
    [self addSubview:self.stateMsgLab];
    
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setStateMsg:(NSString *)stateMsg{
    _stateMsg = stateMsg;
    
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:stateMsg];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:237/255.0 green:153/255.0 blue:73/255.0 alpha:1.0] range:NSMakeRange(stateMsg.length - 2, 2)];
    self.stateMsgLab.attributedText = attributeStr;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.grayBackgroundView.frame = self.bounds;
    self.grayBackgroundView.frame = CGRectInset(self.grayBackgroundView.frame, ([UIScreen mainScreen].bounds.size.width - 200)/2.0,0);
    
    
    self.stateMsgLab.frame = CGRectMake(0, 2, 150, 25);
    self.stateMsgLab.center = self.grayBackgroundView.center;
    
    self.iconImage.frame = CGRectMake(CGRectGetMinX(self.stateMsgLab.frame)-15, 4, 15, 17);
    
}
@end
