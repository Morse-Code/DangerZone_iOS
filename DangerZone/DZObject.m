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

+ (NSString *)stringFromCategory:(NSUInteger)category
{
    //    NSArray *categories = [NSArray arrayWithObjects:@"Fire", @"Accident", @"Riot", @"Gunfire", nil];
    NSArray *categories = [NSArray arrayWithObjects:CATEGORIES count:5];
    NSString *categoryString = [categories objectAtIndex:category];
    NSLog(@"%@",categoryString);
    return categoryString;
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _locale = [attributes valueForKeyPath:@"locale"];
    _uid = [[attributes valueForKeyPath:@"uid"] integerValue];
    _category = [[attributes valueForKeyPath:@"category"] integerValue];
    _range = [[attributes valueForKeyPath:@"range"] integerValue];
    _severity = [[attributes valueForKeyPath:@"severity"] integerValue];
    _latitude = [[attributes valueForKeyPath:@"category"] floatValue];
    _longitude = [[attributes valueForKeyPath:@"category"] floatValue];
    
    
//    _category = [[attributes valueForKeyPath:@"id"] integerValue];
//     = [attributes valueForKeyPath:@"text"];
    return self;
}

#pragma mark -

+ (void)dangerZoneObjectsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    [[DZSharedClient sharedClient] getPath:@"request"  parameters:@"?uid=5&category" success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableDangerZones = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            DZObject *dangerZone = [[DZObject alloc] initWithAttributes:attributes];
            [mutableDangerZones addObject:dangerZone];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableDangerZones], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
