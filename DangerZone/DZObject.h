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
@property (readonly) float latitude;
@property (readonly) float longitude;
@property (readonly) NSUInteger uid;
@property (readonly) NSUInteger category;
@property (readonly) NSUInteger range;
@property (readonly) NSUInteger severity;
@property (readonly) NSDate *timestamp;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)dangerZoneObjectsWithBlock:(void (^)(NSArray *dangerZones, NSError *error))block;

+ (NSString *)stringFromCategory:(NSUInteger)category;

@end
