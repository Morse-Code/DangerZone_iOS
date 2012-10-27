//
//  reportViewController.m
//  Danger_Tab
//
//  Created by rbelford on 10/16/12.
//  Copyright (c) 2012 rbelford. All rights reserved.
//

#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import "reportViewController.h"
#import "DTMutableObject.h"

@interface reportViewController ()

@end

@implementation reportViewController

@synthesize picker = _picker;
@synthesize updateObj = _updateObj;
@synthesize severityStrings = _severityStrings;
@synthesize categoryStrings = _categoryStrings;
@synthesize geoCoder = _geoCoder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.categoryStrings = [[NSArray alloc] initWithObjects:
                    @"Fire",@"Accident",@"Riot",@"Gunfire",nil];
    self.severityStrings = [NSArray arrayWithObjects: @"1",@"2",@"3",
                    @"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];
    self.updateObj = [[DTMutableObject alloc] initWithZeros];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    //NSLog(@"in row width");
    if (component == 0) {
        return 105; // category width
    }
    else {
        return 50;   // severity width
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    //NSLog(@"in row height");
    return 35;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) { // category #rows
        return [self.categoryStrings count];
    }
    else { // severity #rows
        return [self.severityStrings count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (component == 0) { // category strings
        return [self.categoryStrings objectAtIndex:row];
    }
    else { // severity strings
        return [self.severityStrings objectAtIndex:row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if (component == 0) { // category selected
        self.updateObj.category = row;
    } else { // severity selected
        self.updateObj.severity = row+1; // indeces start at 0
    }
    NSLog(@"Report Selection: row=%d component=%d",row,component);
    NSLog(@"Report Selection: category=%d severity=%d",self.updateObj.category,
                                                       self.updateObj.severity);
}

- (IBAction)onReturnPressed:(id)sender
{
    self.updateObj.locale = self.localeText.text;
    NSLog(@"onReturnPressed, text field: %@",self.updateObj.locale);
    self.localeText.text = @"";
    [sender resignFirstResponder];
}


- (IBAction)onSubmitPressed:(id)sender
{
    if (!self.geoCoder) {
        self.geoCoder = [[CLGeocoder alloc] init];
    }
    [self.geoCoder geocodeAddressString:self.updateObj.locale
                 completionHandler:
                    ^(NSArray* placemarks, NSError* error)
                     {
                        if (error != nil)
                            NSLog(@"Error: %@", error);
                        else
                            for (CLPlacemark* aPlacemark in placemarks)
                                {
                                    self.updateObj.latitude = aPlacemark.location.coordinate.latitude;
                                    self.updateObj.longitude = aPlacemark.location.coordinate.longitude;
                                    NSLog(@"setting latitude %f",self.updateObj.latitude);
                                    NSLog(@"setting longitude %f",self.updateObj.longitude);
                                }       
                     }];
    // Need to wait for completion of geocoding ???????
    NSLog(@"*************************");
    NSLog(@"category= %d",self.updateObj.category);
    NSLog(@"severity= %d",self.updateObj.severity);
    NSLog(@"locale= %@",self.updateObj.locale);
    NSLog(@"latitude= %f",self.updateObj.latitude);
    NSLog(@"longitude= %f",self.updateObj.longitude);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
