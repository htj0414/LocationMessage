//
//  HHLocation.h
//  LocationMessage
//
//  Created by hong7 on 16/9/17.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Messages/Messages.h>
#import <CoreLocation/CoreLocation.h>

@interface HHLocation : NSObject

@property (nonatomic,assign) CLLocationCoordinate2D corrdinate;
@property (nonatomic,strong) NSString * city;
@property (nonatomic,strong) NSString * address;

@property (nonatomic,strong) UIImage * image;
@end


@interface HHLocation (NSURLQueryItem)

-(id)initWithNSURLQueryItem:(NSArray<NSURLQueryItem *> *)items;

-(NSArray<NSURLQueryItem *> *)queryItems;
@end


@interface HHLocation (MSMessage)

-(id)initWithMSMessage:(MSMessage *)message;

@end
