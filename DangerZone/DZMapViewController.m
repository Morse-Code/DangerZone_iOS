//
//  DZMapViewController.m
//  Danger_Tab
//
//

#import "DZMapViewController.h"
#import "DZObject.h"
#import "DZTableViewViewController.h"

@interface DZMapViewController ()


@end

@implementation DZMapViewController
{
}


//@synthesize dangerMap = _dangerMap;
@synthesize tableView = _tableView;
@synthesize dangerMap = _dangerMap;


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];


    [self mapView:_dangerMap regionDidChangeAnimated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Map View Delegate methods

- (void)        mapView:(MKMapView *)map
regionDidChangeAnimated:(BOOL)animated
{
    NSArray *oldAnnotations = _dangerMap.annotations;
    [_dangerMap removeAnnotations:oldAnnotations];

    NSArray *dangerZones = [_tableView dangerZones];
    [_dangerMap addAnnotations:dangerZones];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id < MKAnnotation >)annotation
{
    MKAnnotationView *result = nil;

    if ([annotation isKindOfClass:[DZObject class]] == NO) {
        return result;
    }

    /* Process this event only for the Map View created previously */
    if ([mapView isEqual:_dangerMap] == NO) {
        return result;
    }

    /* typecast the annotation for which the Map View has fired this delegate message */
    DZObject *senderAnnotation = (DZObject *)annotation;

    /* Using the class method we have defined in our custom annotation class, we will attempt to get a reusable identifier for the pin we are about to create */
    NSString *pinReusableIdentifier = [DZObject reusableIdentifierforPinColor:senderAnnotation.pinColor];

    /* Using the identifier we retrieved above, we will attempt to reuse a pin in the sender Map View */
    MKPinAnnotationView *annotationView
            = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];

    /* If we fail to reuse a pin, then we will create one */
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation
                                                         reuseIdentifier:pinReusableIdentifier];

        /* Make sure we can see the callouts on top of each pin in case we have assigned title and/or subtitle to each pin */
        [annotationView setCanShowCallout:YES];
    }

    /* Now make sure, whether we have reused a pin or not, that the color of the pin matches the color of the annotation */
    annotationView.pinColor = senderAnnotation.pinColor;

    result = annotationView;

    return result;
}

@end
