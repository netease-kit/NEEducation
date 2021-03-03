//
//  EnterLessonViewController.m
//  NEEducation
//
//  Created by Netease on 2021/1/19.
//

#import "EnterLessonViewController.h"
#import "UIView+Toast.h"
#import <NEMeetingSDK/NEMeetingSDK.h>
#import "UIImage+NTES.h"

//#import <SVProgressHUD/SVProgressHUD.h>

// 隐私政策URL
static NSString *kPrivatePolicyURL = @"https://yunxin.163.com/clauses?serviceType=3";
// 用户协议URL
static NSString *kUserAgreementURL = @"http://yunxin.163.com/clauses";

//static NSString *kLessonID = @"NEEducationLessonId";
//static NSString *kNickname = @"NEEducationNickname";

@interface EnterLessonViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)   UILabel     *titleLab;

@property (nonatomic, strong)   UITextField *lessonIdTextField;
@property (nonatomic, strong)   UIView      *horLine;

@property (nonatomic, strong)   UITextField *nicknameTextField;
@property (nonatomic, strong)   UIView      *horLineTwo;

@property (nonatomic, strong)   UIButton    *joinLessonBtn;
@property (nonatomic, strong)   UITextView  *protocolView;

@property (nonatomic, assign)   BOOL isLessonIdValide;
@property (nonatomic, assign)   BOOL isNicknameValide;

@end

@implementation EnterLessonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupSubviews];
    [self setupData];
}
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLab.frame = CGRectMake(30, 140, self.view.bounds.size.width - 60, 40);
    [self.view addSubview:self.titleLab];

    self.lessonIdTextField.frame = CGRectMake(30, 140 + 40 + 25, self.view.bounds.size.width - 60, 44);
    [self.view addSubview:self.lessonIdTextField];
    
    self.horLine.frame = CGRectMake(30, 140 + 40 + 25 + 44, self.view.bounds.size.width - 60, 1);
    [self.view addSubview:self.horLine];
    
    self.nicknameTextField.frame = CGRectMake(30, self.horLine.frame.origin.y + self.horLine.frame.size.height + 10 , self.view.bounds.size.width - 60, 44);
    [self.view addSubview:self.nicknameTextField];

    self.horLineTwo.frame = CGRectMake(30,self.nicknameTextField.frame.origin.y + self.nicknameTextField.frame.size.height , self.view.bounds.size.width - 60, 1);
    [self.view addSubview:self.horLineTwo];
    
    self.joinLessonBtn.frame = CGRectMake(30, self.horLineTwo.frame.origin.y + 150, self.view.bounds.size.width - 60, 50);
    [self.view addSubview:self.joinLessonBtn];
    
    self.protocolView.frame = CGRectMake(20, self.joinLessonBtn.frame.origin.y + 50 + 15, self.view.bounds.size.width - 40, 30);
    [self.view addSubview:self.protocolView];
    self.protocolView.attributedText = [self protocolText];
    self.protocolView.textAlignment = NSTextAlignmentCenter;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    [self.view addGestureRecognizer:tap];
}
- (void)setupData {
//    self.lessonIdTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kLessonID];
//    self.nicknameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kNickname];
    self.joinLessonBtn.enabled = [self isValidNickname:self.lessonIdTextField.text] && [self isValidNickname:self.nicknameTextField.text];
}

#pragma mark - event
- (void)enterLessonEvent:(UIButton *)button {
    if (self.lessonIdTextField.text.length <= 0) {
        [self.view makeToast:@"课堂号不可为空"];
        return;
    }
    if (self.nicknameTextField.text.length <= 0) {
        [self.view makeToast:@"昵称不可为空"];
        return;
    }
    NEJoinMeetingParams *params = [[NEJoinMeetingParams alloc] init];
    params.meetingId =  self.lessonIdTextField.text;
    params.displayName = self.nicknameTextField.text;
    params.roleType = NEMeetingRoleTypeMember;
    NEJoinMeetingOptions *options = [[NEJoinMeetingOptions alloc] init];
    options.noWhiteBoard = NO;
    options.noVideo = NO;
    options.noAudio = NO;
    
    options.fullToolbarMenuItems = @[[NEMenuItems mic],[NEMenuItems camera],[self participants],[self managerParticipants]];
    options.fullMoreMenuItems = @[[NEMenuItems invite],[NEMenuItems chat],[NEMenuItems whiteboard]];
    button.enabled = NO;
    [[NEMeetingSDK getInstance].getMeetingService joinMeeting:params opts:options callback:^(NSInteger resultCode, NSString *resultMsg, id resultData) {
        button.enabled = YES;
        if (resultCode == 2000) {
            [self.view makeToast:@"课堂不存在"];
            return;
        }
        if (resultCode == 2010) {
            [self.view makeToast:@"课堂已锁定"];
            return;
        }
        if (resultCode != ERROR_CODE_SUCCESS) {
            [self.view makeToast:resultMsg];
        }
    }];
}
- (void)endEditing {
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField {
    if ([textField isEqual:self.lessonIdTextField]) {
        textField.text =  [self numberOnly:textField.text];
        textField.text = textField.text.length >= 10?[textField.text substringToIndex:10]:textField.text;
    }else {
        textField.text = textField.text.length >= 20?[textField.text substringToIndex:20]:textField.text;
    }
    self.isLessonIdValide = [self isValidLessonId:self.lessonIdTextField.text];
    self.isNicknameValide = [self isValidNickname:self.nicknameTextField.text];
    self.joinLessonBtn.enabled = self.isLessonIdValide && self.isNicknameValide;
}

- (BOOL)isValidLessonId:(NSString *)lessonId {
    if (lessonId.length <= 0 ) {
        return NO;
    }
    NSString *string = [lessonId stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return string.length ? NO : YES;
}


- (BOOL)isValidNickname:(NSString *)nickname {
    if (nickname.length <= 0) {
        return NO;
    }
    return YES;
}

- (NSString *)numberOnly:(NSString *)text {
    NSMutableArray *characters = [NSMutableArray array];
    NSMutableString *mutStr = [NSMutableString string];
    // 分离出字符串中的所有字符，并存储到数组characters中
    for (int i = 0; i < text.length; i ++) {
        NSString *subString = [text substringToIndex:i + 1];
        subString = [subString substringFromIndex:i];
        [characters addObject:subString];
    }
    
    // 利用正则表达式，匹配数组中的每个元素，判断是否是数字，将数字拼接在可变字符串mutStr中
    for (NSString *b in characters) {
        NSString *regex = @"^[0-9]*$";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];// 谓词
        BOOL isNum = [pre evaluateWithObject:b];// 对b进行谓词运算
        if (isNum) {
            [mutStr appendString:b];
        }
    }
    return mutStr;
}

#pragma mark - private mothod
- (NEMeetingMenuItem *)participants {
    NESingleStateMenuItem *item = [[NESingleStateMenuItem alloc] init];
    item.itemId = PARTICIPANTS_MENU_ID;
    item.visibility = VISIBLE_EXCLUDE_HOST;
    
    NEMenuItemInfo *info = [[NEMenuItemInfo alloc] init];
    info.text = @"课堂成员";
    info.icon = @"0";
    item.singleStateItem = info;
    return item;
}
- (NEMeetingMenuItem *)managerParticipants {
    NESingleStateMenuItem *item = [[NESingleStateMenuItem alloc] init];
    item.itemId = MANAGE_PARTICIPANTS_MENU_ID;
    item.visibility = VISIBLE_TO_HOST_ONLY;
    
    NEMenuItemInfo *info = [[NEMenuItemInfo alloc] init];
    info.text = @"课堂成员";
    info.icon = @"0";
    item.singleStateItem = info;
    return item;
}
- (NSAttributedString *)protocolText {
    NSDictionary *norAttr = @{NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]};
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"加入课堂即视为您已同意 " attributes:norAttr];
    
    NSMutableAttributedString *tempAttr = [[NSMutableAttributedString alloc] initWithString:@"隐私政策" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:126/255.0 blue:255/255.0 alpha:1.0], NSLinkAttributeName: kPrivatePolicyURL}];
    [attr appendAttributedString:[tempAttr copy]];
    
    tempAttr = [[NSMutableAttributedString alloc] initWithString:@" 和 " attributes:norAttr];
    [attr appendAttributedString:[tempAttr copy]];
    
    tempAttr = [[NSMutableAttributedString alloc] initWithString:@"用户协议" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:51/255.0 green:126/255.0 blue:255/255.0 alpha:1.0] , NSLinkAttributeName: kUserAgreementURL}];
    [attr appendAttributedString:[tempAttr copy]];
    
    return [attr copy];
}

#pragma mark - lazy method
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:28];
        _titleLab.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _titleLab.text = @"智慧云课堂";
    }
    return _titleLab;
}

- (UITextField *)lessonIdTextField {
    if (!_lessonIdTextField) {
        _lessonIdTextField = [[UITextField alloc] init];
        _lessonIdTextField.placeholder = @"课堂号";
        _lessonIdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _lessonIdTextField.font = [UIFont systemFontOfSize:17];
        _lessonIdTextField.textColor = [UIColor colorWithRed:51/255.0 green:126/255.0 blue:255/255.0 alpha:1.0];
        _lessonIdTextField.delegate = self;
        _lessonIdTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_lessonIdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _lessonIdTextField;
}

- (UIView *)horLine {
    if (!_horLine) {
        _horLine = [[UIView alloc] init];
        _horLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:223/255.0 blue:229/255.0 alpha:1.0];
    }
    return _horLine;
}

- (UITextField *)nicknameTextField {
    if (!_nicknameTextField) {
        _nicknameTextField = [[UITextField alloc] init];
        _nicknameTextField.placeholder = @"昵称";
        _nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nicknameTextField.font = [UIFont systemFontOfSize:17];
        _nicknameTextField.textColor = [UIColor colorWithRed:51/255.0 green:126/255.0 blue:255/255.0 alpha:1.0];
        _nicknameTextField.delegate = self;
        [_nicknameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nicknameTextField;
}
- (UIView *)horLineTwo {
    if (!_horLineTwo) {
        _horLineTwo = [[UIView alloc] init];
        _horLineTwo.backgroundColor = [UIColor colorWithRed:220/255.0 green:223/255.0 blue:229/255.0 alpha:1.0];
    }
    return _horLineTwo;
}

- (UIButton *)joinLessonBtn {
    if (!_joinLessonBtn) {
        _joinLessonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinLessonBtn setTitle:@"加入课堂" forState:UIControlStateNormal];
        [_joinLessonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_joinLessonBtn setBackgroundColor:[UIColor colorWithRed:51/255.0 green:126/255.0 blue:255/255.0 alpha:1.0]];
        _joinLessonBtn.layer.cornerRadius = 25;
        _joinLessonBtn.layer.masksToBounds = YES;
        [_joinLessonBtn setBackgroundImage:[UIImage ne_imageWithColor:[UIColor colorWithRed:51/255.0 green:126/255.0 blue:255/255.0 alpha:1.0]] forState:UIControlStateNormal];
        [_joinLessonBtn setBackgroundImage:[UIImage ne_imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [_joinLessonBtn addTarget:self action:@selector(enterLessonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _joinLessonBtn.enabled = NO;
    }
    return _joinLessonBtn;
}

- (UITextView *)protocolView {
    if (!_protocolView) {
        _protocolView = [[UITextView alloc] init];
        _protocolView.textAlignment = NSTextAlignmentCenter;
        _protocolView.editable = NO;
        _protocolView.scrollEnabled = NO;
        _protocolView.backgroundColor = [UIColor whiteColor];
    }
    return _protocolView;
}

@end
