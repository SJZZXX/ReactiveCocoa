//
//  MRCLoginViewModel.h
//  RACMVVMLogin
//
//  Created by os on 2018/7/4.
//  Copyright © 2018年 os. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReactiveObjC.h"

@interface MRCLoginViewModel : NSObject

@property (nonatomic,copy)NSString *mobileNum;
@property (nonatomic,copy)NSString *smsCode;
@property (nonatomic,strong,readonly) RACCommand *loginCommand;

@end
