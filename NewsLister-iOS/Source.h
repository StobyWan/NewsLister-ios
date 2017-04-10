//
//  Source.h
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Source : NSObject

    @property NSString * sourceId;
    @property NSString * name;
    @property NSString * descript;
    @property NSString * url;
    @property NSString * category;
    @property NSString * language;
    @property NSArray * sortBysAvailable;
    @property UIImage * logo;
    @property NSDictionary * urlsToLogos;

    - (id)initWithDictionary:(NSDictionary*)dict;

@end
