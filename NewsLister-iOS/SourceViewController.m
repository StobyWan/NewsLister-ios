//
//  ViewController.m
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import "SourceViewController.h"
#import "ArticlesViewController.h"
#import "Constants.h"
#import "Article.h"
#import "Source.h"
#import "WebViewController.h"
#import "UtilityService.h"
#import "TopTableViewCell.h"
#import "TopCollectionViewCell.h"
#import "UIColor+helpers.h"
#import "UIRefreshControl+beginRefreshing.h"
#import "InfoViewController.h"
@interface SourceViewController ()
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@end

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";
static NSString *topTableCellIdentifier = @"MCell";
static NSString *simpleTableIdentifier = @"Cell";

@implementation SourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.topArticles = [[NSMutableArray alloc] init];
    self.sources = [[NSMutableArray alloc] init];
    
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadCollection)
     name:@"MTPostNotification"
     object:nil];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.refreshControl beginRefreshingProgrammatically];
    [self fetchData];
}

- (void)reloadCollection{
    [self.delegate updateCollectionViewWithArray:self.topArticles];
}

- (void)fetchData {
    
    UtilityService * utils = [UtilityService sharedInstance];
    
    [utils fetchDataWithUrl:SOURCES_URL withView:self.view andHandler:^(NSDictionary * json) {
        
        [self processSources: [json objectForKey:@"sources"] andHandler:^() {
            
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
            
            if(i < 12){
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
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MTPostNotification" object:nil userInfo:nil];
            [self.refreshControl endRefreshing];
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
       
        
        TopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topTableCellIdentifier];
        
        if (cell == nil) {
            cell = [[TopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topTableCellIdentifier];
        }
        
        cell.topArticles = self.topArticles;
        
        self.delegate = cell;
        self.collectionView = cell.collectionView;
        return cell;
        
    }else{
   
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        Source * source = [self.sources objectAtIndex:indexPath.row];
        
        cell.textLabel.text = source.name;
        cell.imageView.image = source.logo;
        cell.imageView.backgroundColor = [UIColor darkTextColor];
        
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
    sectionHeaderView.delegate = self;
    sectionHeaderView.section = section;
    
    return sectionHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void)sectionHeaderView:(BSSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section{
    
    InfoViewController *vc = (InfoViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"InfoVC"];

    [self presentViewController:vc  animated:YES completion:^{
      
    }];
}

@end
