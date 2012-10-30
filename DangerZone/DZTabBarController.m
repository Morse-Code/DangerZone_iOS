//
//  DZTabBarController.m
//  DangerZone
//
//  Created by Christopher Morse on 10/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DZTabBarController.h"
#import "DZStoredObjects.h"

@implementation DZTabBarController


@synthesize dangerZones = _dangerZones;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [DZStoredObjects accessDangerZoneObject:^(BOOL success, DZStoredObjects *dangerZones)
    {
        if (!success) {
            // An error occurred while instantiating our
            // history. This probably indicates a catastrophic
            // failure (e.g., the device’s hard drive is out of
            // space).

            [NSException raise:NSInternalInconsistencyException
                        format:@"An error occurred while trying to instantiate our history"];
        }
        self.dangerZones = dangerZones;
        // Create a stack and load it with the view controllers from
        // our tabs.
        NSMutableArray *stack = [NSMutableArray arrayWithArray:self.viewControllers];
        // While we still have items on our stack
        while ([stack count] > 0) {
            // pop the last item off the stack.
            id controller = [stack lastObject];
            [stack removeLastObject];
            // If it is a container object, add its controllers to
            // the stack.
            if ([controller respondsToSelector:@selector(viewControllers)]) {
                [stack addObjectsFromArray:[controller viewControllers]];
            }
            // If it responds to setWeightHistory, set the weight
            // history.
            if ([controller respondsToSelector:@selector(setDangerZones:)]) {
                [controller setDangerZones:self.dangerZones];

            }
        }
    }];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.dangerZones closeWithCompletionHandler:nil];
}


@end
