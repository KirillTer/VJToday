//
//  GalaryVC.m
//  VJToday
//
//  Created by Admin on 5/10/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "GalaryVC.h"
#import "GalaryCVC.h"
#import "ImageVC.h"

@interface GalaryVC ()
@property (nonatomic) NSArray *fileList;
@property (nonatomic) UIImage * searchedImage;
@end

@implementation GalaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.fileList = @[@"1.png",@"2.png",@"3.png",@"4.png",@"5.png",@"6.png",@"7.png",@"8.png",@"9.png"];
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
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fileList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"PhotoCell";
    GalaryCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [paths objectAtIndex:0];
    NSString *imagePath = [myPath stringByAppendingPathComponent:[self.fileList objectAtIndex:indexPath.row]];
    self.searchedImage = [UIImage imageWithContentsOfFile:imagePath];
    cell.imageGalaryCell.image = self.searchedImage;
    cell.labelGalaryCell.text = self.fileList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"selected - %ld",(long)indexPath.row);
    ImageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageVC"];
    [self.navigationController showViewController:vc sender:self];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [paths objectAtIndex:0];
    NSString *imagePath = [myPath stringByAppendingPathComponent:[self.fileList objectAtIndex:indexPath.row]];
    vc.photoImage = [UIImage imageWithContentsOfFile:imagePath];
    //NSLog(@"%@",[UIImage imageWithContentsOfFile:imagePath]);
}

@end
