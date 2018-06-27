//
//  OneTestViewController.m
//  test
//
//  Created by os on 2018/6/24.
//  Copyright © 2018年 os. All rights reserved.
//

#import "OneTestViewController.h"

#import "ReactiveObjc.h"

@interface OneTestViewController ()

@end

@implementation OneTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // RACSignal;
    RACSignal *viewDidAppearSignal = [self rac_signalForSelector:@selector(viewDidAppear:)];
    [viewDidAppearSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%s",__func__);
        //x表示 animated
        NSLog(@"%@",x);
    }];
    [viewDidAppearSignal subscribeError:^(NSError * _Nullable error) {
        //
    }];
    [viewDidAppearSignal subscribeCompleted:^{
        //
    }];
    
    // action target 形式的signal
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button  setRac_command:[[RACCommand alloc] initWithEnabled:nil signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSLog(@"clicked");
            //GCD 延迟三秒操作
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [subscriber sendNext:[[NSDate date] description]];
                
                [subscriber sendCompleted];
                
            });
            
            return [RACDisposable disposableWithBlock:^{
                //释放的时候调用
            }];
        }] ;
    }]];
    //订阅button参数
    [[[button rac_command] executionSignals] subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            //参数
            NSLog(@"%@",x);
        }];
    }];
    
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button setBounds:CGRectMake(0, 0, 200, 100)];
    [button setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:button];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //输出当前方法
    NSLog(@"%s",__func__);
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
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
