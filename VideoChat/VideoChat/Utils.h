//
//  Utils.h
//  VideoChat
//
//  Created by Goutham RouteThis on 1/14/19.
//  Copyright © 2019 GouthamPersonal. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject
+ (void)retrieveAccessTokenFromURL:(NSString *)tokenURLStr
                        completion:(void (^)(NSString* token, NSError *err)) completionHandler;
@end

NS_ASSUME_NONNULL_END
