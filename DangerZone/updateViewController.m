//
//  updateViewController.m
//  Danger_Tab
//
//  Created by rbelford on 10/16/12.
//  Copyright (c) 2012 rbelford. All rights reserved.
//

#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import "updateViewController.h"
#import "DTMutableObject.h"

@interface updateViewController ()

@end

@implementation updateViewController

//@synthesize uid,category,longitude,latitude,range,locale,categoryString,rangeString;

@synthesize picker = _picker;
@synthesize updateObj = _updateObj;
@synthesize rangeStrings = _rangeStrings;
@synthesize rangeValues = _rangeValues;


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
    //self.updateObj = [[DTMutableObject alloc] initWithZeros];
    //self.categoryStrings = [[NSArray alloc] initWithObjects:
    self.categoryStrings = [NSArray  arrayWithObjects:
                     @"All",@"Fire",@"Accident",@"Riot",@"Gunfire",nil];
    
    self.rangeStrings = [NSArray arrayWithObjects:
                     @"1k",@"5k",@"10k",@"25k",@"50k",@"100k",@"500k",@"1000k",@"5000k",nil];
    //self.rangeValues = [NSArray arrayWithObjects:{1,5,10,25,50,100,500,1000,5000,nil}];
    self.rangeValues =  [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                        [NSNumber numberWithInt:5],[NSNumber numberWithInt:10],
                        [NSNumber numberWithInt:25],[NSNumber numberWithInt:50],
                        [NSNumber numberWithInt:100],[NSNumber numberWithInt:500],
                        [NSNumber numberWithInt:1000],[NSNumber numberWithInt:50000],
                        nil];
                        // read as:  int i = [[array objectsAtIndex:0] intValue];
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
        return 75;   // range width
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
    else { // range #rows
        return [self.rangeStrings count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (component == 0) { // category strings
        return [self.categoryStrings objectAtIndex:row];
    }
    else { // range strings
        return [self.rangeStrings objectAtIndex:row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSLog(@"Update selection: row=%d component=%d",row,component);
    if (component == 0) { // category selected
        self.updateObj.category = row;
    } else { // severity selected
        self.updateObj.range = [[self.rangeValues objectAtIndex:row] intValue];
    }
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
    // Need to wait for completion of geocoding - how ???????
    NSLog(@"*************************");
    NSLog(@"category= %d",self.updateObj.category);
    NSLog(@"range= %d",self.updateObj.range);
    NSLog(@"locale= %@",self.updateObj.locale);
    NSLog(@"latitude= %f",self.updateObj.latitude);
    NSLog(@"longitude= %f",self.updateObj.longitude);
}

- (IBAction)onGlobalPressed:(id)sender
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
