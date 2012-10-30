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

@interface DZObject : NSObject < MKAnnotation, NSCoding >
{
}


@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic) MKPinAnnotationColor pinColor;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;

@property (readonly) NSString *locale;
@property (readonly) NSNumber *latitude;
@property (readonly) NSNumber *longitude;
@property (readonly) NSInteger uid;
@property (readonly) NSUInteger category;
@property (readonly) NSInteger range;
@property (readonly) NSInteger severity;
@property (readonly) NSDate *timestamp;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (id)initWithCoordinate:(CLLocationCoordinate2D)passedCoordinate;
- (void)configureWithAttributes:(NSDictionary *)attributes;


+ (void)dangerZoneObjectsWithBlock:(void (^)(NSArray *dangerZones, NSError *error))block;

+ (NSString *)stringFromCategory:(NSUInteger)category;

+ (NSString *)reusableIdentifierForPinColor:(MKPinAnnotationColor)paramColor;

@end
