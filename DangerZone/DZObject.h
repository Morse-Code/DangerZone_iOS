//
//  DZObject.h
//  DangerZone
//
//  Created by Christopher Morse on 10/17/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZObject : NSObject


@property (readonly) NSString *locale;
@property (readonly) double latitude;
@property (readonly) double longitude;
@property (readonly) NSUInteger id;
@property (readonly) NSUInteger category;
@property (readonly) NSUInteger range;
@property (readonly) NSUInteger severity;


@end
