//
//  ImageEditVC.m
//  VJToday
//
//  Created by Admin on 5/19/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "ImageEditVC.h"

@interface ImageEditVC ()
@property (strong, nonatomic) NSString *descriptionFilePath;
@property (strong, nonatomic) NSMutableDictionary *descriptionDict;
@end

@implementation ImageEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.descriptionFilePath = [documentsDirectory stringByAppendingPathComponent:@"description.xml"];
    self.descriptionDict = [NSMutableDictionary dictionaryWithContentsOfFile:self.descriptionFilePath];
    
    NSMutableDictionary *dict = [self.descriptionDict objectForKey:self.fileName];
    self.descriptionText.text = [dict objectForKey:@"description"];
    self.tagText.text = [dict objectForKey:@"tags"];
    NSLog(@"name - %@",self.fileName);
    NSLog(@"file path - %@",self.descriptionFilePath);
    NSLog(@"file - %@",self.descriptionDict);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)saveAction:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.descriptionText.text,@"description",self.tagText.text,@"tags",nil];
    [self.descriptionDict setObject:dict forKey:self.fileName];
    [self.descriptionDict writeToFile:self.descriptionFilePath atomically:YES];
    NSLog(@"name - %@",self.fileName);
    NSLog(@"dict - %@",dict);
    NSLog(@"file path - %@",self.descriptionFilePath);
    NSLog(@"file - %@",self.descriptionDict);
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
