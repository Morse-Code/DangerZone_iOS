//
//  reportViewController.h
//  Danger_Tab
//
//  Created by rbelford on 10/16/12.
//  Copyright (c) 2012 rbelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLGeocoder.h>
#import "DTMutableObject.h"

@interface reportViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,retain) IBOutlet UITextField *localeText;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property  (nonatomic,retain) CLGeocoder *geoCoder;
@property NSArray *categoryStrings;
@property (strong, nonatomic) NSArray *severityStrings; 
@property DTMutableObject *updateObj; // the model's variables, see DTMutableObject.h

- (IBAction)onReturnPressed:(id)sender;
- (IBAction)onSubmitPressed:(id)sender;

@end
