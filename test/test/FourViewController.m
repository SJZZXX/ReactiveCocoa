//
//  FourViewController.m
//  test
//
//  Created by os on 2018/6/25.
//  Copyright © 2018年 os. All rights reserved.
//

#import "FourViewController.h"

#import "ReactiveObjc.h"

@interface FourViewController ()

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //http://www.orzer.club/test.json
    
    /*
     代码层面分析信号量的核心概念
     信号量是程序中各种事件的承载实例
     信号量相当于一根管子,一头连接着消费者,一头连接着生产者
     当消费者有消费需求,生产者开始生产内容
     数据是这个管子传出的产品,期间经过一些加工处理,最终变为消费者需要的产品,送到消费者手中
     这些管道还有合并的情况,例如一根管道生产果酱,一根管道生产吐司,两根管道合并生产出带果酱的吐司.
     就像我们的颜色选择器的例子,最终的颜色都是有三个管道控制的,任意一根管子发生变化,都会影响最终结果.
     信号量的头文件,信号量继承自RACStream
     stream:流 水流,气流,人流,电流,人山人海的人流 是有顺序的
     抽象的看,我们的程序是按顺序一段一段执行代码的
     程序也可以看做代码片段的流,这个流的实例就是信号量
     这种思想就是函数式编程的思想,信号量
     函数式思想编写代码更加关注编写代码块,就是信号量的复用,编写过程如同之前的例子,每一步都在操作和处理数据,但却把操作点从以前的数据本身转移到函数方法上,将变量之间建立绑定,这就是响应式编程的内容,把RAC简称函数响应式编程框架.简称frp.信号量是函数的载体,是响应式的实现者,所以他才是RAC的核心概念.
     我们的例子中用到几个RAC提供线程的信号量,也用到RAC的实例化方法,却没有自己构造过信号量.
     
     */
    
    //信号量第二个显著的优势,
    /*
     信号量简化了多线程操作的复杂程度
     数据请求设置三个.
     */
    //传统GCD的异步请求
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //网络请求
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //在主线程刷新UI
//        });
//    });
    
    //如果使用同步请求,使用GCD
    //都执行完毕后,才开始同步请求
    //如果你的并行操作还有异步请求,还要使用同步锁比较复杂的技术
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//        //并行操作一
//    });
//    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//        //并行操作二
//    });
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        //同步操作
//    });
    
    
    //构造信号量
    NSLog(@"four");
     NSString *urlStr = @"http://www.orzer.club/test.json";
    [[self signalFromJson:urlStr] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x[@"result"]);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error--%@",error);
    } completed:^{
        //
    }];
    
   
    //如果使用信号量,直接使用merge方法
    RACSignal *s1 =  [self signalFromJson:urlStr];
    RACSignal *s2 = [self signalFromJson:urlStr];
    RACSignal *s3 = [self signalFromJson:urlStr];
    
    //三个请求的顺序执行,一条管道请求的内容都返回给我们
    //[[s1 merge:s2] merge:s3];
    //以上不是我们需要的串行
    [[s1 merge:s2] merge:s3];
    //s1执行完以后再次执行下一步  三个信号量依次执行
    [[[s1 then:^RACSignal * _Nonnull{
        return s2;
    }] then:^RACSignal * _Nonnull{
        return s3;
    }] subscribeNext:^(id  _Nullable x) {
        //
    }];
    
    //执行同步等待 三个信号量并行,三个信号量都请求到数据 才把数据传给我们
    [[RACSignal combineLatest:@[s1,s2,s3]] subscribeNext:^(id  _Nullable x) {
        //同步等待
    }];

    // Do any additional setup after loading the view from its nib.
}

/*实现一个信号量,json字典,通过传入网址,获取数据,并对他进行json解析*/

- (RACSignal *)signalFromJson:(NSString *)urlStr
{
   
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSURLSessionConfiguration *c = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:c];
        NSURLSessionDataTask *data = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //
            if (error) {
                [subscriber sendError:error];
            } else {
                NSError *e;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&e];
                //sendError 或者 sendCompleted 只能调用一次
                //设计理念上符合 并不是只能调用一次
                if (e) {
                    [subscriber sendError:e];
                } else {
                    [subscriber sendNext:jsonDic];
                    [subscriber sendCompleted];
                }
            }
        }];
        [data resume];
        //信号量释放的时候使用的,没有需要释放的资源可以传空
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
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
