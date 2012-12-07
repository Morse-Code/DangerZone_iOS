//
//  DZPickerAlertView.m
//  DangerZone
//
//  Created by rbelford on 11/25/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//
//  Put a picker in an alert view.

#import "DZPickerAlertView.h"

@implementation DZPickerAlertView


@synthesize pickerView = _pickerView;

// The alert delegate methods are used by both the picker alert and the long touch submit/request alert
// (which invokes the picker alert). These tags differentiate.
const int PICKER_ALERT = 3;
const int REQ_SUB_ALERT = 6;

// Two types of picker alert access tags.
const int REQUEST_PICKER = 4; 
const int SUBMIT_PICKER = 5;  

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)setFrame:(CGRect)rect
{
    [super setFrame:CGRectMake(0, 0, 320, 300)];
    self.center = CGPointMake(320 / 2, 280);
}


- (void)layoutSubviews
{
    if (!self.pickerView) {
        [self createPickerWithDelegate:self.delegate];
    }
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if (view.frame.size.height == 43) {
            view.frame = CGRectMake(view.frame.origin.x, 232, 127, 43);
        }
    }
}


- (void)createPickerWithDelegate:(id)delegate
{

    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    if ([self.message isEqualToString:@"Submit"]) {
        self.pickerView.tag = SUBMIT_PICKER;
    }
    else
    {
        self.pickerView.tag = REQUEST_PICKER;
    }
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.pickerView.frame = CGRectMake(75, 45, 175, 180);
    // delegate is the DZMapViewController. That's who uses our picks. 
    self.pickerView.delegate = delegate;
    self.pickerView.dataSource = delegate;
    self.pickerView.showsSelectionIndicator = true;

    [self addSubview:self.pickerView];
}

@end