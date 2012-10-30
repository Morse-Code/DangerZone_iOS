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

@interface DZMapViewController : UIViewController < MKMapViewDelegate >


@property (nonatomic, strong) IBOutlet MKMapView *dangerMap;
@property (nonatomic, readonly) DZStoredObjects *dangerZones;

-(IBAction)handlePinDrop:(UILongPressGestureRecognizer *)gesture;

@end
