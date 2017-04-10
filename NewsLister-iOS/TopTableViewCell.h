//
//  TopTableViewCell.h
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/10/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourceViewController.h"

@interface TopTableViewCell : UITableViewCell <SourceViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray * topArticles;

@end
