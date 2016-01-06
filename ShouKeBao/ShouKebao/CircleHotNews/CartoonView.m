//
//  CartoonView.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "CartoonView.h"
#define Duration 0.2

@implementation CartoonView
static UIButton *_cartoonView;
static CGPoint startPoint;
static CGPoint originPoint;
static CGFloat _height;
static CGFloat _width;
//static BOOL contain;

+(void)cartoonView:(UIButton *)cartoonView cgsize:(CGSize)cgsize{
    _cartoonView = cartoonView;
    _height = cgsize.height;
    _width = cgsize.width;
    UIPanGestureRecognizer *PanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
    [_cartoonView addGestureRecognizer:PanGesture];
}
+ (void)buttonLongPressed:(UIPanGestureRecognizer *)panGesture{
    
    UIButton *btn = (UIButton *)panGesture.view;
    if (panGesture.state == UIGestureRecognizerStateBegan){
        
        startPoint = [panGesture locationInView:panGesture.view];
        originPoint = btn.center;
        [UIView animateWithDuration:Duration animations:^{
            btn.transform = CGAffineTransformMakeScale(1, 1);
            btn.alpha = 1;
        }];
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        CGPoint newPoint = [panGesture locationInView:panGesture.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        NSLog(@"height =  %f,", _height);
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
        
        if (CGRectGetMinY(btn.frame) < 0) {
            originPoint = CGPointMake(btn.center.x, 35);
        }else if (CGRectGetMaxY(btn.frame)>= _height){
            originPoint = CGPointMake(btn.center.x, _height-40);
            
        }else if (CGRectGetMinX(btn.frame)<=0){
            originPoint = CGPointMake(25, btn.center.y);
        }else if (CGRectGetMaxX(btn.frame)>= _width){
            originPoint = CGPointMake(_width-25, btn.center.y);
        }else{
            [UIView animateWithDuration:Duration animations:^{
                originPoint = btn.center;
                btn.alpha = 1;
            }];
        }
    }else if (panGesture.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:Duration animations:^{
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            btn.center = originPoint;
        }];
    }
}




@end
