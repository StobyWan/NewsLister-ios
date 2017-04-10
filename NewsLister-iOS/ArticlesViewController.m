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
#import "MBProgressHUD.h"

@implementation ArticlesViewController

- (void)configureView {
    if (self.source) {
        self.url = [NSString stringWithFormat:@"%@?source=%@&apiKey=%@",ARTICLES_URL,self.source,API_KEY];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self configureView];
    [self fetchData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)fetchData{
    
    UtilityService * utils = [UtilityService sharedInstance];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [utils fetchDataWithUrl:self.url withView:self.view andHandler:^(NSDictionary * json) {
        self.articles = [json objectForKey:@"articles"];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    NSDictionary * dict = [self.articles objectAtIndex:indexPath.row];
    
    Article * article = [[Article alloc] initWithDictionary:dict];
    
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

- (void)setSource:(NSString *)sourceText {
    if (_source != sourceText) {
        _source = sourceText;
        [self configureView];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWebView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WebViewController *destViewController = segue.destinationViewController;
        NSDictionary * dict = [self.articles objectAtIndex:indexPath.row];
        NSString * url = dict[@"url"];
        [destViewController setUrl:url];
    }
}


@end
