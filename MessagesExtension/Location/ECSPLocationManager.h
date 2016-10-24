//
//  ECSPLocationManager.h
//  ecsp
//
//  Created by hong7 on 16/3/1.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void (^ECSPLocationReverseGeocodeCompletionHandler)(CLPlacemark *placemark, NSError *error);
typedef void (^ECSPLocationAuthorizationCompletionHandler)(CLAuthorizationStatus status,NSError * error);
typedef void (^ECSPLocationCompletionHandler)(CLLocation * location,NSError * error);

@interface ECSPLocationManager : NSObject


+(ECSPLocationManager *)defaultManager;

//验证是否允许定位
-(void)authorization:(ECSPLocationAuthorizationCompletionHandler)handler;

//获取当前的GPS坐标
-(void)currentLocation:(ECSPLocationCompletionHandler)handler;

//当前位置信息
-(void)currentPlacemark:(ECSPLocationAuthorizationCompletionHandler)handler;

//根据坐标获取位置
-(void)placemarkByLocation:(CLLocation *)location handler:(ECSPLocationAuthorizationCompletionHandler)handler;
@end
