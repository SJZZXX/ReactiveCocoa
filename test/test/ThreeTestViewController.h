//
//  ThreeTestViewController.h
//  test
//
//  Created by os on 2018/6/25.
//  Copyright © 2018年 os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeTestViewController : UIViewController


@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UITextField *redInput;
@property (weak, nonatomic) IBOutlet UITextField *greenInput;
@property (weak, nonatomic) IBOutlet UITextField *blueInput;
@property (weak, nonatomic) IBOutlet UIView *showView;


@end
