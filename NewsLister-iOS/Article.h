//
//  Article.h
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Article : NSObject

    @property NSString * author;
    @property NSString * title;
    @property NSString * descript;
    @property NSString * url;
    @property NSString * urlToImage;
    @property NSString * publishedAt;
    @property UIImage * image;
    - (id)initWithDictionary:(NSDictionary*)dict;

@end
