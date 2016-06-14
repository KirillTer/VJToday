//
//  ImageVC.m
//  VJToday
//
//  Created by Admin on 5/19/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "ImageVC.h"
#import "ImageEditVC.h"

@interface ImageVC ()
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@end

@implementation ImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photo.image = self.photoImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)editAction:(id)sender {
    ImageEditVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageEditVC"];
    vc.fileName = self.fileName;
    NSLog(@"imageName - %@",self.fileName);
    [self.navigationController showViewController:vc sender:self];
}

- (IBAction)galary:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
