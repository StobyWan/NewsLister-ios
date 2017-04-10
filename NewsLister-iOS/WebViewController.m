//
//  WebViewController.m
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import "WebViewController.h"
#import "MBProgressHUD.h"
#import "UIColor+helpers.h"

@implementation WebViewController

- (void)configureView {
    if (self.article) {
        self.url = self.article.url;
    }
}

- (IBAction)shareArticle:(id)sender {
    
    NSMutableArray *sharingItems = [[NSMutableArray alloc] init];
    NSURL *urlToShare = [NSURL URLWithString:self.article.url];
    
    if (urlToShare) {
        [sharingItems addObject: urlToShare];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:sharingItems applicationActivities:nil];
        activityViewController.excludedActivityTypes = @[
                                                         UIActivityTypePrint,
                                                         UIActivityTypeAssignToContact,
                                                         UIActivityTypeSaveToCameraRoll,
                                                         UIActivityTypeAirDrop];
        
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.title = self.article.title;
//    [self.shareButton setEnabled:NO];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.webView.navigationDelegate = self;
//    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
    [self.webView loadRequest:request];
    self.webView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.webView.backgroundColor = [UIColor colorFromHexString:@"#1F2124"];
    [self.view addSubview:self.webView];

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

//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
//    [webView evaluateJavaScript:@"document.body.innerHTML" completionHandler:^(id result, NSError *error) {
//        if (result != nil) {
////            [self.shareButton setEnabled:YES];
////            [MBProgressHUD hideHUDForView:self.webView animated:YES];
//        }
//        if(error) {
//            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
//        }
//    }];
//}

@end
