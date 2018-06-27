//
//  OneViewController.m
//  test
//
//  Created by os on 2018/6/24.
//  Copyright © 2018年 os. All rights reserved.
//

#import "OneViewController.h"

#import "ReactiveObjC.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //信号量 viewDidAppear 这个方法对象化
    
    RACSignal *viewDidAppearSignal = [self rac_signalForSelector:@selector(viewDidAppear:)];
    [viewDidAppearSignal subscribeNext:^(id  _Nullable x) {
        //x携带参数的值  animated
        NSLog(@"%@",x);
        NSLog(@"%s",__func__);
    }];
    
    //sigal信号量是更强大的block 或者operation
    //返回参数方面对正常状态和错误状态进行区分的
    
    [viewDidAppearSignal subscribeError:^(NSError * _Nullable error) {
        //
    }];
    
    [viewDidAppearSignal subscribeCompleted:^{
        //
    }];
    //
    //一个合格的信号量会调用0次或多次next 会调用一次完成状态 一次error
    //complete与error互斥,只会调用其中之一.
    //元组  swift不会陌生  OC没有原生的元组类型  RACTuple;
    //signal selector这个方法把传统类方法或者对象方法转化成信号量的形式.
    
    
    //rac_command uikit 常用控件设计的
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setRac_command:[[RACCommand alloc] initWithEnabled:nil signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //自定义signal
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //点击按钮的时候打印log
            NSLog(@"clicked");
            /*click事件已经执行
             为什么给订阅者传递sendNext 以及sendComplete
             点击按钮的时候可能有异步操作,需要一定的等待时间
             */
            /*模拟耗时操作*/
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //按钮点击的时候返回时间戳
                [subscriber sendNext:[[NSDate date] description]];
                //完成状态  没有错误  没有传参
                [subscriber sendCompleted];
            });
            
            
            
            //处理需要释放的对象
            return [RACDisposable disposableWithBlock:^{
                //
            } ];
        }];
    }]];
    
    //如何获取订阅
    [[[button rac_command] executionSignals] subscribeNext:^(RACSignal<id> * _Nullable x) {
        //第一订阅还是signal
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"--%@",x);
        }];
        
    }];
   
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button setBounds:CGRectMake(0, 0, 100, 200)];
    [button setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view from its nib.
}

//转化为rac的信号量
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
    
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
    
     NSLog(@"%s",__func__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
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
