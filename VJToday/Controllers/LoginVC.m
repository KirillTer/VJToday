//
//  LoginVC.m
//  VJToday
//
//  Created by Admin on 5/16/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *loginText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@property (nonatomic) NSURLConnection *connection;
@property (nonatomic) NSMutableData *receivedData;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Login"];
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog([[NSUserDefaults standardUserDefaults] boolForKey:@"Logined"] ? @"Already Logined" : @"Not Logined");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Logined"]) {
        self.loginLabel.text = [NSString stringWithFormat:@"Logined as %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)menu:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)loginAction:(id)sender {
    NSDictionary *parametersDictionary = @{@"email": self.loginText.text, @"password": self.passwordText.text};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"http://nodedev.vjtoday.com/api/login" parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Logined"];
        NSString *valueToSave = self.loginText.text;
        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"Login"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[self navigationController] popViewControllerAnimated:YES];
        NSLog(@"success! %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

@end
