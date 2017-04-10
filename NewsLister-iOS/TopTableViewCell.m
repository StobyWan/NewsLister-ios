//
//  TopTableViewCell.m
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/10/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import "TopTableViewCell.h"
#import "TopCollectionViewCell.h"
#import "Article.h"

@implementation TopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.topArticles count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CCell";
    
    TopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    Article * article  = [self.topArticles objectAtIndex:indexPath.row];
    cell.topImage.image = article.image;
    cell.topTitle.text = article.title;
    
    return cell;
}
-(void)updateCollectionViewWithArray:(NSArray *)array{
    self.topArticles = array;
    [self.collectionView reloadData];
}

@end
