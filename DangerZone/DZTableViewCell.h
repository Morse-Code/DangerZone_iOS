//
//  DZTableViewCell.h
//  DangerZone
//
//  Created by Christopher Morse on 10/17/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLGeocoder.h>

@class DZObject;

@interface DZTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (retain, nonatomic) IBOutlet UIImageView *categoryImage;
@property (nonatomic, strong) DZObject *dangerZone;
@property (nonatomic, retain) CLGeocoder *geoCoder;

@end