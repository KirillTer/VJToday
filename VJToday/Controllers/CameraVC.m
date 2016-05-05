//
//  CameraVC.m
//  VJToday
//
//  Created by Admin on 5/4/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import "CameraVC.h"
#import "../../Pods/VideoCore/api/ios/VCSimpleSession.h"

@interface CameraVC ()
@property (strong, nonatomic) VCSimpleSession* liveSession;
@property (weak, nonatomic) IBOutlet UIView *liveView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *streamButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *portraiTutoriaLabel;

@end

@implementation CameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES; //Disable sleep mode

    _liveSession = [[VCSimpleSession alloc] initWithVideoSize:CGSizeMake(720, 1280) frameRate:24 bitrate:1000000 useInterfaceOrientation:NO];
    _liveSession.useAdaptiveBitrate=YES; //adapt bit  rate - best for mobile usage
    
    [self.liveView addSubview:_liveSession.previewView];
    [self.liveView addSubview:self.streamButton];
    [self.liveView addSubview:self.photoButton];
    [self.liveView addSubview:self.notificationLabel];
    [self.liveView addSubview:self.logoImage];
    _liveSession.previewView.frame = self.liveView.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
