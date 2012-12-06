//
//  DZTabBarController.h
//  DangerZone
//
//  Created by Christopher Morse on 10/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class DZStoredObjects;


@interface DZTabBarController : UITabBarController <UITabBarControllerDelegate>


@property(nonatomic, strong) DZStoredObjects *dangerZones;

@end
