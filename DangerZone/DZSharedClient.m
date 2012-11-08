//
// Created by morsecp on 10/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DZSharedClient.h"
#import "AFJSONRequestOperation.h"

static NSString *const kDZDangerZoneAPIBaseURLString = @"http://www.cems.uvm.edu/~01cmorse/dz/dangerzone.php";
//static NSString * const kDZDangerZoneAPIBaseURLString = @"http://dangerzone.cems.uvm.edu/api/";

@implementation DZSharedClient
{

}


+ (DZSharedClient *)sharedClient
{
    static DZSharedClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
{
    _sharedClient = [[DZSharedClient alloc] initWithBaseURL:[NSURL URLWithString:kDZDangerZoneAPIBaseURLString]];
});

    return _sharedClient;
}


- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }

    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    [self setDefaultHeader:@"Accept" value:@"application/json"];

    return self;
}

@end