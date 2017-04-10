//
//  WebViewController.m
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import "WebViewController.h"
#import "MBProgressHUD.h"
@implementation WebViewController

- (void)configureView {
    if (self.article) {
        self.url = self.article.url;
    }
}

- (IBAction)shareArticle:(id)sender {
    
        NSMutableArray *sharingItems = [NSMutableArray new];
 
        if (self.article.url) {
            [sharingItems addObject: self.article.url];
        }
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
        [self presentViewController:activityController animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
    [self.webView loadRequest:request];
    self.webView.frame = CGRectMake(self.view.bounds.origin.x,self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.webView.backgroundColor = [self colorFromHexString:@"#1F2124"];
    [self.view addSubview:self.webView];
    self.title = self.article.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setArticle:(Article *)article {
    if (_article != article) {
        _article = article;
        [self configureView];
    }
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.body.innerHTML" completionHandler:^(id result, NSError *error) {
        if (result != nil) {
            [MBProgressHUD hideHUDForView:self.webView animated:YES];
        }
        if(error) {
            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
    }];
}

@end
