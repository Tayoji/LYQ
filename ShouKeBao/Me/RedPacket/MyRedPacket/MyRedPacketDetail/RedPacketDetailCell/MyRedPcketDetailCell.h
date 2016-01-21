//
//  MyRedPcketDetailCell.h
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/12.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRedPcketDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *headtitLabel;
@property (weak, nonatomic) IBOutlet UILabel *StateLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *DataLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
- (IBAction)CardIdButton:(UIButton *)sender;
@property (nonatomic,copy) NSString *UrlStr;
@property (weak, nonatomic) IBOutlet UIButton *CardIdButton;
@property (nonatomic,strong) UINavigationController *nav;

@end
