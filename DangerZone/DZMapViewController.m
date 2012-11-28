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
#import "DZPickerAlertView.h"

@interface DZMapViewController ()


@property (nonatomic, strong) NSMutableArray *userZones;
@property (nonatomic, strong) NSMutableDictionary *attributes;
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
@synthesize radiusStrings = _radiusStrings;
@synthesize radiusValues = _radiusValues;
@synthesize categoryStrings = _categoryStrings;
@synthesize attributes = _attributes;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self mapView:_dangerMap regionDidChangeAnimated:NO];

    // set up the picker display strings and values
    self.radiusStrings = [NSArray arrayWithObjects:@"      Global", @"         1k", @"         5k", @"        10k",
                                                   @"        25k", @"        50k", @"       100k", @"       500k",
                                                   @"      1000k", @"      5000k", nil];
    // translate radius string to int
    self.radiusValues = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1],
                                                  [NSNumber numberWithInt:5], [NSNumber numberWithInt:10],
                                                  [NSNumber numberWithInt:25], [NSNumber numberWithInt:50],
                                                  [NSNumber numberWithInt:100], [NSNumber numberWithInt:500],
                                                  [NSNumber numberWithInt:1000], [NSNumber numberWithInt:5000], nil];
    self.categoryStrings = [[NSArray alloc] initWithObjects:@" Unclassified", @"    Weather", @"    Violence",
                                                            @"    Accident", nil];

    //self.attributes = [NSMutableDictionary dictionaryWithCapacity:4];

    // defaults for category and radius attributes
    // long and lat are set from long map touch, before loading this view

    //[self.attributes setValue:[NSNumber numberWithInt:0] forKey:@"category"];
    //[self.attributes setValue:[self.radiusValues objectAtIndex:(NSUInteger)0] forKey:@"radius"];
    self.attributes = [NSMutableDictionary dictionaryWithCapacity:4];


    _myLocationManager = [[CLLocationManager alloc] init];
    [_myLocationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_myLocationManager setDelegate:self];

    [_myLocationManager startUpdatingLocation];

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
        if (alertView.tag != PICKER_ALERT) { // got here from long touch

            [self.attributes setValue:[NSNumber numberWithDouble:self.tempPin.coordinate.latitude] forKey:@"latitude"];
            [self.attributes setValue:[NSNumber numberWithDouble:self.tempPin.coordinate.longitude]
                               forKey:@"longitude"];

            DZPickerAlertView *pickerAlertView = [[DZPickerAlertView alloc] initWithTitle:@"Radius (kilometers)"
                                                                                  message:@"Request"
                                                                                 delegate:alertView.delegate
                                                                        cancelButtonTitle:@"Cancel"
                                                                        otherButtonTitles:@"Request", nil];
            pickerAlertView.tag = PICKER_ALERT;
            [pickerAlertView show];
        }
        else
        { // got here from picker
            //////////////////////////////
            // the dictionary has been filled in, now send it.
            NSLog(@"Process the request");
            //////////////////////////////
        }
        //[self performSegueWithIdentifier:RequestViewSegueIdentifier sender:alertView];
    }
    else if ([title isEqualToString:@"Submit"]) {
        if (alertView.tag != PICKER_ALERT) { // got here from long touch

            [self.attributes setValue:[NSNumber numberWithDouble:self.tempPin.coordinate.latitude] forKey:@"latitude"];
            [self.attributes setValue:[NSNumber numberWithDouble:self.tempPin.coordinate.longitude]
                               forKey:@"longitude"];
            // set the timestamp attribute
            NSTimeInterval timestamp = [[[NSDate alloc] init] timeIntervalSince1970];
            [self.attributes setValue:[NSNumber numberWithDouble:timestamp] forKey:@"timestamp"];

            DZPickerAlertView *pickerAlertView = [[DZPickerAlertView alloc] initWithTitle:@"Category" message:@"Submit"
                                                                                 delegate:alertView.delegate
                                                                        cancelButtonTitle:@"Cancel"
                                                                        otherButtonTitles:@"Submit", nil];
            pickerAlertView.tag = PICKER_ALERT;
            [pickerAlertView show];
        }
        else
        { // got here from picker
            ///////////////////////////////
            // the dictionary has been filled in, now send it.
            NSLog(@"Process the submit");
            //////////////////////////////
        }
        //[self performSegueWithIdentifier:SubmitViewSegueIdentifier sender:alertView];
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


- (IBAction)currrentLocationRequest:(id)sender
{
    [self.myLocationManager startUpdatingLocation];
    [self zoomToCurrentLocation:self];
    self.tempPin = [[MKPointAnnotation alloc] init];
    self.tempPin.coordinate = self.currentLocation;
    [self.dangerMap addAnnotation:self.tempPin];
    // fill in long/lat at current location.  THIS IS NOW SET TO TOUCH POINT
    [self.attributes setValue:[NSNumber numberWithDouble:self.tempPin.coordinate.latitude] forKey:@"latitude"];
    [self.attributes setValue:[NSNumber numberWithDouble:self.tempPin.coordinate.longitude] forKey:@"longitude"];
    DZPickerAlertView *pickerAlertView = [[DZPickerAlertView alloc]
                                                             initWithTitle:@"Radius (kilometers)" message:@"Request"
                                                                  delegate:self cancelButtonTitle:@"Cancel"
                                                         otherButtonTitles:@"Request", nil];
    pickerAlertView.tag = PICKER_ALERT;
    [pickerAlertView show];
}


- (IBAction)currentLocationSubmit:(id)sender
{
    [self.myLocationManager startUpdatingLocation];
    [self zoomToCurrentLocation:self];
    self.tempPin = [[MKPointAnnotation alloc] init];
    self.tempPin.coordinate = self.currentLocation;
    [self.dangerMap addAnnotation:self.tempPin];
    // fill in long/lat at current location.  THIS IS NOW SET TO TOUCH POINT
    [self.attributes setValue:[NSNumber numberWithDouble:self.tempPin.coordinate.latitude] forKey:@"latitude"];
    [self.attributes setValue:[NSNumber numberWithDouble:self.tempPin.coordinate.longitude] forKey:@"longitude"];
    // set time stamp
    NSTimeInterval timestamp = [[[NSDate alloc] init] timeIntervalSince1970];
    [self.attributes setValue:[NSNumber numberWithDouble:timestamp] forKey:@"timestamp"];

    DZPickerAlertView *pickerAlertView = [[DZPickerAlertView alloc]
                                                             initWithTitle:@"Category" message:@"Submit" delegate:self
                                                         cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    pickerAlertView.tag = PICKER_ALERT;
    [pickerAlertView show];
}


- (IBAction)zoomToCurrentLocation:(id)sender
{
    NSLog(@"zoomToCurrentLocation");
    //CLLocation *currentLocation = _myLocationManager.location;

    [_myLocationManager startUpdatingLocation];

    //[_dangerMap setCenterCoordinate:_dangerMap.userLocation.coordinate animated:YES];

    NSLog(@"lat:  %f", _myLocationManager.location.coordinate.latitude);
    NSLog(@"long: %f", _myLocationManager.location.coordinate.longitude);

    // 2
    MKCoordinateRegion
            viewRegion = MKCoordinateRegionMakeWithDistance(_myLocationManager.location.coordinate, 10000, 10000);
    // 3
    MKCoordinateRegion adjustedRegion = [_dangerMap regionThatFits:viewRegion];
    // 4
    [_dangerMap setRegion:adjustedRegion animated:YES];

    [_myLocationManager stopUpdatingLocation];

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
    self.currentLocation = CLLocationCoordinate2DMake(newLocation.coordinate.latitude,
                                                      newLocation.coordinate.longitude);
    [self.myLocationManager stopUpdatingLocation];
}

#pragma mark - picker data methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    return 150; // category width
}


- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component
{
    return 35;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == SUBMIT_PICKER) {
        return [self.categoryStrings count];
    }
    else
    {
        return [self.radiusStrings count];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (pickerView.tag == SUBMIT_PICKER) {
        return [self.categoryStrings objectAtIndex:(NSUInteger)row];
    }
    else
    {
        return [self.radiusStrings objectAtIndex:(NSUInteger)row];
    }
}

#pragma mark - picker delegate method


- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{

    if (pickerView.tag == SUBMIT_PICKER) {

        //NSLog(@"Category selection in map view: row=%d component=%d", row, component);
        [self.attributes setValue:[NSNumber numberWithInteger:row] forKey:@"category"];
        NSLog(@"Category = %d", [[self.attributes valueForKeyPath:@"category"] integerValue]);
    }
    else
    { // REQUEST_PICKER;
        //NSLog(@"Radius selection in map view: row=%d component=%d", row, component);
        [self.attributes setValue:[self.radiusValues objectAtIndex:row] forKey:@"radius"];
        NSLog(@"Radius = %d", [[self.attributes valueForKeyPath:@"radius"] integerValue]);
    }
}


@end
