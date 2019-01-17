//
//  Utils.m
//  VideoChat
//
//  Created by Goutham RouteThis on 1/14/19.
//  Copyright © 2019 GouthamPersonal. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (void)retrieveAccessTokenFromURL:(NSString *)tokenURLStr
                        completion:(void (^)(NSString* token, NSError *err)) completionHandler {
    NSURL *tokenURL = [NSURL URLWithString:tokenURLStr];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask *task = [session dataTaskWithURL:tokenURL
                                        completionHandler: ^(NSData * _Nullable data,
                                                             NSURLResponse * _Nullable response,
                                                             NSError * _Nullable error) {
                                            NSString *accessToken = nil;
                                            if (!error && data) {
                                                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                accessToken = [jsonObject objectForKey:@"AccessToken"];
                                            }
                                            completionHandler(accessToken, error);
                                        }];
    [task resume];
}
@end
