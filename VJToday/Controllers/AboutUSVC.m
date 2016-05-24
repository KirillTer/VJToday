//
//  AboutUSVC.m
//  VJToday
//
//  Created by Admin on 5/16/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "AboutUSVC.h"

@interface AboutUSVC ()

@end

@implementation AboutUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"About us"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)menu:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
