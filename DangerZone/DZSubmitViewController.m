//
//  DZSubmitViewController.m
//  Danger_Tab
//
//  Created by rbelford on 10/16/12.
//  Copyright (c) 2012 rbelford. All rights reserved.
//

#import <CoreLocation/CLPlacemark.h>
#import <CoreLocation/CoreLocation.h>
#import "DZSubmitViewController.h"
#import "DZObject.h"

@interface DZSubmitViewController ()


@property (nonatomic, strong) DZObject *userZone;
@property (nonatomic, strong) NSDictionary *attributes;

@end

@implementation DZSubmitViewController


@synthesize picker = _picker;
//@synthesize updateObj = _updateObj;
@synthesize severityStrings = _severityStrings;
@synthesize categoryStrings = _categoryStrings;
//@synthesize geoCoder = _geoCoder;
//@synthesize localeText = _localeText;
@synthesize tempAnnotation = _tempAnnotation;
@synthesize userZones = _userZones;
@synthesize attributes = _attributes;
@synthesize userZone = _userZone;


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
    // Do any additional setup after loading the view.
    self.categoryStrings = [[NSArray alloc] initWithObjects:@"Fire", @"Accident", @"Riot", @"Gunfire", nil];
    self.severityStrings = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
    self.attributes = [NSMutableDictionary dictionaryWithCapacity:4];
    // initialize category
    [self.attributes setValue:[NSNumber numberWithInt:(NSUInteger)0] forKey:@"category"];
    // intialize these so that the init routine doesn't crash
    [self.attributes setValue:[NSNumber numberWithInt:(NSUInteger)5] forKey:@"severity"];
    [self.attributes setValue:[NSNumber numberWithInt:(NSUInteger)10] forKey:@"radius"];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.categoryStrings = nil;
    self.severityStrings = nil;
    self.attributes = nil;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    //NSLog(@"in row width");
    if (component == 0) {
        return 105; // category width
    }
    else
    {
        return 50;   // severity width
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component
{
    //NSLog(@"in row height");
    return 35;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) { // category #rows
        return [self.categoryStrings count];
    }
    else
    { // severity #rows
        return [self.severityStrings count];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (component == 0) { // category strings
        return [self.categoryStrings objectAtIndex:(NSUInteger)row];
    }
    else
    { // severity strings
        return [self.severityStrings objectAtIndex:(NSUInteger)row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    NSNumber *value = [NSNumber numberWithInteger:row];
    component == 0 ? ([self.attributes setValue:value forKey:@"category"]) : ([self.attributes setValue:value
                                                                                                 forKey:@"severity"]);
    NSLog(@"Report Selection: row=%d component=%d", row, component);
    /*NSLog(@"Report Selection: category=%d severity=%d", [[self.attributes valueForKey:@"category"]
                                                                          integerValue], [[self.attributes valueForKey:@"severity"]
                                                                          integerValue]);*/
}


- (IBAction)onReturnPressed:(id)sender
{
//    [self.attributes setValue:self.localeText.text forKey:@"locale"];
//    NSLog(@"onReturnPressed, text field: %@", self.updateObj.locale);
    [sender resignFirstResponder];
}


- (IBAction)onSubmitPressed:(id)sender
{

    // category was initialized in viewDidLoad:, and changed with the picker
    // long and lat attributes are set by the map view on a long touch
    [self.attributes setValue:[NSNumber numberWithDouble:self.tempAnnotation.coordinate.latitude] forKey:@"latitude"];
    [self.attributes setValue:[NSNumber numberWithDouble:self.tempAnnotation.coordinate.longitude] forKey:@"longitude"];

    // set the timestamp attribute
    NSTimeInterval timestamp = [[[NSDate alloc] init] timeIntervalSince1970];
    [self.attributes setValue:[NSNumber numberWithDouble:timestamp] forKey:@"timestamp"];

    // severity not yet used.
    //[self.attributes setValue:[NSNumber numberWithInt:[self.picker selectedRowInComponent:1]] forKey:@"severity"];

    self.userZone = [[DZObject alloc] initUserSubmittedWithAttributes:self.attributes];

    [self.userZones addObject:self.userZone];
    NSLog(@"Object added");

    // do a get to the server
    [DZObject dangerZoneObjectsForOperation:@"submit" WithParameters:(NSDictionary *)self.attributes
                                   AndBlock:^(NSArray *dangerZones, NSError *error)
                                   {
                                       if (error) {
                                           [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                       message:[error localizedDescription] delegate:nil
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:NSLocalizedString(@"OK", nil), nil]
                                                          show];
                                       }
                                       else
                                       {
                                           //[self.userZones addObject:[dangerZones objectAtIndex:0]];
                                       }
                                   }];
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//    if (!self.geoCoder) {
//        self.geoCoder = [[CLGeocoder alloc] init];
//    }

/*[self.geoCoder geocodeAddressString:self.updateObj.locale completionHandler:^(NSArray *placemarks, NSError *error)
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
 // Need to wait for completion of geocoding ???????
 NSLog(@"*************************");
 NSLog(@"category= %d", self.updateObj.category);
 NSLog(@"severity= %d", self.updateObj.severity);
 NSLog(@"locale= %@", self.updateObj.locale);
 NSLog(@"latitude= %f", self.updateObj.latitude);
 NSLog(@"longitude= %f", self.updateObj.longitude);*/
