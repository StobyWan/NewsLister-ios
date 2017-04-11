//
//  Source.m
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import "Source.h"
#import "UtilityService.h"
@implementation Source

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        NSLog(@"Article: %@",dict);

        if(dict[@"id"] != (id)[NSNull null]){
            _sourceId = dict[@"id"];
        }else{
            _sourceId = @"";
        }
        if(dict[@"name"] != (id)[NSNull null]){
            _name = dict[@"name"];
        }else{
            _name = @"";
        }
        
        if(dict[@"description"] != (id)[NSNull null]){
            _descript = dict[@"description"];
        }else{
            _descript = @"";
        }
        
        if(dict[@"url"] != (id)[NSNull null]){
            _url = dict[@"url"];
        }else{
            _url = @"";
        }
        
        if(dict[@"category"] != (id)[NSNull null]){
            _category = dict[@"category"];
        }else{
            _category = @"";
        }
        
        if(dict[@"language"] != (id)[NSNull null]){
            _language = dict[@"language"];
        }else{
            _language = @"";
        }
        
        if(dict[@"urlsToLogos"] != (id)[NSNull null]){
//            UtilityService * utils = [UtilityService sharedInstance];
            _urlsToLogos = dict[@"urlsToLogos"];
//            newsapi.org removed logos for unknow reason
//            _logo = [utils getImageFromURL:_urlsToLogos[@"small"] forSize:40];
        }else{
             _logo = [UIImage imageNamed:@"news-placeholder"];
        }
        
        if(dict[@"sortBysAvailable"] != (id)[NSNull null]){
            _sortBysAvailable = dict[@"sortBysAvailable"];
        }else{
            _sortBysAvailable = @[];
        }
        
    }
    
    return self;
}

@end
