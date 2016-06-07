//
//  EditProfileVC.m
//  VJToday
//
//  Created by Admin on 6/6/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    self.firstNameText.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Name"]];
    self.lastNameText.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Surname"]];
    self.emailText.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelAction:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)saveAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.firstNameText.text forKey:@"Name"];
    [[NSUserDefaults standardUserDefaults] setObject:self.lastNameText.text forKey:@"Surname"];
    [[NSUserDefaults standardUserDefaults] setObject:self.emailText.text forKey:@"Login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
