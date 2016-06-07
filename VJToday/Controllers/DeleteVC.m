//
//  DeleteVC.m
//  VJToday
//
//  Created by Admin on 5/19/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "DeleteVC.h"
#import "DeleteCVC.h"

@interface DeleteVC ()
@property (nonatomic) NSArray *fileList;
@property (nonatomic) UIImage * searchedImage;
@property (nonatomic) NSMutableArray *cellSelected;
@end

@implementation DeleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellSelected = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [paths objectAtIndex:0];
    // if you save fies in a folder
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // all files in the path
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:myPath error:nil];
    //self.fileList = [fileManager contentsOfDirectoryAtPath:myPath error:nil];
    // filter image files
    NSMutableArray *subpredicates = [NSMutableArray array];
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.jpeg'"]];
    NSPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
    self.fileList = [directoryContents filteredArrayUsingPredicate:filter];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fileList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"DeletePhotoCell";
    DeleteCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [paths objectAtIndex:0];
    NSString *imagePath = [myPath stringByAppendingPathComponent:[self.fileList objectAtIndex:indexPath.row]];
    self.searchedImage = [UIImage imageWithContentsOfFile:imagePath];
    cell.imageDeleteCell.image = self.searchedImage;
    cell.labelDeleteCell.text = self.fileList[indexPath.row];
    if ([self.cellSelected containsObject:[NSNumber numberWithLong:indexPath.row]]){
        cell.deleteMarkImage.hidden = NO;
    } else {
        cell.deleteMarkImage.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"selected - %d",(int)indexPath.row);
    if ([self.cellSelected containsObject:[NSNumber numberWithLong:indexPath.row]]) {
        [self.cellSelected removeObject:[NSNumber numberWithLong:indexPath.row]];
    }
    else {
        [self.cellSelected addObject:[NSNumber numberWithLong:indexPath.row]];
    }
    //NSLog(@"Count selected - %lu", (unsigned long)self.cellSelected.count);
    [self.collectionView reloadData];
}

- (IBAction)onDelete:(id)sender {
    NSMutableIndexSet *mutableIndexSet = [NSMutableIndexSet new];
    //NSLog(@"selected for delete - %@",self.cellSelected);
    for (NSString *del in self.fileList) {
        for (NSNumber *index in self.cellSelected) {
            if ([self.fileList indexOfObject:del]  == [index unsignedIntegerValue]) {
                [mutableIndexSet addIndex:[index unsignedIntegerValue]];
                NSLog(@"index - %lu",(unsigned long)[index unsignedIntegerValue]);
                NSLog(@"del - %@", del);
                NSString *prefixString = @"Documents/";
                NSString *nsstr = del;
                NSString *uniqueFileName = [NSString stringWithFormat:@"%@%@", prefixString, nsstr];
                NSLog(@"file name - %@", uniqueFileName);
                NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:uniqueFileName];
                NSLog(@"path - %@",jpgPath);
                NSError *error = nil;
                [[NSFileManager defaultManager] removeItemAtPath:jpgPath error:&error];
                NSLog(@"%lu", (unsigned long)[self.fileList indexOfObject:del]);
                
            }
        }
    }
    //NSLog(@"%@",mutableIndexSet);
    NSMutableArray *temp = [self.fileList mutableCopy];
    [temp removeObjectsAtIndexes:mutableIndexSet];
    self.fileList = [temp copy];
    self.cellSelected = [[NSMutableArray alloc] init];
    [self.collectionView reloadData];
}
@end
