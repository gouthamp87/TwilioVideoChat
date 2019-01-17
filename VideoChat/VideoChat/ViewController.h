//
//  ViewController.h
//  VideoChat
//
//  Created by Goutham RouteThis on 1/9/19.
//  Copyright © 2019 GouthamPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwilioVideo/TwilioVideo.h>

@interface ViewController : UIViewController <TVIVideoViewDelegate, TVIRoomDelegate,TVICameraSourceDelegate>

@end
