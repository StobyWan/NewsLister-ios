//
//  ViewController.m
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import "SourceViewController.h"
#import "Constants.h"
#import "ArticlesViewController.h"
#import "TopCollectionViewCell.h"
#import "Article.h"
#import "Source.h"
#import "WebViewController.h"
#import "MBProgressHUD.h"
#import "UtilityService.h"
#import "TopTableViewCell.h"
#import "UIColor+helpers.h"
#import "SectionHeaderView.h"

@interface SourceViewController ()
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@end

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@implementation SourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.topArticles = [[NSMutableArray alloc] init];
    self.sources = [[NSMutableArray alloc] init];
    [self fetchData];
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadCollection)
     name:@"MTPostNotification"
     object:nil];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
}

- (void)reloadCollection{
    
    [self.delegate updateCollectionViewWithArray:self.topArticles];
}

- (void)fetchData {
    
    UtilityService * utils = [UtilityService sharedInstance];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [utils fetchDataWithUrl:SOURCES_URL withView:self.view andHandler:^(NSDictionary * json) {
        
        [self processSources: [json objectForKey:@"sources"] andHandler:^() {
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }];
    }];
}

- (void)processSources:(NSArray *)sources andHandler:(void (^)())callback{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        int i = 0;
        
        for (id object in sources) {
            
            Source * source = [[Source alloc] initWithDictionary:object];
            [self.sources addObject:source];
            
            if(i < 15){
                
                if ([source.sortBysAvailable containsObject:@"top"]) {
                    
                    NSString * u = [NSString stringWithFormat:@"%@?source=%@&apiKey=%@",ARTICLES_URL,source.sourceId,API_KEY];
                    
                    UtilityService * utils = [UtilityService sharedInstance];
                    [utils fetchDataWithUrl:u withView:self.view andHandler:^(NSDictionary * json) {
                        NSArray * tops = [json objectForKey:@"articles"];
                        
                        Article * article = [[Article alloc] initWithDictionary:tops[0]];
                        [self.topArticles addObject:article];
                        
                    }];
                }
            }
            
            i++;
            
            if(i > 15){
              
            }
        }
        

        dispatch_sync(dispatch_get_main_queue(), ^{
              [[NSNotificationCenter defaultCenter] postNotificationName:@"MTPostNotification" object:nil userInfo:nil];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
                callback();
        });
    });
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.articles = nil;
    self.collectionView = nil;
    self.sources = nil;
    self.delegate = nil;
    self.tableView = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showArticlesDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ArticlesViewController *destViewController = segue.destinationViewController;
        Source* source = [self.sources objectAtIndex:indexPath.row];
        [destViewController setSource:source];
    }
    
    if ([segue.identifier isEqualToString:@"showWebView"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:(UICollectionViewCell*)sender];
        WebViewController *destWebViewController = segue.destinationViewController;
        Article * article = [self.topArticles objectAtIndex:indexPath.item];
        [destWebViewController setArticle:article];
    }
}

#pragma mark - UITableView DataSource Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
      return [self.sources count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 230;
    }else{
        return 40;
    }
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        static NSString *simpleTableIdentifier = @"MCell";
        
        TopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[TopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.topArticles = self.topArticles;
        self.delegate = cell;
        self.collectionView = cell.collectionView;
        return cell;

    }else{
        static NSString *simpleTableIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        Source * dict = [self.sources objectAtIndex:indexPath.row];
        
        cell.textLabel.text = dict.name;
        cell.imageView.image = dict.logo;
        
        return cell;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BSSectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    sectionHeaderView.frame = CGRectMake(0, 0, 320, 48);
    if(section == 0){
         sectionHeaderView.titleLabel.text = @"Top Stories";
    }else{
         sectionHeaderView.titleLabel.text = @"News Sources";
    }
    
  
    sectionHeaderView.section = section;
//    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
       return @"Top Stories";
    }else{
        return @"News Sources";
    }
}

@end
