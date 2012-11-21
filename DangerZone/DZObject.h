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
//static NSString *const request = @"";
//static NSString *const params = @"";

@interface DZObject : NSObject <MKAnnotation, NSCoding>
{
}


@property(nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic) MKPinAnnotationColor pinColor;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *subTitle;

@property(readonly) NSString *locale;
@property(readonly) NSNumber *latitude;
@property(readonly) NSNumber *longitude;
//@property(readonly) NSDate *timestamp; //integer
@property(readonly) NSNumber *timestamp;
@property(readonly) NSInteger uid;
@property(readonly) NSInteger radius;
@property(readonly) NSInteger severity;
@property(readonly) NSUInteger category;

- (id)initWithAttributes:(NSDictionary *)attributes;
//- (id)initWithCoordinate:(CLLocationCoordinate2D)passedCoordinate;

- (id)initUserSubmittedWithAttributes:(NSDictionary *)attributes;

//+ (void)dangerZoneObjectsWithBlock:(void (^)(NSArray *dangerZones, NSError *error))block;

//+ (void)dangerZoneObjectsForParameters:(NSDictionary *)params WithBlock:(void (^)(NSArray *, NSError *))block;

+ (void)dangerZoneObjectsForOperation: (NSString *) operation WithParameters:(NSDictionary *)params AndBlock: (void (^)(NSArray *, NSError *))block;


+ (NSString *)stringFromCategory:(NSUInteger)category;

+ (NSString *)reusableIdentifierForPinColor:(MKPinAnnotationColor)paramColor;

@end
