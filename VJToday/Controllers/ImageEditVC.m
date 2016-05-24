//
//  ImageEditVC.m
//  VJToday
//
//  Created by Admin on 5/19/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "ImageEditVC.h"

@interface ImageEditVC ()

@end

@implementation ImageEditVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
