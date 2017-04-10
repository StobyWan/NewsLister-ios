//
//  UtilityService.m
//  NewsLister-iOS
//
//  Created by Bryan B. Stober on 4/9/17.
//  Copyright © 2017 Bryan Stober Design. All rights reserved.
//

#import "UtilityService.h"
#import "MBProgressHUD.h"
#import "Source.h"
#import "Article.h"
#import "Constants.h"
@implementation UtilityService

+ (instancetype)sharedInstance {
    static UtilityService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UtilityService alloc] init];
    });
    return sharedInstance;
}

- (void)fetchDataWithUrl:(NSString*)urlString withView:(UIView*)view andHandler:(void (^)(NSDictionary * json))callback{
    
    NSURL *url = [NSURL URLWithString:urlString];

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                              dataTaskWithURL:url
                                              completionHandler:^(NSData *data,
                                                                  NSURLResponse *response,
                                                                  NSError *error) {
                                                  if(data){
                                                      NSDictionary* _json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                            options:kNilOptions
                                                                                                              error:&error];
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          if([_json[@"status"]  isEqual: @"ok"]){
                                                                callback(_json);
                                                          }else{
                                                              //handle error
                                                              NSLog(@"ERROR: %@",_json[@"status"] );
                                                          }
                                                      });
                                                  }
                                              }];
        [downloadTask resume];
    });
}

- (UIImage*)getImageFromURL:(NSString*)URL forSize:(int)size{
    UIImage * img;
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:URL]];
    img = [UIImage imageWithData: imageData];
    CGSize itemSize = CGSizeMake(size, size);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [img drawInRect:imageRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
