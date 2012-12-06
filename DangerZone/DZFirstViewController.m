//
//  DZFirstViewController.m
//  DangerZone
//
//  Created by Christopher Morse on 10/3/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import "DZFirstViewController.h"
#import "AFJSONRequestOperation.h"


@interface DZFirstViewController ()


@end

@implementation DZFirstViewController
{
@private

    __strong UIActivityIndicatorView *_activityIndicatorView;
}


@synthesize textView;
@synthesize html;
@synthesize webView;


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

    //[self sendGet];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* URL = http://pixolity.com/get.php?param1=First&param2=Second */

- (void)sendGet
{

    NSString *urlAsString = @"http://10.245.15.67/api/request";

    urlAsString = [urlAsString stringByAppendingString:@"?latitude=1.000"];
    urlAsString = [urlAsString stringByAppendingString:@"&longitude=2.000"];
    urlAsString = [urlAsString stringByAppendingString:@"&category=new"];
    urlAsString = [urlAsString stringByAppendingString:@"&radius=5"];

    NSURL *url = [NSURL URLWithString:urlAsString];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];


    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(
            NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        NSLog(@"Public Timeline: %@", JSON);
    }                                                                                   failure:nil];
    [operation start];


    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                           {
                               NSString *output;
                               if ([data length] > 0 && error == nil) {

                                   NSString *jsonString = [[NSString alloc]
                                                                     initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"Successfully downloaded JSON from server.");
                                   NSLog(@"JSON String = %@\n", jsonString);

                                   NSError *jsonParsingError = nil;

                                   NSDictionary *deserializedJson = [NSJSONSerialization JSONObjectWithData:data
                                                                                                    options:NSJSONReadingAllowFragments
                                                                                                      error:&jsonParsingError];

                                   output = [NSString stringWithFormat:@"Dictionary: \n%@\n%@", deserializedJson,
                                                                       jsonString];

                                   NSLog(@"Dictionary String = %@\n", deserializedJson);
                               }
                               else if ([data length] == 0 && error == nil) {
                                   NSLog(@"Nothing was downloaded.");
                               }
                               else if (error != nil) {
                                   output = [NSString stringWithFormat:@"HTTP response status: %@\n", error];
                               }

                               [self performSelectorOnMainThread:@selector(displayText:) withObject:output
                                                   waitUntilDone:NO];
                               [self performSelectorOnMainThread:@selector(displayPage:) withObject:output
                                                   waitUntilDone:NO];

                           }];
}


- (void)displayText:(NSString *)text
{
    self.textView.text = text;
}


- (void)displayPage:(NSString *)text
{
    [webView loadHTMLString:text baseURL:[NSURL URLWithString:@"http://10.245.15.67/"]];
}

@end
