//
//  DefineShareViewCollectionViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/7.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefineShareModel.h"
@interface DefineShareViewCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (nonatomic, strong)DefineShareModel *model;
@end
