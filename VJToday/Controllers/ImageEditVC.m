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
    NSData *myData=[NSData dataWithContentsOfFile:self.descriptionFilePath];
    self.descriptionDict = (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:myData];

    NSMutableDictionary *imgDict = [self.descriptionDict objectForKey:self.fileName];
    self.descriptionText.text = [imgDict objectForKey:@"description"];
    self.tagText.text = [imgDict objectForKey:@"tags"];
    NSLog(@"name - %@",self.fileName);
//    NSLog(@"file path - %@",self.descriptionFilePath);
//    NSLog(@"file - %@",self.descriptionDict);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)saveAction:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.descriptionText.text,@"description",self.tagText.text,@"tags",nil];
    [self.descriptionDict setObject:dict forKey:self.fileName];
    NSData *serializedData= [NSKeyedArchiver archivedDataWithRootObject:self.descriptionDict];
    [serializedData writeToFile:self.descriptionFilePath atomically:YES];

    NSData *myData=[NSData dataWithContentsOfFile:self.descriptionFilePath];
    NSMutableDictionary* myDict= (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:myData];
    NSLog(@"self.descriptionDict - %@",self.descriptionDict);
    NSLog(@"descriptionFilePath - %@",self.descriptionFilePath);
    NSLog(@"name - %@",self.fileName);
    NSLog(@"File - %@",myDict);
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
