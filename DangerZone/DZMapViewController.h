//
//  DZMapViewController.h
//  Danger_Tab
//
//  Created by rbelford on 10/16/12.
//  Copyright (c) 2012 rbelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/MapKit.h>

@class DZTableViewViewController;

@interface DZMapViewController : UIViewController < MKMapViewDelegate >


@property (nonatomic, weak) IBOutlet MKMapView *dangerMap;
@property (nonatomic, weak) DZTableViewViewController *tableView;

@end
