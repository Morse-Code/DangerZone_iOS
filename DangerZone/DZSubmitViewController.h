//
//  DZSubmitViewController.h
//  Danger_Tab
//
//  Created by rbelford on 10/16/12.
//  Copyright (c) 2012 rbelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLGeocoder.h>
#import "DTMutableObject.h"
#import <MapKit/MapKit.h>

//@class DZObject;

@interface DZSubmitViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>


@property(nonatomic, retain) IBOutlet UITextField *localeText;
@property(strong, nonatomic) IBOutlet UIPickerView *picker;
@property(nonatomic, retain) CLGeocoder *geoCoder;
@property NSArray *categoryStrings;
@property(strong, nonatomic) NSArray *severityStrings;
@property DTMutableObject *updateObj; // the model's variables, see DTMutableObject.h
@property(nonatomic, strong) NSMutableArray *userZones;
@property(nonatomic, weak) MKPointAnnotation *tempAnnotation;

- (IBAction)onReturnPressed:(id)sender;

- (IBAction)onSubmitPressed:(id)sender;

@property(nonatomic, strong);


@end
