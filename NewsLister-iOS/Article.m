//
//  Article.m
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import "Article.h"
#import "UtilityService.h"

@implementation Article

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
        UtilityService * util = [[UtilityService alloc] init];
//        NSLog(@"Article: %@",dict);
        if(dict[@"author"] != (id)[NSNull null]){
            _author = dict[@"author"];
        }else{
            _author = @"Unknown";
        }
        if(dict[@"title"] != (id)[NSNull null]){
            _title = dict[@"title"];
        }else{
            _title = @"";
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
        
        if(dict[@"urlToImage"] != (id)[NSNull null]){
            _urlToImage = dict[@"urlToImage"];
            _image = [util getImageFromURL:_urlToImage forSize:40];
        
        }else{
            _image = [UIImage imageNamed:@"news-placeholder"];
            _urlToImage = @"";
        }
        
        if(dict[@"publishedAt"] != (id)[NSNull null]){
            _publishedAt = dict[@"publishedAt"];
        }else{
            _publishedAt = @"";
        }
    }
    
    return self;
}

@end
