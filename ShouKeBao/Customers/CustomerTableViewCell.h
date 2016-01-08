//
//  CustomerTableViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/6.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomModel.h"
@protocol transformPerformation <NSObject>

- (void)transformPerformation:(CustomModel *)model;
- (void)tableViewReloadData;
- (void)tipInviteViewShow:(NSString *)telStr;
- (void)pushCustomerDetailVC:(NSString *)customerID andAppSkbUserId:(NSString *)appskbId;
@end

@interface CustomerTableViewCell : UITableViewCell

- (IBAction)clickIconToCustomerDetail:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *customerIcon;
@property (weak, nonatomic) IBOutlet UIView *viewAboveOfCalling;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *telL;
@property (weak, nonatomic) IBOutlet UILabel *orderL;
@property (weak, nonatomic) IBOutlet UIButton *IMBtn;
- (IBAction)clickIMBtnAction:(id)sender;
- (IBAction)takePhoneAction:(id)sender;

@property(nonatomic,strong) CustomModel *model;
@property (nonatomic, strong)NSString *telStr;



@property (weak, nonatomic)id<transformPerformation>delegate;
+(instancetype)cellWithTableView:(UITableView *)tableView;




@end
