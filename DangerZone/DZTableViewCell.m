//
//  DZTableViewCell.m
//  DangerZone
//
//  Created by Christopher Morse on 10/17/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import "DZTableViewCell.h"
#import "DZObject.h"

//static NSString *CATEGORIES[] = {@"Unclassified", @"Weather", @"Violence", @"Accident"};

@implementation DZTableViewCell
{
@private
    __strong DZObject *_dangerZone;
}


@synthesize dangerZone = _dangerZone;
@synthesize geoCoder = _geoCoder;


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setDangerZone:(DZObject *)dangerZone
{
    _dangerZone = dangerZone;

    // reverse geocoding will potentially return many parameters per placemark.  Based on what we get, we prioritize
    // them and build strings
    if (!self.geoCoder) {
        self.geoCoder = [[CLGeocoder alloc] init];
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[_dangerZone.latitude doubleValue]
                                                      longitude:[_dangerZone.longitude doubleValue]];
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if (error != nil) {
            NSLog(@"Server returned an error");
            return;
        }
        if ([placemarks count] > 0) { // Potential for more than one placemark returned by server. Haven't seen more
                                      //than one, though, so we just grab the one at index 0 (as does Apple sample code).
            NSString *imageFile = [NSString stringWithFormat:@"%@.png",
                                                             [DZObject stringFromCategory:self.dangerZone.category]];
            self.categoryImage.image = [UIImage imageNamed:imageFile];
            self.categoryLabel.text = [DZObject stringFromCategory:self.dangerZone.category];
            CLPlacemark *thisLocale = [placemarks objectAtIndex:0];
            self.countryLabel.text = @"";
            if (thisLocale.locality != nil) {
                self.cityLabel.text = [NSString stringWithFormat:@"%@, %@", thisLocale.locality,
                                                                 thisLocale.administrativeArea];
                self.countryLabel.text = thisLocale.country;
            }
            else if (thisLocale.name != nil) {
                self.cityLabel.text = thisLocale.name;
                self.countryLabel.text = thisLocale.country;
            }
            else if ([thisLocale.areasOfInterest objectAtIndex:0] != nil) {
                self.cityLabel.text = [thisLocale.areasOfInterest objectAtIndex:0];
            }
            else if (thisLocale.inlandWater != nil) {
                self.cityLabel.text = thisLocale.inlandWater;
            }
            else if (thisLocale.ocean != nil) {
                self.cityLabel.text = thisLocale.ocean;
            }
            else
            {
                self.cityLabel.text = @"";
            }
            /*
            NSLog(@"Placemark.locality: %@", thisLocale.locality);
            NSLog(@"PLacemark.name: %@", thisLocale.name);
            NSLog(@"PLacemark.country: %@", thisLocale.country);
            NSLog(@"PLacemark.ISOcountry: %@", thisLocale.ISOcountryCode);
            NSLog(@"PLacemark.administrativeArea: %@", thisLocale.administrativeArea);
            NSLog(@"PLacemark.areasOfInterest: %@", [thisLocale.areasOfInterest objectAtIndex:0]);
            NSLog(@"PLacemark.inlandWater: %@", thisLocale.inlandWater);
            NSLog(@"PLacemark.ocean: %@", thisLocale.ocean);
            //NSLog(@"distance: %f", [location distanceFromLocation:location]);
             */
        }
        else
        {
            NSLog(@"No error, but no placemarks either.");
        }
    }];
}


- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
