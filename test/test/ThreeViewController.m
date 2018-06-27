//
//  ThreeViewController.m
//  test
//
//  Created by os on 2018/6/24.
//  Copyright © 2018年 os. All rights reserved.
//

#import "ThreeViewController.h"

#import "ReactiveObjc.h"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     RAC相对于传统的设计模式
     1.编程逻辑的流畅性
     2.编程代码的清晰性
     */
    
    //初始值为0.5
    self.redInput.text = self.greenInput.text = self.blueInput.text = @"0.5";
    //双向绑定
 RACSignal *redSignal = [self bindSlider:self.redSlider textField:self.redInput];
RACSignal  *greenSignal =  [self bindSlider:self.greenSlider textField:self.greenInput];
RACSignal  *blueSignal = [self bindSlider:self.blueSlider textField:self.blueInput];
    
    //三个信号量返回的值 任意修改textField或者slider都会更新这几个订阅信号量的内容
    
    //combineLast意思用几根根稻草拧成一股麻绳的信号量
//    [[RACSignal combineLatest:@[redSignal,greenSignal,blueSignal]] subscribeNext:^(id  _Nullable x) {
//        //执行到第三次才执行输出
//        /*
//         combine需要三个信号量同时有新值传过来,才把内容传给我们
//         满足不了我们需求
//         */
//        NSLog(@"%@",x);
//    }];
    
    //映射处理
//    [[[RACSignal combineLatest:@[redSignal,greenSignal,blueSignal]] map:^id _Nullable(RACTuple* value) {
//        //我们把返回的元祖类型的返回给showView
//        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1.0];
//    }] subscribeNext:^(id  _Nullable x) {
//        //这就是绑定
//
//        //注意2点
//        //RAC回调一般都不在主线程 所以进行UI都要在主线程 我们需要在主线程执行 避免bug
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.showView.backgroundColor = x;
//        });
//
//    }];
    
    //RAC提供一个宏定义 执行绑定可以不需要直接订阅  直接使用信号量的宏定义
 RACSignal  *changeValueSignal =  [[RACSignal combineLatest:@[redSignal,greenSignal,blueSignal]] map:^id _Nullable(RACTuple* value) {
        //我们把返回的元祖类型的返回给showView
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1.0];
    }];
    
    RAC(_showView,backgroundColor) = changeValueSignal;
    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

/*
 双向绑定 slider发生变化 textField会发生变化 textField变化会影响slider的变化
 */
//- (void)bindSlider:(UISlider *)slider textField:(UITextField *)textField
//{
//    //信号中断
//    /*返回slider的新数据 slider数据发生变化信号终端把信号返回给我们*/
//    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
//    //返回新文本的终端
//    RACChannelTerminal *signalText = [textField rac_newTextChannel];
//    //2个终端进行绑定
//    [signalText subscribe:signalSlider];
//    //slider数据进行映射
//    [[signalSlider map:^id _Nullable(id  _Nullable value) {
//        return [NSString stringWithFormat:@"%.2f",[value floatValue]];
//    }] subscribe:signalText];
//}

//三个信号量进行绑定 实现showView变化
- (RACSignal *)bindSlider:(UISlider *)slider textField:(UITextField *)textField
{
    //处理一次 文字更新会触发信号量 文字更改一直输出 我们只取一次值 用take方法
    RACSignal *textSignal = [[textField rac_textSignal] take:1];
    //信号终断
    /*返回slider的新数据 slider数据发生变化信号终端把信号返回给我们*/
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    //返回新文本的终端
    RACChannelTerminal *signalText = [textField rac_newTextChannel];
    //2个终端进行绑定
    [signalText subscribe:signalSlider];
    //slider数据进行映射
    [[signalSlider map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.2f",[value floatValue]];
    }] subscribe:signalText];
    //谁先谁后没有关系  (合并的方法)
    return [[signalSlider merge:signalText] merge:textSignal];
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
