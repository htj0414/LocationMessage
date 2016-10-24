//
//  HHLocationView.h
//  LocationMessage
//
//  Created by hong7 on 16/9/18.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLPlacemark;

@interface HHLocationView : UIView



-(void)configViewByPlacemark:(CLPlacemark *)placemark;
@end
