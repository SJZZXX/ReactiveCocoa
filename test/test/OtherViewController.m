//
//  OtherViewController.m
//  test
//
//  Created by os on 2018/6/18.
//  Copyright © 2018年 os. All rights reserved.
//

#import "OtherViewController.h"

@interface OtherViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //方法前面是减号,是实例方法 +类方法(类调用)
    [self foo];
    
    [OtherViewController instace];
    //当前类
    [[self class] instace];
    //简单block
    void(^foo)(void) = ^{
        
    };
    //调用 c语言
    foo();
    //action target
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    
    //delegate - 协议模式
    /*UITableView dataSource delegate*/
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
        //
    }];
    
   // [block start];
    [[NSOperationQueue mainQueue] addOperation:block];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

//
- (void)tap:(id)sender
{
    
}


- foo
{
    //1.没有声明返回类型 2.没有返回参数  3.OC没有声明返回类型,默认是id(对象)类型
    return nil;
}

+ instace
{
    return nil;
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
