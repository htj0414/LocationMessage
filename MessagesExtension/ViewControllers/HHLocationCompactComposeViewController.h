//
//  HHLocationCompactComposeViewController.h
//  LocationMessage
//
//  Created by hong7 on 16/9/17.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HHLocation;
@class HHLocationCompactComposeViewController;

@protocol  HHLocationCompactComposeViewControllerDelegate<NSObject>

-(void)compactComposeViewControllerChoosedShareCurrentLocation:(HHLocationCompactComposeViewController *)viewController;

-(void)compactComposeViewController:(HHLocationCompactComposeViewController *)viewController choosedLocation:(HHLocation *)location;

@end

@interface HHLocationCompactComposeViewController : UIViewController

@property (nonatomic,strong) id<HHLocationCompactComposeViewControllerDelegate> delegate;
@end
