//
//  CameraVC.m
//  VJToday
//
//  Created by Admin on 5/4/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "CameraVC.h"
#import <AVFoundation/AVFoundation.h>
#import "../../Pods/VideoCore/api/ios/VCSimpleSession.h"

@interface CameraVC ()
@property (nonatomic) BOOL isStreaming;
@property (nonatomic) BOOL isTabBarHidden;
@property (strong, nonatomic) VCSimpleSession* liveSession;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureSession* session;
@property (weak, nonatomic) IBOutlet UIView *liveView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *streamButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *portraiTutoriaLabel;
@property (weak, nonatomic) IBOutlet UILabel *landscapeTutoriaLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIView *counterView;
@property (weak, nonatomic) IBOutlet UIImageView *counterImage;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *takenPhoto;

@end

@implementation CameraVC

NSTimer *timer;
int hours, minutes, seconds, secondsLeft;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isStreaming = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES; //Disable sleep mode
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]]; //Tab Bar panel
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLunch"]) {
        NSLog(@"First Launch");
        self.portraiTutoriaLabel.hidden = NO;
        self.notificationLabel.hidden = YES;
        self.counterView.hidden = YES;
        self.logoImage.hidden = YES;
        self.startButton.hidden = NO;
    } else {
        self.counterView.hidden = YES;
        self.startButton.hidden = YES;
        self.landscapeTutoriaLabel.hidden = YES;
        self.portraiTutoriaLabel.hidden = YES;
        self.notificationLabel.hidden = NO;
        self.logoImage.hidden = NO;
    }
    
    self.liveSession = [[VCSimpleSession alloc] initWithVideoSize:CGSizeMake(720, 1280) frameRate:24 bitrate:1000000 useInterfaceOrientation:NO];
    self.liveSession.useAdaptiveBitrate=YES; //adapt bit  rate - best for mobile usage
    
    [self.liveView addSubview:_liveSession.previewView];
    [self.liveView addSubview:self.streamButton];
    [self.liveView addSubview:self.photoButton];
    [self.liveView addSubview:self.notificationLabel];
    [self.liveView addSubview:self.logoImage];
    self.liveSession.previewView.frame = self.liveView.bounds;
}

-(void)viewDidAppear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPhoto:(id)sender {
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.stillImageOutput];
    [self.session startRunning];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
//            NSLog(@"photo make! - %@",image);
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"HH:mm:ss_dd:MMM:yyyy"];
            NSDate *now = [NSDate date];
            NSString *nsstr = [format stringFromDate:now];
            NSString *prefixString = @"Documents/photo";
            NSString *uniqueFileName = [NSString stringWithFormat:@"%@_%@.png", prefixString, nsstr];
            
            NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:uniqueFileName];
            [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
            
//            NSError *error = nil;
//            NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
//            NSArray *fileList = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: stringPath  error: &error];
//            self.takenPhoto.image = [UIImage imageNamed:[fileList objectAtIndex:0]];
//            NSLog(@"%@",[fileList objectAtIndex:0]);
            
        }
    }];
    [self.session stopRunning];
}

- (IBAction)onStream:(id)sender {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"Stream button pressed");
            if (!self.isStreaming) {
                [self startStream];
            } else {
                [self finishStream];
            }
            break;
        default:
            break;
    }
}

- (void) startStream {
    [_liveSession startRtmpSessionWithURL:@"rtmp://stream.vjtoday.com:1935/live/" andStreamKey:@"00000000-0000-0000-0000-000000000000_00000000-0000-0000-0000-000000000000"];
    UIImage *btnImage = [UIImage imageNamed:@"Stop"];
    [self.streamButton setImage:btnImage forState:UIControlStateNormal];
    self.isStreaming = YES;
    self.photoButton.hidden = YES;
    self.videoButton.hidden = YES;
    self.counterView.hidden = NO;
    self.counterImage.hidden = NO;
    [self countdownTimer];
    NSLog(@"Stream Start");
}

- (void) finishStream {
    [_liveSession endRtmpSession];
    UIImage *btnImage = [UIImage imageNamed:@"Stream"];
    [self.streamButton setImage:btnImage forState:UIControlStateNormal];
    self.isStreaming = NO;
    self.photoButton.hidden = NO;
    self.videoButton.hidden = NO;
    self.counterView.hidden = YES;
    self.counterImage.hidden = YES;
    NSLog(@"Stream Stop");
}

- (IBAction)startVJ:(id)sender {
    self.startButton.hidden = YES;
    self.landscapeTutoriaLabel.hidden = YES;
    self.portraiTutoriaLabel.hidden = YES;
    self.notificationLabel.hidden = NO;
    self.logoImage.hidden = NO;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate {
    // Disable autorotation of the interface when recording is in progress.
    NSLog(self.isStreaming ? @"shouldAutorotate -YES" : @"shouldAutorotate - NO");
    return !(self.isStreaming);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"!!!!!!!%ld", (long)interfaceOrientation);
    return !(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"LandScape Orientation");
            [self setTabBarHidden:YES animated:YES];
            break;
        default:
            NSLog(@"Portrait Orientation");
            if(self.isStreaming){[self finishStream];}
            [self setTabBarHidden:NO animated:YES];
            break;
    }
}
#pragma mark - Tab Bar animation

- (void)setTabBarHidden:(BOOL)tabBarHidden animated:(BOOL)animated {
    if (tabBarHidden == self.isTabBarHidden)
        return;
    CGFloat offset = tabBarHidden ? self.tabBarController.tabBar.frame.size.height : -self.tabBarController.tabBar.frame.size.height;
    
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x,
                                                                           self.tabBarController.tabBar.center.y + offset);
                     }
                     completion:nil];
    self.isTabBarHidden = tabBarHidden;
}
#pragma mark - Timer methods

- (void)updateCounter{
    secondsLeft ++ ;
    hours = secondsLeft / 3600;
    minutes = (secondsLeft % 3600) / 60;
    seconds = (secondsLeft %3600) % 60;
    self.counterLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

-(void)countdownTimer {
    secondsLeft = hours = minutes = seconds = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
}
@end
