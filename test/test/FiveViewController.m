//
//  FiveViewController.m
//  test
//
//  Created by os on 2018/6/30.
//  Copyright © 2018年 os. All rights reserved.
//

#import "FiveViewController.h"

#import "ReactiveObjc.h"

@interface FiveViewController ()

@end

@implementation FiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // push-driven pull-driven
    // 推驱动       拉驱动
    /*
     这2种模式的区别
     信号量需求驱动,消费者有需求,信号量才会产生新的内容
     这2中模式会产生副作用
     */
    /*
     副作用,订阅多次,信号量中的代码会执行多次,每次订阅返回值可能不一样
     副作用有时有加以利用
     解决方法:replayLast(记录性的signal)保证代码块只执行一次
     */
    __block int a = 10;
    RACSignal *s = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        a += 5;
        
        
        [subscriber sendNext:@(a)];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            //
        }];
    }] replayLast];
    
    [s subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [s subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //RAC高级函数方法
    //side effect 副作用
    //RACSequence 推驱动
    //map,filter,flattenMap,concat
    
    /*
     RACSequence都继承自RACStream与RACSignal有区别 本质上一种流
     RACSignal 拉驱动 (订阅的时候才生成内容)
     RACSignal 推驱动(初始化的时候他的内容已经形成)
     */
    
    /*RACSequence RACSignal 可以相互转换
     相互转换的意义:
     比如signal工厂的源头,转化成sequece,生成的产品放在序容器中
     反过来:sequence转换成signal 把生产好的产品,按照序列,放在一个即将发送的管道,作为管道的发送源
     */
    RACSequence *sequence = [s sequence];
    [sequence signal];
    
    /*RACSequence与NSArray无缝转换
     队列:将会说一些高级函数
     */
    NSArray *arr = @[@(1),@(2)];
    RACSequence *seq = [arr rac_sequence];
    [seq array];
    
    /*readuceEach包装成元组的一个逆向操作 flatten整个屏幕 map映射
      zip压缩
     takeUntil:一直获取,直到
     */
    
    
    //map,
    NSArray *array = @[@(1),@(2)];
    RACSequence *sequ = [array rac_sequence];
    [sequ map:^id _Nullable(id  _Nullable value) {
        return @([value integerValue]*3);
    }];
    //注意:直接输出sequence会为空
    /*sequence
     惰性初始化的sequence
     虽然我们已经为其制定内容了
     只有当访问真正访问值得时候才开始实例化,可以避免内存资源的浪费
     */
    NSLog(@"%@",[[sequ map:^id _Nullable(id  _Nullable value) {
        return @([value integerValue]*3);
    }] array]);
    
    //filter(筛选),flattenMap,concat
    NSLog(@"%@",[[sequ filter:^BOOL(id  _Nullable value) {
        /*返回的是BOOL型
         队列中的值是否还存留值
         筛选基数
         */
        return [value integerValue]%2 == 1;
    }] array]);
    //flattenMap 先映射,在全屏 自己功能的实现用的多
    /*
     sequence如下:
     [1,2];
     [3,4];
     //数组中嵌套数组
     [[1,2],[3,4]];
     使用flatten==> [1,2,3,4]; 子队列界限划掉形成一个新队列
     */
    //cancat
    /*
     连接sequence
     比如sequence1[1,2];
     sequence2[3,4];
     使用concat [1,2,3,4];
     signal串行 then有其他用法
     concat可以串行
     */
    RACSignal *s1;
    RACSignal *s2;
    //s1执行完返回值s2才开始执行 与then区别()
    /*
     与then区别()
     订阅后s1与s2的值都会返回给我们
     */
    [[s1 concat:s2] subscribeNext:^(id  _Nullable x) {
        //
    }];
    //使用then只会返回s2的数据
    [[s1 then:^RACSignal * _Nonnull{
        return s2;
    }] subscribeNext:^(id  _Nullable x) {
        //
    }];
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
