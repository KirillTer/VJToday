//
//  UploadTVC.m
//  VJToday
//
//  Created by Admin on 5/19/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "UploadTVC.h"
#import "UploadTC.h"

@interface UploadTVC ()
@property (nonatomic) NSArray *fileList;
@property (nonatomic) UIImage * searchedImage;
@property (nonatomic) NSMutableArray *cellSelected;
@end

@implementation UploadTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellSelected = [[NSMutableArray alloc] init];
}

- (void) viewWillAppear:(BOOL)animated{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [paths objectAtIndex:0];
    // if you save fies in a folder
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // all files in the path
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:myPath error:nil];
    // filter image files
    NSMutableArray *subpredicates = [NSMutableArray array];
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.png'"]];
    NSPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
    self.fileList = [directoryContents filteredArrayUsingPredicate:filter];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"UploadCell";
    UploadTC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [paths objectAtIndex:0];
    NSString *imagePath = [myPath stringByAppendingPathComponent:[self.fileList objectAtIndex:indexPath.row]];
    self.searchedImage = [UIImage imageWithContentsOfFile:imagePath];
    cell.uploadImage.image = self.searchedImage;
    cell.descriptionLabel.text = self.fileList[indexPath.row];
    if ([self.cellSelected containsObject:[NSNumber numberWithLong:indexPath.row]]){
        cell.uploadMarkImage.hidden = NO;
    } else {
        cell.uploadMarkImage.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected - %d",(int)indexPath.row);
    if ([self.cellSelected containsObject:[NSNumber numberWithLong:indexPath.row]]) {
        [self.cellSelected removeObject:[NSNumber numberWithLong:indexPath.row]];
    }
    else {
        [self.cellSelected addObject:[NSNumber numberWithLong:indexPath.row]];
    }
    NSLog(@"Count selected - %lu", (unsigned long)self.cellSelected.count);
    [self.tableView reloadData];
}

- (IBAction)onUpload:(id)sender {
    NSMutableIndexSet *mutableIndexSet = [NSMutableIndexSet new];
    //NSLog(@"selected for delete - %@",self.cellSelected);
    for (NSString *del in self.fileList) {
        for (NSNumber *index in self.cellSelected) {
            if ([self.fileList indexOfObject:del]  == [index unsignedIntegerValue]) {
                [mutableIndexSet addIndex:[index unsignedIntegerValue]];
                //NSLog(@"index - %lu",(unsigned long)[index unsignedIntegerValue]);
                //NSLog(@"del - %@", del);
                NSString *prefixString = @"Documents/";
                NSString *nsstr = del;
                NSString *uniqueFileName = [NSString stringWithFormat:@"%@%@", prefixString, nsstr];
                //NSLog(@"file name - %@", uniqueFileName);
                NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:uniqueFileName];
                //NSLog(@"path - %@",jpgPath);
                NSError *error = nil;
                [[NSFileManager defaultManager] removeItemAtPath:jpgPath error:&error];
                //NSLog(@"%lu", (unsigned long)[self.fileList indexOfObject:del]);
                
            }
        }
    }
    //NSLog(@"%@",mutableIndexSet);
    NSMutableArray *temp = [self.fileList mutableCopy];
    [temp removeObjectsAtIndexes:mutableIndexSet];
    self.fileList = [temp copy];
    self.cellSelected = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
}

@end
