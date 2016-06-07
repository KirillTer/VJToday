//
//  ChangePasswordVC.m
//  VJToday
//
//  Created by Admin on 6/6/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *oldPassText;
@property (weak, nonatomic) IBOutlet UITextField *newsPassText;
@property (weak, nonatomic) IBOutlet UITextField *repeatPassText;

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelAction:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)saveAction:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
