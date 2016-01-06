//
//  CustomerDetailViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomModel.h"
#import "SKViewController.h"
#import "SKTableViewController.h"
@class CustomModel;

@protocol DeleteCustomerDelegate <NSObject>


//代理方法：协议传值1: 由第二个页面制定一个协议,用来命令前一个页面做事(执行方法) .h文件
- (void)deleteCustomerWith:(NSString *)keyWords;

@end


//@protocol initPullDegate <NSObject>
//-(void)reloadMethod;
//
//@end

@interface CustomerDetailViewController : SKTableViewController

////协议传值
//@property (nonatomic, assign)id delegate;
//或者
//协议传值2:设置代理人属性 (.h文件) 注意位置
@property(nonatomic, assign)id<DeleteCustomerDelegate>delegate;

//@property(nonatomic, assign)id<initPullDegate>initDelegate;


@property (nonatomic, strong)UINavigationController * Nav;
@property (weak, nonatomic) IBOutlet UITextField *weChat;
@property (weak, nonatomic) IBOutlet UITextField *QQ;
@property (weak, nonatomic) IBOutlet UITextView *note;

//协议传值（删除时使用的属性）
//@property (nonatomic,copy) NSString *ID;
//@property (nonatomic, copy)NSString * keyWordss;

@property (weak, nonatomic) IBOutlet UITextField *tele;
@property (nonatomic,copy) NSString *weChatStr;
//@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passPortId;
@property (weak, nonatomic) IBOutlet UITextField *userMessageID;

@property (weak, nonatomic) IBOutlet UITextField *bornDay;

@property (weak, nonatomic) IBOutlet UITextField *countryID;
@property (weak, nonatomic) IBOutlet UITextField *nationalID;
@property (weak, nonatomic) IBOutlet UITextField *pasportStartDay;
@property (weak, nonatomic) IBOutlet UITextField *pasportAddress;
@property (weak, nonatomic) IBOutlet UITextField *pasportInUseDay;
@property (weak, nonatomic) IBOutlet UITextField *livingAddress;
- (IBAction)attachmentAction:(id)sender;//附件

@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *AppSkbUserID;
//@property (nonatomic,strong) CustomModel *customMoel;

- (IBAction)remond:(id)sender;
- (IBAction)deleteCustomer:(id)sender;
- (IBAction)callPhone:(UIButton *)sender;
- (IBAction)jumpWeChat:(UIButton *)sender;
- (IBAction)jumpQQ:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *customerIcon;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLa;
@property (weak, nonatomic) IBOutlet UITextField *nickNameF;



@end
