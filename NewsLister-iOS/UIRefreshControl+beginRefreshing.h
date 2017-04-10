//
//  UIRefreshControl+beginRefreshing.h
//  Kibo
//
//  Created by Hlung on 3/6/15.
//  MIT License
//

#import <UIKit/UIKit.h>

@interface UIRefreshControl (beginRefreshing)

// A beginRefreshing method that actually works!
// This fixes tintColor issue and manually tableView adjust contentOffset to make sure the refresh control is visible.
- (void)beginRefreshingProgrammatically;

@end
