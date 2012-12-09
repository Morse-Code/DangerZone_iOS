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

// The alert delegate methods are used by both the picker alert and the long touch submit/request alert
// (which invokes the picker alert). These tags differentiate.
extern const int PICKER_ALERT;
extern const int REQ_SUB_ALERT;

// Two types of picker alert access tags.
extern const int REQUEST_PICKER;
extern const int SUBMIT_PICKER;

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

- (IBAction)currentLocationRequest:(id)sender;

- (IBAction)currentLocationSubmit:(id)sender;

- (IBAction)zoomToCurrentLocation:(id)sender;

- (IBAction)toggleMapType:(id)sender;

@end
