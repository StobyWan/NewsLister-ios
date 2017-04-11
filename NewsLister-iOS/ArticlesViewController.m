//
//  ArticlesViewController.m
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import "ArticlesViewController.h"
#import "Constants.h"
#import "Article.h"
#import "CustomArticleCell.h"
#import "WebViewController.h"
#import "UtilityService.h"
#import "UIRefreshControl+beginRefreshing.h"

@implementation ArticlesViewController

- (void)configureView {
    if (self.source) {
        self.url = [NSString stringWithFormat:@"%@?source=%@&apiKey=%@",ARTICLES_URL,self.source.sourceId,API_KEY];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self configureView];
    self.title = self.source.name;
    self.articles = [[NSMutableArray alloc] init];
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.refreshControl beginRefreshingProgrammatically];
    [self fetchData];
}

- (void)fetchData{
    
    UtilityService * utils = [UtilityService sharedInstance];
    
    [utils fetchDataWithUrl:self.url withView:self.view andHandler:^(NSDictionary * json) {
        NSArray * articles = [json objectForKey:@"articles"];
        
        for (id object in articles){
            Article * article = [[Article alloc] initWithDictionary:object];
            [self.articles addObject:article];
        }
        
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.articles = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cell";
    
    CustomArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[CustomArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Article * article = [self.articles objectAtIndex:indexPath.row];
    
    cell.headerLabel.text = article.title;
    cell.subheaderLabel.text = article.author;
    cell.decsriptionlabel.text = article.descript;
    cell.customImage.image = [UIImage imageNamed:@"news-placeholder"];
    if(article.image){
        cell.customImage.image = article.image;
    }
    
    return cell;
}

#pragma mark - Managing the detail item

- (void)setSource:(Source *)source {
    if (_source != source) {
        _source = source;
        [self configureView];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWebView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WebViewController *destViewController = segue.destinationViewController;
        Article * article = [self.articles objectAtIndex:indexPath.row];
        
        [destViewController setArticle:article];
    }
}


@end
