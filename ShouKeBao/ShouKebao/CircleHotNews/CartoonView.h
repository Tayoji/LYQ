//
//  CartoonView.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CartoonView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, strong)UIImageView *imageV;
//+(void)cartoonView:(UIButton *)cartoonView height:(CGFloat)height;
+(void)cartoonView:(UIButton *)cartoonView cgsize:(CGSize)cgsize;
@end
