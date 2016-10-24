//
//  HHLocation.m
//  LocationMessage
//
//  Created by hong7 on 16/9/17.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import "HHLocation.h"




@implementation HHLocation


@end



static NSString * const kLocationQueryItemLatitudeKey = @"latitude";
static NSString * const kLocationQueryItemLongitudeKey = @"longitude";
static NSString * const kLocationQueryItemCityKey = @"city";
static NSString * const kLocationQueryItemAddressKey = @"address";


@implementation HHLocation(NSURLQueryItem)


-(id)initWithNSURLQueryItem:(NSArray<NSURLQueryItem *> *)items {
    if (self = [super init]) {
        
        for (NSURLQueryItem * item in items) {
            
            if ([item.name isEqualToString:kLocationQueryItemLatitudeKey]) {
                NSString * latitude = item.value;
                _corrdinate.latitude = [latitude doubleValue];
            }
            if ([item.name isEqualToString:kLocationQueryItemLongitudeKey]) {
                _corrdinate.longitude = [item.value doubleValue];
            }
        }
        
    }
    return self;
}


-(NSArray<NSURLQueryItem *> *)queryItems {
    
    NSMutableArray * items = [NSMutableArray new];
    
    
    [items addObject:[NSURLQueryItem queryItemWithName:kLocationQueryItemLatitudeKey
                                                 value:[NSString stringWithFormat:@"%f",_corrdinate.latitude]]];
    [items addObject:[NSURLQueryItem queryItemWithName:kLocationQueryItemLongitudeKey
                                                 value:[NSString stringWithFormat:@"%f",_corrdinate.longitude]]];
    
    
    return items;
}

@end


@implementation HHLocation(MSMessage)

-(id)initWithMSMessage:(MSMessage *)message {
    NSURLComponents * components = [NSURLComponents componentsWithURL:message.URL resolvingAgainstBaseURL:NO];
    if (self = [self initWithNSURLQueryItem:components.queryItems]) {
        
        
        
    }
    return self;
}

@end
