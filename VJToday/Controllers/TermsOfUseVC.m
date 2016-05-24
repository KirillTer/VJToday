//
//  TermsOfUseVC.m
//  VJToday
//
//  Created by Admin on 5/16/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "TermsOfUseVC.h"

@interface TermsOfUseVC ()

@end

@implementation TermsOfUseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Terms of use"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)menu:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
