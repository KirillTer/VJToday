//
//  ProfileVC.m
//  VJToday
//
//  Created by Admin on 6/6/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "ProfileVC.h"

@interface ProfileVC ()
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    self.firstNameLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Name"]];
    self.lastNameLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Surname"]];
    self.emailLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Logined"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Login"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Name"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Surname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
