//
//  ViewController.m
//  RACMVVMLogin
//
//  Created by os on 2018/7/4.
//  Copyright © 2018年 os. All rights reserved.
//

#import "ViewController.h"

#import "MRCLoginViewModel.h"
#import "ReactiveObjC.h"

@interface ViewController ()

@property (strong, nonatomic) MRCLoginViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[MRCLoginViewModel alloc] init];
    
    //绑定
    [self p_bindViewModel];
    //绑定按钮
    self.btn.rac_command = self.viewModel.loginCommand;
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - bind
- (void)p_bindViewModel{
    //电话号码
    RAC(self.viewModel,mobileNum) = self.mobileNumTF.rac_textSignal;
    //验证码
    RAC(self.viewModel,smsCode) = self.smsCodeTF.rac_textSignal;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
