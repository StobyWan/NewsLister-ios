//
//  CustomArticleCell.h
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomArticleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *decsriptionlabel;
@property (weak, nonatomic) IBOutlet UIImageView *customImage;


@end
