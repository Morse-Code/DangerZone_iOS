//
//  DZTableViewViewController.h
//  DangerZone
//
//  Created by Christopher Morse on 10/17/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZStoredObjects;

@interface DZTableViewViewController : UITableViewController

@property (nonatomic, strong) DZStoredObjects *dangerZones;

- (void)reloadTableData;


@end
