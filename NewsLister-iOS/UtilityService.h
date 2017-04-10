//
//  UtilityService.h
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilityService : NSObject

+ (UtilityService *)sharedInstance;

- (UIImage*)getImageFromURL:(NSString*)URL forSize:(int)size;

- (void)fetchDataWithUrl:(NSString*)urlString withView:(UIView*)view andHandler:(void (^)(NSDictionary * json))callback;

- (UIColor *)colorFromHexString:(NSString *)hexString;
@end
