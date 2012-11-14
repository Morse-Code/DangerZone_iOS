//
//  DZObject.m
//  DangerZone
//
//  Created by Christopher Morse on 10/17/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "DZObject.h"
#import "DZSharedClient.h"

static NSString *CATEGORIES[] = {@"Fire", @"Accident", @"Riot", @"Gunfire", @"Horrid Fart"};
//static NSString *const request = @"request";

//static NSString *const request = @"";

//NSCoding Keys
static NSString *kLOCALE_KEY = @"locale";
static NSString *kLATITUDE_KEY = @"latitude";
static NSString *kLONGITUDE_KEY = @"longitude";
static NSString *kUID_KEY = @"uid";
static NSString *kCATEGORY_KEY = @"category";
static NSString *kRANGE_KEY = @"range";
static NSString *kSEVERITY_KEY = @"severity";
static NSString *kTIMESTAMP_KEY = @"timestamp";

// http://dangerzone.cems.umv.edu/api/

@implementation DZObject
{
//    CLLocationCoordinate2D _coordinate;
}


@synthesize locale = _locale;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize uid = _uid;
@synthesize category = _category;
@synthesize radius = _radius;
@synthesize severity = _severity;
@synthesize timestamp = _timestamp;
@synthesize pinColor = _pinColor;
@synthesize title = _title;
@synthesize subTitle = _subTitle;
@synthesize coordinate = _coordinate;




//static NSDateFormatter *dateFormatter = nil;


#pragma mark -
#pragma mark MKAnnotationView convenience methods

+ (NSString *)reusableIdentifierForPinColor :(MKPinAnnotationColor)paramColor {
    NSString *result = nil;
    switch (paramColor) {
        case MKPinAnnotationColorRed:
        {
            result = REUSABLE_PIN_RED;
            break;
        }
        case MKPinAnnotationColorGreen:
        {
            result = REUSABLE_PIN_GREEN;
            break;
        }
        case MKPinAnnotationColorPurple:
        {
            result = REUSABLE_PIN_PURPLE;
            break;
        }
    }
    return result;
}


+ (NSString *)stringFromCategory:(NSUInteger)category {
    //    NSArray *categories = [NSArray arrayWithObjects:@"Fire", @"Accident", @"Riot", @"Gunfire", nil];
    NSArray *categories = [NSArray arrayWithObjects:CATEGORIES count:5];
    NSString *categoryString = [categories objectAtIndex:category];
    //NSLog(@"%@", categoryString);
    return categoryString;
}

#pragma mark -
#pragma mark MKAnnotation protocol

- (CLLocationCoordinate2D)coordinate {

    _coordinate.latitude = [self.latitude doubleValue];
    _coordinate.longitude = [self.longitude doubleValue];
    return _coordinate;
}


- (void )setCoordinate:(CLLocationCoordinate2D)coordinate {
    _latitude = [NSNumber numberWithDouble:coordinate.latitude];
    _longitude = [NSNumber numberWithDouble:coordinate.longitude];
}

#pragma mark -
#pragma mark Initialize objects

//Initialize with server supplied JSON
- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    // Set DZObject properties from JSON
    //_locale = [attributes valueForKeyPath:@"locale"];
    //_locale = @"Test";
    _latitude = [NSNumber numberWithDouble:[[attributes valueForKey:@"latitude"] doubleValue]];
    _longitude = [NSNumber numberWithDouble:[[attributes valueForKey:@"longitude"] doubleValue]];
    //_timestamp = [NSNumber numberWithDouble:[[attributes valueForKey:@"timestamp"] doubleValue]];
    _uid = [[attributes valueForKeyPath:@"id"] integerValue];
//    _range = [[attributes valueForKeyPath:@"range"] integerValue];
    _radius = [[attributes valueForKeyPath:@"radius"] integerValue];
    //_severity = [[attributes valueForKeyPath:@"severity"] integerValue];
    _severity = 5;
//    _category = (NSUInteger)[[attributes valueForKeyPath:@"category"] integerValue];
    _category = (NSUInteger)[[attributes valueForKeyPath:@"category"] integerValue];
    // Set MKAnnotation properties
    _title = [DZObject stringFromCategory:(NSUInteger)_category];
    _subTitle = [NSString stringWithFormat:@"Severity level: %d", _severity];
    _pinColor = MKPinAnnotationColorRed;

    return self;
}


//Initialize user submitted DangerZone
- (id)initUserSubmittedWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    //_locale = [attributes valueForKeyPath:@"locale"];
    _latitude = [attributes valueForKeyPath:@"latitude"];
    _longitude = [attributes valueForKeyPath:@"longitude"];
    _uid = [[attributes valueForKeyPath:@"id"] integerValue];
    _category = (NSUInteger)[[attributes valueForKeyPath:@"category"] integerValue];
    _radius = [[attributes valueForKeyPath:@"radius"] integerValue];
    _severity = 5; //[[attributes valueForKeyPath:@"severity"] integerValue];
    _timestamp = [attributes valueForKeyPath:@"timestamp"];

    // Set MKAnnotation properties
    _title = [DZObject stringFromCategory:(NSUInteger)_category];
    _subTitle = [NSString stringWithFormat:@"Severity level: %d", _severity];
    _pinColor = MKPinAnnotationColorPurple;

    return self;
}

/*- (id)initWithCoordinate:(CLLocationCoordinate2D)passedCoordinate
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _locale = nil;
    _latitude = [NSNumber numberWithDouble:passedCoordinate.latitude];
    _longitude = [NSNumber numberWithDouble:passedCoordinate.longitude];
    _uid = 0;
    _category = 0;
    _range = 0;
    _severity = 0;
    _timestamp = [NSDate date];
    
    _title = @"Report DangerZone?";
    _subTitle = @"tap to submit";
    _pinColor = MKPinAnnotationColorPurple;


    return self;
}*/

#pragma mark -
#pragma mark JSON Parsing



+ (void)dangerZoneObjectsForOperation: (NSString *) operation WithParameters:(NSDictionary *)params AndBlock:(void (^)(NSArray *posts, NSError *error))block {
    [[DZSharedClient sharedClient] getPath:operation parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableDangerZones = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            DZObject *dangerZone = [[DZObject alloc] initWithAttributes:attributes];
            [mutableDangerZones addObject:dangerZone];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableDangerZones], nil);
        }
    }                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}


/*
+ (void)dangerZoneObjectsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    [[DZSharedClient sharedClient] getPath:request parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableDangerZones = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            DZObject *dangerZone = [[DZObject alloc] initWithAttributes:attributes];
            [mutableDangerZones addObject:dangerZone];
        }

        if (block) {
            block([NSArray arrayWithArray:mutableDangerZones], nil);
        }
    }                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

+ (void)dangerZoneObjectsForParameters:(NSDictionary *)params WithBlock:(void (^)(NSArray *posts, NSError *error))block {
    [[DZSharedClient sharedClient] getPath:request parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableDangerZones = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            DZObject *dangerZone = [[DZObject alloc] initWithAttributes:attributes];
            [mutableDangerZones addObject:dangerZone];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableDangerZones], nil);
        }
    }                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
*/

#pragma mark -
#pragma mark NSCoder protocol Keyed Arching

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.locale forKey:kLOCALE_KEY];
    [encoder encodeObject:self.latitude forKey:kLATITUDE_KEY];
    [encoder encodeObject:self.longitude forKey:kLONGITUDE_KEY];
    [encoder encodeInteger:self.uid forKey:kUID_KEY];
    [encoder encodeInteger:self.category forKey:kCATEGORY_KEY];
    [encoder encodeInteger:self.radius forKey:kRANGE_KEY];
    [encoder encodeInteger:self.severity forKey:kSEVERITY_KEY];
    [encoder encodeObject:self.timestamp forKey:kTIMESTAMP_KEY];
}


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _locale = [decoder decodeObjectForKey:kLOCALE_KEY];
        _latitude = [decoder decodeObjectForKey:kLATITUDE_KEY];
        _longitude = [decoder decodeObjectForKey:kLONGITUDE_KEY];
        _uid = [decoder decodeIntegerForKey:kUID_KEY];
        _category = (NSUInteger)[decoder decodeIntegerForKey:kCATEGORY_KEY];
        _radius = [decoder decodeIntegerForKey:kRANGE_KEY];
        _severity = [decoder decodeIntegerForKey:kSEVERITY_KEY];
        _timestamp = [decoder decodeObjectForKey:kTIMESTAMP_KEY];

        // Set MKAnnotation properties
        _title = [DZObject stringFromCategory:(NSUInteger)_category];
        _subTitle = [NSString stringWithFormat:@"Severity level: %d", _severity];
        _pinColor = MKPinAnnotationColorRed;
    }
    return self;
}


@end
