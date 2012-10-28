//
//  DZObject.h
//  DangerZone
//
//  Created by Christopher Morse on 10/17/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/* These are the standard SDK pin colors. We are setting
unique identifiers per color for each pin so that later we
can reuse the pins that have already been created with the same color */

#define REUSABLE_PIN_RED @"Red"
#define REUSABLE_PIN_GREEN @"Green"
#define REUSABLE_PIN_PURPLE @"Purple"

@interface DZObject : NSObject < MKAnnotation >
{
    CLLocationCoordinate2D coordinate;
}


@property (nonatomic, unsafe_unretained, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, unsafe_unretained) MKPinAnnotationColor pinColor;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subTitle;
@property (readonly) NSString *locale;
@property (readonly) NSNumber *latitude;
@property (readonly) NSNumber *longitude;
@property (readonly) NSInteger uid;
@property (readonly) NSUInteger category;
@property (readonly) NSInteger range;
@property (readonly) NSInteger severity;
@property (readonly) NSDate *timestamp;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)dangerZoneObjectsWithBlock:(void (^)(NSArray *dangerZones, NSError *error))block;

+ (NSString *)stringFromCategory:(NSUInteger)category;

+ (NSString *)reusableIdentifierforPinColor :(MKPinAnnotationColor)paramColor;

@end
