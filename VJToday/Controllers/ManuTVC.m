//
//  ManuTVC.m
//  VJToday
//
//  Created by Admin on 5/16/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "ManuTVC.h"
#import "TermsOfUseVC.h"
#import "AboutUSVC.h"
#import "LoginVC.h"

@interface ManuTVC ()
@property (nonatomic) NSArray *sectionTitles;
@end

@implementation ManuTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionTitles = @[@"Terms of use",@"About us"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionTitles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.sectionTitles[indexPath.row];
    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSLog(@"0");
        TermsOfUseVC *editViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsOfUseVC"];
        [self.navigationController showViewController:editViewController sender:self];
    } else if (indexPath.row == 1) {
        NSLog(@"1");
        AboutUSVC *editViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUSVC"];
        [self.navigationController showViewController:editViewController sender:self];
    }
}
@end
