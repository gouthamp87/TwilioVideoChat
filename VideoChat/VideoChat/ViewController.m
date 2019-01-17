//
//  ViewController.m
//  VideoChat
//
//  Created by Goutham RouteThis on 1/9/19.
//  Copyright © 2019 GouthamPersonal. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *stopVideoButton;
@property (weak, nonatomic) IBOutlet TVIVideoView *previewView;
@property (nonatomic, strong) TVILocalVideoTrack *localVideoTrack;
@property (nonatomic, strong) TVICameraSource *camera;
@property (nonatomic, strong) TVIRoom *room;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)startVideo:(UIButton *)sender {
    // Check with the Server and retrieve the Access Token to connect to a chat room.
    [Utils retrieveAccessTokenFromURL:@"http://192.168.1.2:5050/getRoom?userID=Goutham2" completion:^(NSString * _Nonnull token, NSError * _Nonnull err) {
        if(!err){
//            NSString *accessToken = [NSString stringWithString:token];
            NSString *roomName = @"GouthamRoom";
            [self prepareLocalMedia];
            TVIConnectOptions *connectOptions = [TVIConnectOptions optionsWithToken:token
                                                                              block:^(TVIConnectOptionsBuilder * _Nonnull builder) {
                                                                            
                                                                                  builder.videoTracks = self.localVideoTrack ? @[ self.localVideoTrack ] : @[ ];
                                                                                  // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
                                                                                  // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
                                                                                  builder.roomName = roomName;
                                                                              }];
           self.room = [TwilioVideo connectWithOptions:connectOptions delegate:self];
        }
    }];
}



- (IBAction)stopVideo:(UIButton *)sender {
    [self.room disconnect];
    // Disconnect and clean up the session.
}


- (void)prepareLocalMedia {
    
    // We will share local audio and video when we connect to room.
    
    // Create a video track which captures from the camera.
    if (!self.localVideoTrack) {
        [self startPreview];
    }
}


- (void)startPreview {
    
    AVCaptureDevice *frontCamera = [TVICameraSource captureDeviceForPosition:AVCaptureDevicePositionFront];
    AVCaptureDevice *backCamera = [TVICameraSource captureDeviceForPosition:AVCaptureDevicePositionBack];
    
    if (frontCamera != nil || backCamera != nil) {
        self.camera = [[TVICameraSource alloc] initWithDelegate:self];
        self.localVideoTrack = [TVILocalVideoTrack trackWithSource:self.camera
                                                           enabled:YES
                                                              name:@"Cameara"];
      
        
//        if (frontCamera != nil && backCamera != nil) {
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                  action:@selector(flipCamera)];
//            [self.previewView addGestureRecognizer:tap];
//        }
        
        [self.camera startCaptureWithDevice:backCamera
                                 completion:^(AVCaptureDevice *device, TVIVideoFormat *format, NSError *error) {
                                     if (error != nil) {
                                         [self logMessage:[NSString stringWithFormat:@"Start capture failed with error.\ncode = %lu error = %@", error.code, error.localizedDescription]];
                                     } else {
                                         self.previewView.mirror = (device.position == AVCaptureDevicePositionFront);
                                     }
                                 }];
    } else {
//        [self logMessage:@"No front or back capture device found!"];
    }
}

#pragma mark - TVIRoomDelegate

- (void)didConnectToRoom:(TVIRoom *)room {
    // At the moment, this example only supports rendering one Participant at a time.
    
    [self logMessage:[NSString stringWithFormat:@"Connected to room %@ as %@", room.name, room.localParticipant.identity]];
    
//    if (room.remoteParticipants.count > 0) {
//        self.remoteParticipant = room.remoteParticipants[0];
//        self.remoteParticipant.delegate = self;
//    }
}

- (void)room:(TVIRoom *)room didDisconnectWithError:(nullable NSError *)error {
    [self logMessage:[NSString stringWithFormat:@"Disconncted from room %@, error = %@", room.name, error]];
    
//    [self cleanupRemoteParticipant];
    self.room = nil;
    
//    [self showRoomUI:NO];
}

- (void)room:(TVIRoom *)room didFailToConnectWithError:(nonnull NSError *)error{
    [self logMessage:[NSString stringWithFormat:@"Failed to connect to room, error = %@", error]];
    
    self.room = nil;
    
//    [self showRoomUI:NO];
}

- (void)room:(TVIRoom *)room participantDidConnect:(TVIRemoteParticipant *)participant {
//    if (!self.remoteParticipant) {
//        self.remoteParticipant = participant;
//        self.remoteParticipant.delegate = self;
//    }
    [self logMessage:[NSString stringWithFormat:@"Participant %@ connected with %lu audio and %lu video tracks",
                      participant.identity,
                      (unsigned long)[participant.audioTracks count],
                      (unsigned long)[participant.videoTracks count]]];
}

- (void)room:(TVIRoom *)room participantDidDisconnect:(TVIRemoteParticipant *)participant {
//    if (self.remoteParticipant == participant) {
//        [self cleanupRemoteParticipant];
//    }
    [self logMessage:[NSString stringWithFormat:@"Room %@ participant %@ disconnected", room.name, participant.identity]];
}



#pragma mark - TVIVideoViewDelegate

- (void)videoView:(TVIVideoView *)view videoDimensionsDidChange:(CMVideoDimensions)dimensions {
    NSLog(@"Dimensions changed to: %d x %d", dimensions.width, dimensions.height);
    [self.view setNeedsLayout];
}

#pragma mark - TVICameraSourceDelegate

- (void)cameraSource:(TVICameraSource *)source didFailWithError:(NSError *)error {
    [self logMessage:[NSString stringWithFormat:@"Capture failed with error.\ncode = %lu error = %@", error.code, error.localizedDescription]];
}


- (void)logMessage:(NSString *)msg {
    NSLog(@"%@", msg);
//    self.messageLabel.text = msg;
}


@end
