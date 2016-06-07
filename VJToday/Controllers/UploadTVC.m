//
//  UploadTVC.m
//  VJToday
//
//  Created by Admin on 5/19/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "UploadTVC.h"
#import "UploadTC.h"
#import <AWSS3/AWSS3.h>
#import <AWSCore/AWSCore.h>

@interface UploadTVC ()
@property (nonatomic) NSArray *fileList;
@property (nonatomic) UIImage * searchedImage;
@property (nonatomic) NSMutableArray *cellSelected;
@property (nonatomic) NSString *URLinkToUpload;
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
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.jpeg'"]];
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
    for (NSString *del in self.fileList) {
        for (NSNumber *index in self.cellSelected) {
            if ([self.fileList indexOfObject:del]  == [index unsignedIntegerValue]) {
                NSURL *baseURL = [NSURL URLWithString:@"http://nodedev.vjtoday.com/api/sign_s3"];
                AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
                //инициализируем обработчик
                AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
                [requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-type"];
                //инициализируем обработчик респонса. Он распарсит Json в словарь
                AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.requestSerializer = requestSerializer;
                manager.responseSerializer = responseSerializer;
                [manager POST:@"" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
                    NSError *parseError;
                    NSDictionary *jsonSource = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&parseError];
                    self.URLinkToUpload = [jsonSource objectForKey:@"signed_request"];
                    NSLog([jsonSource objectForKey:@"url"]);
                    //NSLog(@"URL: %@", self.URLinkToUpload);
                    NSString *prefixString = @"Documents/";
                    NSString *nsstr = del;
                    NSString *uniqueFileName = [NSString stringWithFormat:@"%@%@", prefixString, nsstr];
                    //NSLog(@"file name - %@", uniqueFileName);
                    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[uniqueFileName stringByExpandingTildeInPath]];
                    //NSLog(@"file path - %@", jpgPath);
                    NSData *imageData = [NSData dataWithContentsOfFile:[jpgPath stringByExpandingTildeInPath]];
                    
                    NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc] init];
                    [uploadRequest setURL:[NSURL URLWithString:self.URLinkToUpload]];
                    uploadRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
                    [uploadRequest setHTTPMethod:@"PUT"];
                    [uploadRequest setHTTPBody:imageData];
                    //NSLog(@"image - %@",[NSData dataWithContentsOfFile:[jpgPath stringByExpandingTildeInPath]]);
                    //[uploadRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)10] forHTTPHeaderField:@"Content-Length"];
                    [uploadRequest setValue:@"" forHTTPHeaderField:@"Content-Type"];
                    
                    NSURLSession *session = [NSURLSession sharedSession];
                    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:uploadRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        NSLog(@"Image Uploaded");
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }];
                    [dataTask resume];
                }
                failure:^(NSURLSessionDataTask *task, NSError *error){
                    NSLog(@"request: %@", task.originalRequest);
                    NSLog(@"Error = %@", error);
                }];
                [mutableIndexSet addIndex:[index unsignedIntegerValue]];
            }
        }
    }
    //NSLog(@"%@",mutableIndexSet);
    NSMutableArray *temp = [self.fileList mutableCopy];
    //[temp removeObjectsAtIndexes:mutableIndexSet];
    self.fileList = [temp copy];
    self.cellSelected = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
}

@end
