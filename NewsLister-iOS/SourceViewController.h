//
//  ViewController.h
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"

@protocol SourceViewControllerDelegate <NSObject>

-(void)updateCollectionViewWithArray:(NSArray*)array;

@end

@interface SourceViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SectionHeaderViewDelegate>

    @property NSArray * articles;
    @property NSMutableArray * sources;
    @property NSMutableArray * topArticles;
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property (weak, nonatomic) id<SourceViewControllerDelegate> delegate;
    @property (weak, nonatomic) UICollectionView * collectionView;
@end

