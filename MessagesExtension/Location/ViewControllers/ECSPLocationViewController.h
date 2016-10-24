//
//  ECSPLocationViewController.h
//  ecsp
//
//  Created by hong7 on 16/3/28.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ECSPLocationViewController : UIViewController

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@property (nonatomic,strong) NSString * address;
@end
