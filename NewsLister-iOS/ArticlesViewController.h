//
//  ArticlesViewController.h
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"
@interface ArticlesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property NSMutableArray * articles;
//    @property (weak, nonatomic) NSString * source;
    @property (strong,nonatomic) Source * source;
    @property NSString * url;
    - (void)setSource:(Source *)source;
@end
