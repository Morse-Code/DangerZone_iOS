//
//  DZRequestViewController.m
//  Danger_Tab
//
//  Created by rbelford on 10/16/12.
//  Copyright (c) 2012 rbelford. All rights reserved.
//

#import <CoreLocation/CLPlacemark.h>
#import "DZRequestViewController.h"
#import "DZSharedClient.h"
#import "DZObject.h"
#import "DZStoredObjects.h"

static NSString *CATEGORIES[] = {@"Fire", @"Accident", @"Riot", @"Gunfire", @"Horrid Fart", nil};

@interface DZRequestViewController ()


@property(nonatomic, strong) NSDictionary *attributes;


@end

@implementation DZRequestViewController

//@synthesize uid,category,longitude,latitude,radius,locale,categoryString,radiusString;

@synthesize picker = _picker;
@synthesize radiusStrings = _radiusStrings;
@synthesize radiusValues = _radiusValues;
@synthesize tempAnnotation = _tempAnnotation;
@synthesize attributes = _attributes;
@synthesize dangerZones = _dangerZones;


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // picker strings
    self.categoryStrings = [NSArray arrayWithObjects:CATEGORIES count:5];

    self.radiusStrings
            = [NSArray arrayWithObjects:@"1k", @"5k", @"10k", @"25k", @"50k", @"100k", @"500k", @"1000k", @"5000k", nil];
    // translate radius string to int
    self.radiusValues
            = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:5], [NSNumber numberWithInt:10], [NSNumber numberWithInt:25], [NSNumber numberWithInt:50], [NSNumber numberWithInt:100], [NSNumber numberWithInt:500], [NSNumber numberWithInt:1000], [NSNumber numberWithInt:50000], nil];

    self.attributes = [NSMutableDictionary dictionaryWithCapacity:4];

    // defaults for category and radius attributes
    // long and lat are set from long map touch, before loading this view

    [self.attributes setValue:[NSNumber numberWithInt:0] forKey:@"category"];
    [self.attributes setValue:[self.radiusValues objectAtIndex:(NSUInteger)0] forKey:@"radius"];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component {
    //NSLog(@"in row width");
    if (component == 0) {
        return 105; // category width
    }
    else
    {
        return 75;   // radius width
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component {
    //NSLog(@"in row height");
    return 35;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) { // category #rows
        return [self.categoryStrings count];
    }
    else
    { // radius #rows
        return [self.radiusStrings count];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    if (component == 0) { // category strings
        return [self.categoryStrings objectAtIndex:(NSUInteger)row];
    }
    else
    { // radius strings
        return [self.radiusStrings objectAtIndex:(NSUInteger)row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    NSLog(@"Update selection: row=%d component=%d", row, component);
    /*if (component == 0) { // category selected
        [self.attributes setValue:[self.categoryStrings objectAtIndex:(NSUInteger)row] forKey:@"category"];
    }
    else
    { // severity selected
        [self.attributes setValue:[self.rangeValues objectAtIndex:(NSUInteger)row] forKey:@"radius"];
    }*/
}


- (IBAction)onReturnPressed:(id)sender {

    [sender resignFirstResponder];
}


- (IBAction)onRequestPressed:(id)sender {
    // category and radius attributes were initialized in viewDidLoad:, and changed with the picker
    // long and lat attributes are set by the map view on a long touch
    [self.attributes setValue:[NSNumber numberWithInt:[self.picker selectedRowInComponent:0]] forKey:@"category"];
//    [self.attributes setValue:[self.radiusValues objectAtIndex:(NSUInteger)[self.picker selectedRowInComponent:1]] forKey:@"radius"];
    [self.attributes setValue:[NSNumber numberWithInt:0] forKey:@"radius"];
    [self.attributes setValue:[NSNumber numberWithDouble:self.tempAnnotation.coordinate.latitude] forKey:@"latitude"];
    [self.attributes setValue:[NSNumber numberWithDouble:self.tempAnnotation.coordinate.longitude] forKey:@"longitude"];
    //[self.attributes setValue:[NSNumber numberWithDouble:self.tempAnnotation.coordinate.longitude] forKey:@"timestamp"];
    [DZObject dangerZoneObjectsForOperation:@"request" WithParameters:self.attributes AndBlock:^(NSArray *dangerZones, NSError *error) {
        if (error) {
            [[[UIAlertView alloc]
                           initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil]
                           show];
        }
        else
        {
            [self.dangerZones updateWithArray:dangerZones];
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onGlobalPressed:(id)sender {
    // This is a kludge. If these aren't set initUserSubmittedWithAttributes: spews.
    [self.attributes setValue:[NSNumber numberWithDouble:self.tempAnnotation.coordinate.latitude] forKey:@"latitude"];
    [self.attributes setValue:[NSNumber numberWithDouble:self.tempAnnotation.coordinate.longitude] forKey:@"longitude"];

    // do a get to the server
    [DZObject dangerZoneObjectsForOperation:@"global" WithParameters:(NSDictionary *)self.attributes AndBlock:^(NSArray *dangerZones, NSError *error) {
        if (error) {
            [[[UIAlertView alloc]
                           initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil]
                           show];
        }
        else
        {
            [self.dangerZones updateWithArray:dangerZones];
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*    if (!self.geoCoder) {
 self.geoCoder = [[CLGeocoder alloc] init];
 }
 [self.geoCoder geocodeAddressString:self.updateObj.locale completionHandler:^(NSArray *placemarks, NSError *error)
 {
 if (error != nil) {
 NSLog(@"Error: %@", error);
 }
 else
 {
 for (CLPlacemark *aPlacemark in placemarks)
 {
 self.updateObj.latitude = (float)aPlacemark.location.coordinate.latitude;
 self.updateObj.longitude = (float)aPlacemark.location.coordinate.longitude;
 NSLog(@"setting latitude %f", self.updateObj.latitude);
 NSLog(@"setting longitude %f", self.updateObj.longitude);
 }
 }
 }];
 // Need to wait for completion of geocoding - how ???????
 
 
 [[DZSharedClient sharedClient] getPath:request parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON){
 // some stuff
 
 }failure:^(AFHTTPRequestOperation *operation, NSError *error){
 //some stuff
 }];*/

@end
