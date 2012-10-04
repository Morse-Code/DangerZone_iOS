//
//  DZFirstViewController.m
//  DangerZone
//
//  Created by Christopher Morse on 10/3/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import "DZFirstViewController.h"

@interface DZFirstViewController ()

@end

@implementation DZFirstViewController
@synthesize textView;
@synthesize html;
@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sendGet];
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
    
    NSString *urlAsString = @"http://m.google.com/search?";

    urlAsString = [urlAsString stringByAppendingString:@"?q=UVM"];
    urlAsString = [urlAsString stringByAppendingString:@"&output=xml"];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response,
                                                                                        NSData *data, NSError *error)
     
    {
        NSString *object;
        if ([data length] >0 && error == nil){
            object = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HTML = %@", html);
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (error != nil){
            NSLog(@"Error happened = %@", error);
        }
        
        [self performSelectorOnMainThread:@selector(displayText:) withObject:object waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(displayPage:) withObject:object waitUntilDone:NO];
    }];
}

- (void)displayText:(NSString *)text {
    self.textView.text = text;
}

- (void)displayPage:(NSString *)text{
    [webView loadHTMLString:text baseURL:[NSURL URLWithString:@"http://maps.google.com/"]];
}

@end
