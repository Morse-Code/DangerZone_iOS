//
//  DZMapViewController.m
//  Danger_Tab
//
//

#import <CoreLocation/CoreLocation.h>
#import "DZMapViewController.h"
#import "DZObject.h"
#import "DZTableViewViewController.h"
#import "DZStoredObjects.h"
#import "DZSubmitViewController.h"
#import "DZRequestViewController.h"

@interface DZMapViewController ()


@property (nonatomic, strong) NSMutableArray *userZones;

@end

static NSString *const SubmitViewSegueIdentifier = @"Push Submit View";
static NSString *const RequestViewSegueIdentifier = @"Push Request View";

@implementation DZMapViewController
{
@private
    CLLocationManager *_myLocationManager;
}


@synthesize dangerMap = _dangerMap;
@synthesize dangerZones = _dangerZones;
@synthesize userZones = _userZones;
@synthesize tempPin = _tempPin;
@synthesize myLocationManager = _myLocationManager;
@synthesize currentLocation = _currentLocation;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self mapView:_dangerMap regionDidChangeAnimated:NO];

}


- (void)viewDidUnload
{
    [self.dangerZones removeObserver:self forKeyPath:KVOZonesChangeKey];
    self.userZones = nil;
    self.dangerMap.delegate = nil;
    self.dangerMap = nil;
    [self.myLocationManager stopUpdatingLocation];
    self.myLocationManager = nil;
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setDangerZones:(DZStoredObjects *)dangerZones
{
    if ([_dangerZones isEqual:dangerZones]) {
        return;
    }
    if (_dangerZones != nil) {
        [_dangerZones removeObserver:self forKeyPath:KVOZonesChangeKey];
    }
    _dangerZones = dangerZones;
    if (_dangerZones != nil) {
        [self.dangerZones addObserver:self forKeyPath:KVOZonesChangeKey options:NSKeyValueObservingOptionNew
                              context:nil];
    }
    if (self.isViewLoaded) {
        [self mapView:_dangerMap regionDidChangeAnimated:NO];
    }
}


#pragma mark Map View Delegate methods

- (void)        mapView:(MKMapView *)map
regionDidChangeAnimated:(BOOL)animated
{
    NSArray *oldAnnotations = self.dangerMap.annotations;
    [self.dangerMap removeAnnotations:oldAnnotations];

    NSArray *newAnnotations = [self.dangerZones.zones arrayByAddingObjectsFromArray:(NSArray *)self.userZones];
    [self.dangerMap addAnnotations:newAnnotations];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id < MKAnnotation >)annotation
{
    MKAnnotationView *result = nil;

    if ([annotation isKindOfClass:[DZObject class]] == NO) {
        MKPointAnnotation *senderAnnotation = (MKPointAnnotation *)annotation;
        NSString *pinReusableIdentifier = @"tempZone";
        MKPinAnnotationView *annotationView
                = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation
                                                             reuseIdentifier:pinReusableIdentifier];
        }
        annotationView.canShowCallout = YES;
        [annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
        annotationView.draggable = YES;
        annotationView.animatesDrop = YES;
        annotationView.pinColor = MKPinAnnotationColorPurple;

        result = annotationView;

        return result;

    }

    /* Process this event only for the Map View created previously */
    if ([mapView isEqual:self.dangerMap] == NO) {
        return result;
    }

    DZObject *senderAnnotation = (DZObject *)annotation;

    NSString *pinReusableIdentifier = [DZObject reusableIdentifierForPinColor:senderAnnotation.pinColor];

    MKPinAnnotationView *annotationView
            = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];

    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation
                                                         reuseIdentifier:pinReusableIdentifier];
    }

    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    annotationView.pinColor = senderAnnotation.pinColor;

    result = annotationView;

    return result;
}

#pragma mark - Notification Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{

    if ([keyPath isEqualToString:KVOZonesChangeKey]) {
        [self zonesChange:change];
    }
}


- (void)zonesChange:(NSDictionary *)dictionary
{
    [self mapView:self.dangerMap regionDidChangeAnimated:NO];
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView
    annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
      fromOldState:(MKAnnotationViewDragState)oldState
{

//    if (oldState == MKAnnotationViewDragStateDragging) {
//        DZObject *annotation = (DZObject *)annotationView.annotation;
//    }
}


- (void)      mapView:(MKMapView *)mapView
didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *aView in views) {
        if ([aView.reuseIdentifier isEqualToString:@"Purple"]) {
            aView.alpha = 0;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.8];
            aView.alpha = 1;
            [UIView commitAnimations];
        }
    }
}


- (void)mapView:(MKMapView *)mapView
               annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[DZObject class]]) {
        //handle action for displaying detail of DangerZone
    }
    else
    {

        [self performSegueWithIdentifier:SubmitViewSegueIdentifier sender:view.annotation];
    }

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:SubmitViewSegueIdentifier]) {
        DZSubmitViewController *controller = [segue destinationViewController];
        if (self.userZones == nil) {
            self.userZones = [NSMutableArray arrayWithCapacity:1];
        }
        controller.tempAnnotation = self.tempPin;
        controller.userZones = self.userZones;
    }
    else if ([segue.identifier isEqualToString:RequestViewSegueIdentifier]) {
        DZRequestViewController *controller = [segue destinationViewController];
        controller.tempAnnotation = self.tempPin;
        controller.dangerZones = self.dangerZones;
    }
}


- (void)   alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Request"]) {
        [self performSegueWithIdentifier:RequestViewSegueIdentifier sender:alertView];
    }
    else if ([title isEqualToString:@"Submit"]) {
        [self performSegueWithIdentifier:SubmitViewSegueIdentifier sender:alertView];
    }
//    else if (buttonIndex == [alertView cancelButtonIndex]){
//
//    }
}


- (IBAction)handlePinDrop:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateBegan)
    {
        return;
    }

    CGPoint location = [gesture locationInView:self.dangerMap];
    CLLocationCoordinate2D touchLocation = [self.dangerMap convertPoint:location toCoordinateFromView:self.dangerMap];
    NSLog(@"Long Press Gesture detected");

//    DZObject *newZone = [[DZObject alloc] initWithCoordinate:touchLocation];

    self.tempPin = [[MKPointAnnotation alloc] init];
    self.tempPin.coordinate = touchLocation;
    [self.dangerMap addAnnotation:self.tempPin];


    [[[UIAlertView alloc] initWithTitle:@"Update or Submit?"
                                message:@"Update: Request DangerZones from server.\nSubmit: Submit a new DangerZone."
                               delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Request", @"Submit", nil]
                   show];

//    tempZone.title = @"Submit DangerZone?";


}


- (void)getCurrentLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        self.myLocationManager.purpose = @"To provide functionality based on user's current location.";
        [self.myLocationManager startUpdatingLocation];
    }
    else
    {
/* Location services are not enabled.
Take appropriate action: for instance, prompt the user to enable the location services */
        NSLog(@"Location services are not enabled");
    }
}



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [self.myLocationManager stopUpdatingLocation];
}

@end
