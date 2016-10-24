//
//  ECSPGeocoder.h
//  ecsp
//
//  Created by hong7 on 16/3/2.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void (^ECSPReverseGeocodeCompletionHandler)(CLPlacemark *placemark, NSError *error);

@interface ECSPGeocoder : NSObject


//当前位置信息
-(void)currentPlacemark:(ECSPReverseGeocodeCompletionHandler)handler;
@end
