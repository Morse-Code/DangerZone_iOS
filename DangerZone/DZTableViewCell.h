//
//  DZTableViewCell.h
//  DangerZone
//
//  Created by Christopher Morse on 10/17/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZObject;

@interface DZTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *bearing;
@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong) DZObject *dangerZone;

@end
