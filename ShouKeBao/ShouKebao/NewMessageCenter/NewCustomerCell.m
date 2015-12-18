//
//  NewCustomerCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import "NewCustomerCell.h"
#import "CustomDynamicModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+FKTools.h"
#import "ChatViewController.h"
@implementation NewCustomerCell
{
    NSArray *_IMUserMatches;
}

- (void)awakeFromNib {

    // Initialization code
}
-(void)layoutSubviews{
    self.TitleView.textContainerInset = UIEdgeInsetsZero;
    self.TitleView.font = [UIFont systemFontOfSize:14];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPressed:)];
    [self.TitleView addGestureRecognizer:tap];
    self.TitleView.editable = NO;
    self.TitleView.allowsEditingTextAttributes = NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CustomDynamicModel *)model{
    _model = model;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.HeadUrl] placeholderImage:[UIImage imageNamed:@"customtouxiang"]];
    if ([model.DynamicType intValue]==1) {
        self.TitleImage.image = [UIImage imageNamed:@"dongtaixin"];
    }else if([model.DynamicType intValue]==2){
        self.TitleImage.image = [UIImage imageNamed:@"dongtaizhanghu"];
    }
    self.TimeLabel.text = model.CreateTimeText;
    
    
    _IMUserMatches = [model.DynamicContent TextCheckingResultArrayWithPattern:@"￥.+￥"];
    if (!_IMUserMatches.count) {
        _IMUserMatches = [model.DynamicContent TextCheckingResultArrayWithPattern:@"¥.+¥"];
    }
    NSMutableAttributedString * str = [model.DynamicContent attributedStringMatchSearchKeyWords];
    str = [str.string attributedStringMatchIMUser];
    self.TitleView.attributedText = str;

    
    self.custNameLabel.text = model.NickName;
    self.custNumLabel.text = model.CustomerMobile;
}

//开始点击；
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    [self removeViewInTextView];
    
    CGPoint point= [touch locationInView:self.TitleView];
    [self isPointInRect:point];
    return YES;
}
//结束点击
-(void)bubbleViewPressed:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    CGPoint point = [tap locationInView:self.TitleView];
    if ([self isPointInRect:point]) {
        [self openIM];
        [self removeViewInTextView];
    }
    
}

//长按出现
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.TitleView];
    if ([self isPointInRect:point]) {
        [self openIM];
        [self removeViewInTextView];
    }
    return YES;
}
//判断是否是选中范围

- (BOOL)isPointInRect:(CGPoint)point{
    if (!_IMUserMatches.count) {
        return NO;
    }
    NSRange oldRange = ((NSTextCheckingResult *)_IMUserMatches[0]).range;
    NSRange newRange = NSMakeRange(oldRange.location, oldRange.length - 2);
    self.TitleView.selectedRange = newRange;
    //找出匹配的字符串在textView中的位置，再判断point是否在textView中选中矩形范围内；
    NSArray * rects = [self.TitleView selectionRectsForRange: self.TitleView.selectedTextRange];
    for (UITextSelectionRect *rect in rects) {
        if (CGRectContainsPoint(rect.rect, point)) {
            UIView * colorView = [[UIView alloc]initWithFrame:rect.rect];
            colorView.backgroundColor  = [UIColor colorWithRed:191/255.0 green:223/255.0 blue:253/255.0 alpha:0.5];
            colorView.tag = 1024;
            [self.TitleView addSubview:colorView];
            return YES;
        }
    }
    return NO;
}

//去除阴影
- (void)removeViewInTextView{
    [self.TitleView resignFirstResponder];
    for (UIView * view in self.TitleView.subviews) {
        if (view.tag == 1024) {
            [view removeFromSuperview];
        }
    }
}
//跳转IM界面
-(void)openIM{
    NSLog(@"%@", self.model.AppSkbUserId);
    ChatViewController * charV = [[ChatViewController alloc]initWithChatter:self.model.AppSkbUserId conversationType:eConversationTypeChat];
    [self.NAV pushViewController:charV animated:YES];
}

@end
