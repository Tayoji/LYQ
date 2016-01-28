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
        UIImageView *pic = [[UIImageView alloc]init];
        pic.userInteractionEnabled = YES;
        self.pic = pic;
        [self.contentView addSubview:pic];
        
        UILabel *title = [[UILabel alloc]init];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:13.0];
        
        self.title = title;
        [self.contentView addSubview:title];
        
        
        
    }
    return self;
}


- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
   
    CGFloat width = layoutAttributes.bounds.size.width;
    CGFloat height = layoutAttributes.bounds.size.height;
    NSLog(@"... %f", height);
    self.pic.frame = CGRectMake((width - 50)/2, 10, 50, 50);
    self.title.frame = CGRectMake(0, CGRectGetMaxY(self.pic.frame), width, height-CGRectGetMaxY(self.pic.frame));
    
}

- (void)setModel:(DefineShareModel *)model{
    _model = model;
    self.pic.image = [UIImage imageNamed:[model valueForKey:@"pic"]];
    self.title.text = [model valueForKey:@"title"];
    
}

- (void)awakeFromNib {
    // Initialization code
}

@end
