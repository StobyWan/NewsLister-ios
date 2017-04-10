//
//  ArticlesViewController.h
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticlesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property NSArray * articles;
    @property (weak, nonatomic) NSString * source;
    @property NSString * url;
    - (void)setSource:(NSString *)source;
@end
