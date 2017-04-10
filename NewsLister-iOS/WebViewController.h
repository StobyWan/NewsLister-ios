//
//  WebViewController.h
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface WebViewController : UIViewController<WKNavigationDelegate>
    @property (strong, nonatomic) WKWebView *webView;
    @property (strong, nonatomic) NSString *newsURL;
    @property (strong, nonatomic) NSString *url;
    - (void)setUrl:(NSString *)url;
@end
