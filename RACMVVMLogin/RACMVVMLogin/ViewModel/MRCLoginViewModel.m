//
//  MRCLoginViewModel.m
//  RACMVVMLogin
//
//  Created by os on 2018/7/4.
//  Copyright © 2018年 os. All rights reserved.
//

#import "MRCLoginViewModel.h"

@interface MRCLoginViewModel ()


 @property (nonatomic,strong,readwrite) RACCommand *loginCommand;
@end

@implementation MRCLoginViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        //这里字符串必须初始化!,否则数组会崩溃
        self.mobileNum = @"";
        self.smsCode = @"";
        RACSignal * mobileNumSignal = [RACObserve(self, mobileNum) filter:^BOOL(NSString * value) {
            return value.length == 11;
        }];
        
        RACSignal * smsCodeSignal =[RACObserve(self, smsCode) filter:^BOOL(NSString * value) {
            return value.length == 4;
        }];
        
        @weakify(self);
        [[RACSignal combineLatest:@[mobileNumSignal,smsCodeSignal]] subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"触发请求");
            [self.loginCommand execute:nil];
        }];
        
    }
    return self;
}

#pragma mark - get && set
- (RACCommand *)loginCommand{
    
    if (nil == _loginCommand) {
        @weakify(self);
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            
            //这里位数以及验证码在控制器那里已经筛选过了,这里只是做个简单的例子,可以在这里对手机正则等进行校验
            //最好的写法:button.rac_command = viewmodel.loginCommand...把位数判断移到这里
            if (self.mobileNum.length != 11) {
                return [RACSignal error:[NSError errorWithDomain:@"" code:10 userInfo:@{@"errorInfo":@"手机号码位数不对"}]];
            }
            if (self.smsCode.length != 4) {
                return [RACSignal error:[NSError errorWithDomain:@"" code:20 userInfo:@{@"errorInfo":@"验证码位数不对"}]];
            }
            
            return [self loginSignalWithMobileNum:self.mobileNum smsCode:self.smsCode];
        }];
        
    }
    return _loginCommand;
}

#pragma mark - private

- (RACSignal *)loginSignalWithMobileNum:(NSString *)mobileNo smsCode:(NSString *)authCodeSMS{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"开始请求");
        //添加deviceID参数
//        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//        [params setObject:[self deviceNo] forKey:@"deviceNo"];
//        NSDictionary * dict = @{@"mobileNo":mobileNo,
//                                @"authCodeSMS":authCodeSMS};
//        NSMutableDictionary *newParams = [dict mutableCopy];
//        [newParams addEntriesFromDictionary:params];
        
        //网络请求
//        [FYRequestTool POST:@"" parameters:newParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            //发送成功内容(需要什么发什么,也可以直接给单例赋值)
//            [subscriber sendNext:responseObject];
//            [subscriber sendCompleted];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [subscriber sendError:error];
//        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //三秒之后提示成功
            [subscriber sendCompleted];
        });
        
        //完成信号后取消
        return [RACDisposable disposableWithBlock:^{
            //[FYRequestTool cancel];
        }];
        
    }];
}
- (NSString *)deviceNo
{
    //return [SimulateIDFA createSimulateIDFA];
    return nil;
    
}



@end
