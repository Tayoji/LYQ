//
//  ServiceNotifiTableViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/4.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "ServiceNotifiTableViewCell.h"

@implementation ServiceNotifiTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellID = @"ServiceNotifiTableViewCell";
    ServiceNotifiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceNotifiTableViewCell" owner:nil options:nil] lastObject];
    }

    return cell;
}

- (void)setServiceModel:(ServiceModel *)serviceModel{
    _serviceModel = serviceModel;
    self.timeL.text = [NSString stringWithFormat:@"%@", serviceModel.CreateTimeText];
    self.circlePayBao.text = [NSString stringWithFormat:@"%@", serviceModel.MessageTypeText];
    self.ditailL.text = [NSString stringWithFormat:@"%@",serviceModel.MessageTitle];
}



- (void)setMessageTypeWith:(NSString *)messageType{
    switch ([messageType integerValue]) {
        case 1:
            self.circlePayBao.text = @"圈付宝充值";
            break;
        case 2:
            self.circlePayBao.text = @"圈付宝收支";
            break;
        case 3:
            self.circlePayBao.text = @"圈付宝现金券";
            break;
        case 4:
            self.circlePayBao.text = @"订单流程";
            break;
        default:
            break;
    }
}
















- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
