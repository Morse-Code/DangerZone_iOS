//
//  DZMapViewController.m
//  Danger_Tab
//
//

#import "DZMapViewController.h"
#import "DZObject.h"
#import "DZTableViewViewController.h"
#import "DZStoredObjects.h"

@interface DZMapViewController ()


@property (nonatomic, strong) NSMutableArray *userZones;

@end

@implementation DZMapViewController


@synthesize dangerMap = _dangerMap;
@synthesize dangerZones = _dangerZones;
@synthesize userZones = _userZones;


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
    annotationView.draggable = YES;
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


- (IBAction)handlePinDrop:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateBegan)
    {
        return;
    }

    CGPoint location = [gesture locationInView:self.dangerMap];
    CLLocationCoordinate2D touchLocation = [self.dangerMap convertPoint:location toCoordinateFromView:self.dangerMap];

    NSLog(@"Long Press Gesture detected");

    DZObject *newZone = [[DZObject alloc] initWithCoordinate:touchLocation];
    [self.dangerMap addAnnotation:newZone];
    if (self.userZones == nil){
        self.userZones = [NSMutableArray arrayWithObject:newZone];
    }else{
        [self.userZones addObject:newZone];
    }

}
@end
