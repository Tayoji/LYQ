//
//  OpprotunityFreqCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import "OpprotunityFreqCell.h"
#import "CustomDynamicModel.h"
#import "UIImageView+WebCache.h"
#import "ProductModal.h"
#import "NSString+FKTools.h"
#import "ChatViewController.h"
@interface OpprotunityFreqCell ()
{
    NSArray *_IMUserMatches;
}

@property (strong, nonatomic) IBOutlet UIImageView *diImage;
@property (strong, nonatomic) IBOutlet UILabel *diY;
@property (strong, nonatomic) IBOutlet UIImageView *liImage;
@property (strong, nonatomic) IBOutlet UILabel *liY;

@property (strong, nonatomic) IBOutlet UIImageView *songImage;
@property (strong, nonatomic) IBOutlet UILabel *songY;
@end

@implementation OpprotunityFreqCell

- (void)awakeFromNib {

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

}
-(void)setModel:(CustomDynamicModel *)model{

    _model = model;
    [self.HeadImage sd_setImageWithURL:[NSURL URLWithString:model.ProductdetailModel.PicUrl] placeholderImage:[UIImage imageNamed:@"customtouxiang"]];
    self.TitleImage.image = [UIImage imageNamed:@"dongtaichanpin"];
    self.TimerLabel.text = model.CreateTimeText;
    
    
    _IMUserMatches = [model.DynamicContent TextCheckingResultArrayWithPattern:@"￥.+￥"];
    if (!_IMUserMatches.count) {
        _IMUserMatches = [model.DynamicContent TextCheckingResultArrayWithPattern:@"¥.+¥"];
    }
    NSMutableAttributedString * str = [model.DynamicContent attributedStringMatchSearchKeyWords];
    str = [str.string attributedStringMatchIMUser];
    self.TitleView.attributedText = str;

    
    self.topTitleLab.text = model.DynamicTitle;
    self.DiLabel.text = model.ProductdetailModel.PersonCashCoupon;
    self.SongLabel.text = model.ProductdetailModel.PersonBackPrice;
    self.ProfitLabel.text = model.ProductdetailModel.PersonProfit;
    self.MenShiLabel.text = model.ProductdetailModel.PersonPrice;
    self.SameJobLabel.text = model.ProductdetailModel.PersonPeerPrice;
    self.NumberLabel.text = model.ProductdetailModel.Code;
    self.BodyLabel.text = model.ProductdetailModel.Name;
    NSLog(@"%@--%@--%@", model.ProductdetailModel.PersonCashCoupon, model.ProductdetailModel.PersonBackPrice, model.ProductdetailModel.PersonProfit);
    if (![model.ProductdetailModel.IsComfirmStockNow intValue]) {
        self.sandian.hidden = YES;
    }
    if ([model.ProductdetailModel.PersonCashCoupon isEqualToString:@""]) {
        self.diImage.hidden = YES;
        self.diY.hidden = YES;
    }
    if ([model.ProductdetailModel.PersonBackPrice isEqualToString:@""]) {
        self.songImage.hidden = YES;
        self.songY.hidden = YES;
    }
    if ([model.ProductdetailModel.PersonProfit isEqualToString:@""]) {
        self.liImage.hidden = YES;
        self.liY.hidden = YES;
    }
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
