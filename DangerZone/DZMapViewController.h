//
//  DZMapViewController.h
//  Danger_Tab
//
//  Created by rbelford on 10/16/12.
//  Copyright (c) 2012 rbelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/MapKit.h>

@class DZStoredObjects;

@interface DZMapViewController : UIViewController < MKMapViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate >


@property (nonatomic, strong) IBOutlet MKMapView *dangerMap;
@property (nonatomic, readonly) DZStoredObjects *dangerZones;
@property (nonatomic) MKPointAnnotation * tempPin;

@property (nonatomic, strong) CLLocationManager *myLocationManager;

@property (nonatomic) CLLocationCoordinate2D currentLocation;

-(IBAction)handlePinDrop:(UILongPressGestureRecognizer *)gesture;

@end
