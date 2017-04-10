//
//  UIRefreshControl+beginRefreshing.m
//  Kibo
//
//  Created by Hlung on 3/6/15.
//  MIT License
//

#import "UIRefreshControl+beginRefreshing.h"

@implementation UIRefreshControl (beginRefreshing)

- (void)beginRefreshingProgrammatically {
    [self endRefreshing];
    [self setTintColor:[UIColor whiteColor]];
    [self performSelector:@selector(do_beginRefreshingProgrammatically) withObject:nil afterDelay:0];
}

- (void)do_beginRefreshingProgrammatically {
    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
//        [self setTintColor:[UIColor whiteColor]];
//        [self beginRefreshing];
//    }];
    
    
    // beginRefreshing doesn't make the tableView reveal the refreshControl, so we have to do it manually
    UITableView *tableView = [self getParentTableViewOfView:self];
    if (tableView) {
        [tableView setContentOffset:CGPointMake(0, tableView.contentOffset.y-self.frame.size.height) animated:NO];
    }
    
    [self setTintColor:[UIColor whiteColor]];
    [self beginRefreshing];
}

// recursively find a UITableView in superviews
- (UITableView *)getParentTableViewOfView:(UIView*)view {
    if ([view.superview isKindOfClass:[UITableView class]]) {
        return (UITableView *)view.superview;
    }
    return nil;
}

@end
