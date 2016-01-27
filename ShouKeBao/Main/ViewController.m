//eeee
//  ViewController.m
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//
// RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#import "ViewController.h"
#import "Customers.h"
#import "OldCustomerViewController.h"
#import "FindProduct.h"
#import "Me.h"
#import "Orders.h"
#import "ShouKeBao.h"
#import "WMNavigationController.h"
#import "ResizeImage.h"
#import "FindProductNew.h"
#import "ChatViewController.h"
#import "EMCDDeviceManager.h"
#import "RobotManager.h"
#import "EaseMob.h"
#import "NewMessageCenterController.h"
#import "APNSHelper.h"
#import "LocationSeting.h"
#import "NSString+FKTools.h"
#import "UMessage.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";


#define UserInfoKeyLYGWIsOpenVIP @"LVGWIsOpenVIP"//是否开通vip
@interface ViewController ()<IChatManagerDelegate, EMCallManagerDelegate>

@property (nonatomic,strong) AVAudioPlayer *player;


@property (copy ,nonatomic) NSMutableString *skbValue;
@property (copy ,nonatomic) NSMutableString *fdpValue;
@property (copy ,nonatomic) NSMutableString *odsValue;
@property (copy ,nonatomic) NSMutableString *cstmValue;
@property (copy ,nonatomic) NSMutableString *meValue;
@property (nonatomic, strong)ShouKeBao * shoukebaoVC;
@property (nonatomic, strong)Customers * customers;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    [self setupUnreadMessageCount];
    [self registerNotifications];
   self.skbValue = [NSMutableString stringWithFormat:@"%d",0];
    self.fdpValue = [NSMutableString stringWithFormat:@"%d",0];
    self.odsValue = [NSMutableString stringWithFormat:@"%d",0];
    self.cstmValue = [NSMutableString stringWithFormat:@"%d",0];
    self.meValue = [NSMutableString stringWithFormat:@"%d",0];

    
    self.shoukebaoVC = [[ShouKeBao alloc] init];
    
    [self addChildVc:self.shoukebaoVC title:@"旅游圈" image:@"skb2" selectedImage:@"skb"];
    
    UIStoryboard * SB = [UIStoryboard storyboardWithName:@"FindProductNew" bundle:[NSBundle mainBundle]];
    FindProductNew * FPVC = (FindProductNew *)[SB instantiateViewControllerWithIdentifier:@"FindProductNewSB"];
    [self addChildVc:FPVC   title:@"找产品" image:@"fenlei2" selectedImage:@"fenlei"];

//    FindProduct *fdp = [[FindProduct alloc] init];
//    
//    [self addChildVc:fdp title:@"找产品" image:@"fenlei2" selectedImage:@"fenlei"];
    
    Orders *ods = [[Orders alloc] init];
    [self addChildVc:ods title:@"理订单" image:@"lidingdan" selectedImage:@"lidingdan2"];
   // [[self.childViewControllers objectAtIndex:2] setBadgeValue:_odsValue];

    
   
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLYGWIsOpenVIP] isEqualToString:@"0"]){     //没有开通
//        
//        OldCustomerViewController *oldCustomerVC = [[OldCustomerViewController alloc]init];
//        [self addChildVc:oldCustomerVC title:@"管客户" image:@"kehu2" selectedImage:@"kehu"];
//    }else{
        self.customers = [[Customers alloc] init];
        [self addChildVc:self.customers title:@"管客户" image:@"kehu2" selectedImage:@"kehu"];
//    }

    
    Me *me = [[Me alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildVc:me title:@"我" image:@"wo2" selectedImage:@"wo"];
    
    
    NSUserDefaults *appIsBack = [NSUserDefaults standardUserDefaults];
    
    [appIsBack setObject:@"no" forKey:@"appIsBack"];
    
    [appIsBack synchronize];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([APNSHelper defaultAPNSHelper].isReceiveRemoteNotification) {
        [self didReceiveRemoteNotification:[APNSHelper defaultAPNSHelper].userInfoDic];
    }
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title;
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];

    
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
//
    // 先给外面传进来的小控制器 包装 一个导航控制器
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:childVc];
    
   [self addChildViewController:nav];
}
// 统计未读消息数
-(NSInteger)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    return unreadCount;
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
    //    [_chatListVC refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages
{
    
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    NSLog(@"%@", _customers);
    if (_customers) {
        [self customerInformationCenterTimePrompt];
    }
    if (_shoukebaoVC) {
        int badgeV = [_shoukebaoVC.barButton.badgeValue intValue];
        int unreadMessage = badgeV + 1;
        _shoukebaoVC.barButton.badgeValue = [NSString stringWithFormat:@"%d", unreadMessage];
        _shoukebaoVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", unreadMessage];
    }
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
//        #if !TARGET_IPHONE_SIMULATOR
        
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }else {
            [self playSoundAndVibration];
        }
//        #endif
    }
}

- (void)customerInformationCenterTimePrompt{
    NSDate *sendDate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *locationTimeString=[dateformatter stringFromDate:sendDate];
    _customers.timePrompt.text = locationTimeString;
    [LocationSeting defaultLocationSeting].customMessageDateStr = locationTimeString;
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"reciveNewMessage" object:nil];
}


-(void)didReceiveCmdMessage:(EMMessage *)message
{
    //    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    options.displayStyle = ePushNotificationDisplayStyle_simpleBanner;
    if (options.displayStyle == ePushNotificationDisplayStyle_simpleBanner) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"[图片]", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"[语音消息]", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        if ([[LocationSeting defaultLocationSeting]getCustomInfoWithID:message.from]) {
            title =  [[LocationSeting defaultLocationSeting]getCustomInfoWithID:message.from][@"nickName"];
        }else{
            title = @"未命名";
        }
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        UIApplication *application = [UIApplication sharedApplication];
        application.applicationIconBadgeNumber += 1;
}

#pragma --mark- 收到通知（本地通知和远程通知）
- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NewMessageCenterController *messgeCenter = [[NewMessageCenterController alloc] init];
    [self.shoukebaoVC.navigationController pushViewController:messgeCenter animated:NO];
    self.selectedViewController = ((ShouKeBao *)self.viewControllers[0]);
    ChatViewController * chatVC = [[ChatViewController alloc]initWithChatter:userInfo[@"ConversationChatter"] conversationType:eConversationTypeChat];
    [chatVC hideImagePicker];
    [self.shoukebaoVC.navigationController pushViewController:chatVC animated:YES];
}
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"%@", userInfo);
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    //判断提醒震动
    NSString *NewsShakeDefine = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewsShakeRemind"];
    NSLog(@"%@", NewsShakeDefine);
    if ([NewsShakeDefine integerValue] != 1) {//震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NewsVoiceRemind"] integerValue] != 1) {
        [self prepAudio];//声音
    }
    

    for (NSString *key in userInfo.allKeys) {
        if ([key isEqualToString:@"f"]) {
            
            [[[UIAlertView alloc]initWithTitle:@"消息" message:@"asd" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"asd" , nil]show];

            
            NewMessageCenterController *messgeCenter = [[NewMessageCenterController alloc] init];
            [self.shoukebaoVC.navigationController pushViewController:messgeCenter animated:NO];
            self.selectedViewController = ((ShouKeBao *)self.viewControllers[0]);
            ChatViewController * chatVC = [[ChatViewController alloc]initWithChatter:userInfo[@"f"] conversationType:eConversationTypeChat];
            [chatVC hideImagePicker];
            [self.shoukebaoVC.navigationController pushViewController:chatVC animated:YES];
            return;
        }
    }

    [[[UIAlertView alloc]initWithTitle:@"shoudao " message:@"asd" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"asd" , nil]show];

    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isReceveNoti"];
    NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    NSString * objID = [userInfo valueForKey:@"objectId"];
    NSString * objUri = [userInfo valueForKey:@"objectUri"];
    NSString * objTitle = [userInfo valueForKey:@"noticeTitle"];
    
    if ([noticeType isEqualToString:@"SingleOrder"]) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"orderId"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else if([noticeType isEqualToString:@"PerfectProduct"]) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"recommond"];
        [arr addObject:noticeType];
        [arr addObject:@"123"];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else if ([noticeType isEqualToString:@"SingleProduct"]) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"productId"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else if ([noticeType isEqualToString:@"SingleArticle"]) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"messageId"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else if([noticeType isEqualToString:@"Other"]){
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"OtherId"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [arr addObject:objTitle];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else if([noticeType isEqualToString:@"SearchProduct"]){
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"SearchProduct"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [arr addObject:objTitle];
        [defaultCenter postNotificationName:@"pushWithBackGroundFindProduct" object:arr];
        // 直客动态
    }else if([noticeType isEqualToString:@"CustomerDynamic"]){
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"CustomerDynamic"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [arr addObject:objTitle];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSArray * array = @[@"elseType", @"", @""];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:array];
    }

}


//播放一段无声音乐，让苹果审核时认为后台有音乐而让程序不会被杀死
- (BOOL) prepAudio

{
    
    NSError *error;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"mp3"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return NO;
        
    }
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]error:&error];
    
    if (!_player)
        
    {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        
        return NO;
        
    }
    
    [self.player prepareToPlay];
    [self.player play];
    //就是这行代码啦
    
    [self.player setNumberOfLoops:1];
    
    return YES;
}



#pragma mark - public

- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

@end
