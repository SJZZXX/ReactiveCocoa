//
//  ThreeTestViewController.m
//  test
//
//  Created by os on 2018/6/25.
//  Copyright © 2018年 os. All rights reserved.
//

#import "ThreeTestViewController.h"

#import "ReactiveObjc.h"

@interface ThreeTestViewController ()

@end

@implementation ThreeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.redInput.text = self.greenInput.text = self.blueInput.text = @"0.5";
    
 RACSignal  *redSignal =  [self bindSlider:self.redSlider textField:self.redInput];
  RACSignal *greenSignal =  [self bindSlider:self.greenSlider textField:self.greenInput];
    
  RACSignal *blueSignal =  [self bindSlider:self.blueSlider textField:self.blueInput];
    //combine方法三个都执行一次才开始执行
    
   // __weak typeof (self) weakSelf = self;
    RACSignal *threeChangeValue =   [[RACSignal combineLatest:@[redSignal,greenSignal,blueSignal]] map:^id _Nullable(id  _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1.0];
    }];
//subscribeNext:^(id  _Nullable x) {
        //signal中的block大部分都在线程执行 为防止bug我们放在主线程执行
//        dispatch_async(dispatch_get_main_queue(), ^{
//             weakSelf.showView.backgroundColor = [UIColor colorWithRed:[x[0] floatValue] green:[x[1] floatValue] blue:[x[2] floatValue] alpha:1.0];
//        });
   // }];
    
    RAC(_showView,backgroundColor) = threeChangeValue;
    
}

//实现双向绑定
- (RACSignal *)bindSlider:(UISlider *)slider textField:(UITextField *)textField
{
    //保证先执行一次
    RACSignal *oneSignal = [[textField rac_textSignal] take:1];
    //信号端
    RACChannelTerminal *sliderSignal = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *textSignal = [textField rac_newTextChannel];
    [[sliderSignal map:^id _Nullable(id  _Nullable value) {
        //slider记得映射,映射出来的值返回,否则订阅slider毫无意义,我们需要订阅值
        return [NSString stringWithFormat:@"%.2f",[value floatValue]];
    }] subscribe:textSignal];
    [textSignal subscribe:sliderSignal];
    
    return [[textSignal merge:sliderSignal] merge:oneSignal];
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
