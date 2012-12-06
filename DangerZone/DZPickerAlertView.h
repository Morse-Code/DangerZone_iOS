//
//  DZRequestPickerAlertView.h
//  DangerZone
//
//  Created by rbelford on 11/25/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZPickerAlertView : UIAlertView


@property(nonatomic, retain) UIPickerView *pickerView;

- (void)createPickerWithDelegate:(id)delegate;

@end
