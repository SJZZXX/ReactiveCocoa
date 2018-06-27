//
//  TwoViewController.m
//  test
//
//  Created by os on 2018/6/24.
//  Copyright © 2018年 os. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()<UITextFieldDelegate>

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.userTextField setDelegate:self];
    [self.psdTextField setDelegate:self];
    
    self.loginBtn.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}

//更新字符串的方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *s1 = self.userTextField.text;
    NSString *s2 = self.psdTextField.text;
    if (textField == self.userTextField) {
        s1 = str;
    } else {
        s2 = str;
    }
    if (s1.length>0 && s2.length>=6) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
    
    NSLog(@"%@,%@",s1,s2);
    return YES;
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
