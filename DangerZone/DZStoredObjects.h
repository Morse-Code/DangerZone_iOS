//
//  DZStoredObjects.h
//  DangerZone
//
//  Created by Christopher Morse on 10/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DZObject;
static NSString __unused *const DZStoredObjectsChangedZonesNotification = @"DZStoredObjects changed zones";
static NSString *const KVOZonesChangeKey = @"dangerZoneObjects";

@class DZStoredObjects;

typedef void (^dangerZoneAccessHandler)(BOOL success, DZStoredObjects *dangerZoneObjects);

@interface DZStoredObjects : UIDocument


@property (nonatomic, readonly) NSArray *zones;

+ (void)accessDangerZoneObject:(dangerZoneAccessHandler)completionHandler;

- (void)updateWithArray:(NSArray *)array;

@end
