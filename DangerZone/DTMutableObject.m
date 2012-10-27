//
//  DTMutableObject.m
//  Danger_Tab
//
//  Created by rbelford on 10/23/12.
//  Copyright (c) 2012 rbelford. All rights reserved.
//

#import "DTMutableObject.h"

@implementation DTMutableObject

@synthesize locale = _locale;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize uid = _uid;
@synthesize category = _category;
@synthesize range = _range;
@synthesize severity = _severity;

- (id)initWithZeros
{
   self = [super init];
    if (!self) {
        return nil;
    }
    
    _locale = (NSMutableString *) @"";
    _latitude =  0;
    _longitude = 0;
    _uid = 0;
    _category = 0;
    _range  = 1;
    _severity = 1;
    
    return self;
}

@end
