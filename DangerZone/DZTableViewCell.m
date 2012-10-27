//
//  DZTableViewCell.m
//  DangerZone
//
//  Created by Christopher Morse on 10/17/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import "DZTableViewCell.h"
#import "DZObject.h"

@implementation DZTableViewCell
{
@private
    __strong DZObject *_dangerZone;
}


@synthesize dangerZone = _dangerZone;


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setDangerZone:(DZObject *)dangerZone
{
    _dangerZone = dangerZone;


    self.name.text = [DZObject stringFromCategory:_dangerZone.category];
//    self.name.text = [NSString stringWithFormat:@"%d",dangerZone.category];
    self.distance.text = [NSString stringWithFormat:@"%d", dangerZone.range];
    self.bearing.text = [NSString stringWithFormat:@"%d", dangerZone.severity];

}


- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
