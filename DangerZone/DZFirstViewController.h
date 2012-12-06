//
//  DZFirstViewController.h
//  DangerZone
//
//  Created by Christopher Morse on 10/3/12.
//  Copyright (c) 2012 iCompute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZFirstViewController : UIViewController


@property(strong, nonatomic) IBOutlet UITextView *textView;
@property(strong, nonatomic) IBOutlet UIWebView *webView;

@property(strong, nonatomic) NSMutableString *html;

- (void)displayText:(NSString *)text;

- (void)displayPage:(NSString *)text;

@end
