//
//  DZObject.m
//  DangerZone
//
//  Created by Christopher Morse on 10/17/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import "DZObject.h"
#import "DZSharedClient.h"

static NSString *CATEGORIES[] = {@"Fire", @"Accident", @"Riot", @"Gunfire", @"Horrid Fart"};

// http://dangerzone.cems.umv.edu/api/

@implementation DZObject


@synthesize locale = _locale;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize uid = _uid;
@synthesize category = _category;
@synthesize range = _range;
@synthesize severity = _severity;
@synthesize timestamp = _timestamp;
@synthesize pinColor = _pinColor;
@synthesize title = _title;
@synthesize subTitle = _subTitle;





//static NSDateFormatter *dateFormatter = nil;


#pragma mark -
#pragma mark MKAnnotationView convenience methods

+ (NSString *)reusableIdentifierforPinColor :(MKPinAnnotationColor)paramColor
{
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


+ (NSString *)stringFromCategory:(NSUInteger)category
{
    //    NSArray *categories = [NSArray arrayWithObjects:@"Fire", @"Accident", @"Riot", @"Gunfire", nil];
    NSArray *categories = [NSArray arrayWithObjects:CATEGORIES count:5];
    NSString *categoryString = [categories objectAtIndex:category];
    NSLog(@"%@", categoryString);
    return categoryString;
}

#pragma mark -
#pragma mark MKAnnotation protocol

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

#pragma mark -
#pragma mark Initialize objects

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }

    // Set DZObject properties from JSON
    _locale = [attributes valueForKeyPath:@"locale"];
    _uid = [[attributes valueForKeyPath:@"uid"] integerValue];
    _category = (NSUInteger)[[attributes valueForKeyPath:@"category"] integerValue];
    _range = [[attributes valueForKeyPath:@"range"] integerValue];
    _severity = [[attributes valueForKeyPath:@"severity"] integerValue];
    _latitude = [NSNumber numberWithDouble:[[attributes valueForKey:@"latitude"] doubleValue]];
    _longitude = [NSNumber numberWithDouble:[[attributes valueForKey:@"longitude"] doubleValue]];

    // Set MKAnnotation properties
    _title = [DZObject stringFromCategory:(NSUInteger)_category];
    _subTitle = [NSString stringWithFormat:@"Severity level: %d", _severity];
    _pinColor = MKPinAnnotationColorRed;


    return self;
}

#pragma mark -
#pragma mark JSON Parsing

+ (void)dangerZoneObjectsWithBlock:(void (^)(NSArray *posts, NSError *error))block
{
    [[DZSharedClient sharedClient] getPath:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON)
    {
        NSMutableArray *mutableDangerZones = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            DZObject *dangerZone = [[DZObject alloc] initWithAttributes:attributes];
            [mutableDangerZones addObject:dangerZone];
        }

        if (block) {
            block([NSArray arrayWithArray:mutableDangerZones], nil);
        }
    }                              failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
