//
//  HHLocationComposeViewController.h
//  LocationMessage
//
//  Created by hong7 on 16/9/17.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class HHLocation;
@class HHLocationComposeViewController;

@protocol HHLocationComposeViewControllerDelegate <NSObject>

-(void)composeViewController:(HHLocationComposeViewController *)viewController choosedLocation:(HHLocation *)location;

@end

@interface HHLocationComposeViewController : UIViewController


@property (nonatomic,strong) id<HHLocationComposeViewControllerDelegate>delegate;

@end
