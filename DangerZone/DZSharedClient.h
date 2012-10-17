//
// Created by morsecp on 10/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface DZSharedClient : AFHTTPClient

+ (DZSharedClient *)sharedClient;

@end