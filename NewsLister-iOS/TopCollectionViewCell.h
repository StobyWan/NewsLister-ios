//
//  TopCollectionViewCell.h
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourceViewController.h"

@interface TopCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *topTitle;

@end
