//
//  DefineShareViewCollectionViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/7.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "DefineShareViewCollectionViewCell.h"

@implementation DefineShareViewCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIButton *btn = [[UIButton alloc]init];
//        btn.backgroundColor = [UIColor greenColor];
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(60, -42, 0, 0)];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 14, 40, 0)];
//        self.shareBtn = btn;
//        [self.contentView addSubview:btn];
        
        UIImageView *pic = [[UIImageView alloc]init];
        pic.userInteractionEnabled = YES;
        self.pic = pic;
        [self.contentView addSubview:pic];
        
        UILabel *title = [[UILabel alloc]init];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:14.0];
        
        self.title = title;
        [self.contentView addSubview:title];
        
        
        
    }
    return self;
}


- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
   
    CGFloat width = layoutAttributes.bounds.size.width;
    CGFloat height = layoutAttributes.bounds.size.height;
    
//    self.shareBtn.frame = CGRectMake(0, 0, width, height);
    self.pic.frame = CGRectMake((width - 50)/2, 10, 50, 50);
    self.title.frame = CGRectMake(0, CGRectGetMaxY(self.pic.frame)+5, width, height-CGRectGetMaxY(self.pic.frame)-15);
    
}

- (void)setModel:(DefineShareModel *)model{
    _model = model;
    
//    [_shareBtn setTitle:[model valueForKey:@"title"] forState:UIControlStateNormal];
//    [_shareBtn setImage:[UIImage imageNamed:[model valueForKey:@"pic"]] forState:UIControlStateNormal];
    self.pic.image = [UIImage imageNamed:[model valueForKey:@"pic"]];
    self.title.text = [model valueForKey:@"title"];
    
}





- (void)awakeFromNib {
    // Initialization code
}

@end
