//
//  DTMutableObject.h
//  Danger_Tab
//
//  Created by rbelford on 10/23/12.
//  Copyright (c) 2012 rbelford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTMutableObject : NSObject


//@property NSMutableString *locale; // entered by user
@property NSString *locale; // entered by user
@property float longitude;    // geocoded from locale
@property float latitude;     // geocoded from locale
@property NSUInteger uid;      // ???
@property NSUInteger category; // mapped directly as categoryStrings picker row
@property NSUInteger range;    // from rangeValues mapped from rangeStrings row in update picker
@property NSUInteger severity; // mapped directly as severityStrings picker row in report picker

- (id)initWithZeros;

@end
