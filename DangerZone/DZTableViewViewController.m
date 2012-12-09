//
//  DZTableViewViewController.m
//  DangerZone
//
//  Created by Christopher Morse on 10/17/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import "DZTableViewViewController.h"
#import "DZObject.h"
#import "DZTableViewCell.h"
#import "DZStoredObjects.h"

@interface DZTableViewViewController ()


@end

@implementation DZTableViewViewController
{
@private
    __strong UIActivityIndicatorView *_activityIndicatorView;
}


@synthesize dangerZones = _dangerZones;
@synthesize attributes = _attributes;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)reload:(id)sender
{
    [_activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self reloadTableData];
    [_activityIndicatorView stopAnimating];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}


- (void)loadView
{
    [super loadView];

    _activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString([NSString stringWithFormat:@"Danger Table"], nil);

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicatorView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                    target:self
                                                                                    action:@selector(reload:)];
    self.attributes = [[NSMutableDictionary alloc] initWithCapacity:5];


    [self reload:nil];
}


- (void)setDangerZones:(DZStoredObjects *)dangerZones
{
    if ([_dangerZones isEqual:dangerZones]) {
        return;
    }
    if (_dangerZones != nil) {
        [_dangerZones removeObserver:self forKeyPath:KVOZonesChangeKey];
    }
    _dangerZones = dangerZones;
    if (_dangerZones != nil) {
        [self.dangerZones addObserver:self forKeyPath:KVOZonesChangeKey options:NSKeyValueObservingOptionNew
                              context:nil];
    }
    if (self.isViewLoaded) {
        [self reloadTableData];
    }
}


- (void)viewDidUnload
{
    [self.dangerZones removeObserver:self forKeyPath:KVOZonesChangeKey];
    self.attributes = nil;
//    [super viewDidUnload];
}


- (void)reloadTableData
{
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dangerZones.zones count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DangerZone";
    DZTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    cell.dangerZone = [self.dangerZones.zones objectAtIndex:(NSUInteger)indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - Notification Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{

    if ([keyPath isEqualToString:KVOZonesChangeKey]) {
        [self zonesChange:change];
    }
}


- (void)zonesChange:(__unused NSDictionary *)dictionary
{
    NSLog(@"Received KVO notification");
    [self reloadTableData];
}

@end
