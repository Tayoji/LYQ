//
//  NoRedPacketDetailCell.h
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/12.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoRedPacketDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *HeadtitLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumLabel;
@property (weak, nonatomic) IBOutlet UILabel *StateLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;

@end
