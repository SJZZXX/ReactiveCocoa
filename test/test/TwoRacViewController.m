//
//  TwoRacViewController.m
//  test
//
//  Created by os on 2018/6/24.
//  Copyright © 2018年 os. All rights reserved.
//

#import "TwoRacViewController.h"

#import "ReactiveObjc.h"

@interface TwoRacViewController ()

@end

@implementation TwoRacViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //rac相对于传统的设计模式
    /*
     1.编程逻辑的流畅性
     2.编程代码的清晰性
     */
    
    //rac_textSignal传输新的字符串的通道
    /*signal 加强版的block operation*/
//    [self.userTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    //字符串的signal返回的是字符串 enable按钮要求返回的bool型
    //map方法 映射
    
    //一个输入框的控制
//    RACSignal *enableSignal = [self.userTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        return @(value.length>0);
//    }];
//
//    //按钮的signal
//    self.loginBtn.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        return [RACSignal empty];
//    }];
    
    RACSignal  *enableSignal = [[RACSignal combineLatest:@[self.userTextField.rac_textSignal,self.psdTextField.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        
        //value 返回的是一个元组
        NSLog(@"%@",value);
        
        //value[0]只能用[]调用length  无法使用.调用length
        return @([value[0] length] > 0 && [value[1] length] >= 6);
    }];
    
        self.loginBtn.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal empty];
        }];
    
    
    /*学习三个方法 rac_textSignal map(映射) combineLast */
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
