//
//  DZMapViewController.h
//  Danger_Tab
//
//  Created by rbelford on 10/16/12.
//  Copyright (c) 2012 rbelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/MapKit.h>
#import "DZPickerAlertView.h"

@class DZStoredObjects;

extern const int PICKER_ALERT;
extern const int REQUEST_PICKER; // so that the two pickers get initialized with
extern const int SUBMIT_PICKER;  // their appropriate values

@interface DZMapViewController : UIViewController < MKMapViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource >


@property (nonatomic, strong) IBOutlet MKMapView *dangerMap;
@property (nonatomic, readonly) DZStoredObjects *dangerZones;
@property (nonatomic) MKPointAnnotation *tempPin;
@property (strong, nonatomic) NSArray *radiusStrings;
@property (strong, nonatomic) NSArray *radiusValues; // in parallel with radiusStrings
@property (strong, nonatomic) NSArray *categoryStrings;


@property (nonatomic, strong) CLLocationManager *myLocationManager;

@property (nonatomic) CLLocationCoordinate2D currentLocation;

- (IBAction)handlePinDrop:(UILongPressGestureRecognizer *)gesture;

- (IBAction)currrentLocationRequest:(id)sender;

- (IBAction)currentLocationSubmit:(id)sender;

- (IBAction)zoomToCurrentLocation:(id)sender;

- (IBAction)toggleMapType:(id)sender;

@end
