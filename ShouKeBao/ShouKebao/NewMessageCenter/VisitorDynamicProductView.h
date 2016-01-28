//
//  VisitorDynamicProductView.h
//  ShouKeBao
//
//  Created by 冯坤 on 16/1/7.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitorDynamicProductView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *ProductImage;//产品图片
@property (strong, nonatomic) IBOutlet UILabel *ProductDescribtion;//产品描述
@property (strong, nonatomic) IBOutlet UILabel *CodeNum;//产品编号
@property (strong, nonatomic) IBOutlet UILabel *MenshiPrice;//门市价
@property (strong, nonatomic) IBOutlet UILabel *TonghangPrice;//同行价
@property (weak, nonatomic) IBOutlet UILabel *tonghangRect;

@property (weak, nonatomic) IBOutlet UILabel *menshiRect;
@property (weak, nonatomic) IBOutlet UILabel *RMBChina;
@end
