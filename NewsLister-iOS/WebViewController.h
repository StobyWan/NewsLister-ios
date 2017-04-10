//
//  WebViewController.h
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Article.h"
@interface WebViewController : UIViewController<WKNavigationDelegate>

    @property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;
    @property (strong, nonatomic) WKWebView *webView;
    @property (strong, nonatomic) Article *article;
    @property (strong, nonatomic) NSString *url;
    - (void)setArticle:(Article *)article;
@end
