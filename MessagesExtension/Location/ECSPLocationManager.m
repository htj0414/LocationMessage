//
//  ECSPLocationManager.m
//  ecsp
//
//  Created by hong7 on 16/3/1.
//  Copyright © 2016年 hong7. All rights reserved.
//


#import "ECSPLocationManager.h"

@interface ECSPLocationManager()<CLLocationManagerDelegate>

@property(nonatomic,retain)CLLocationManager *locationManager;

@end

@implementation ECSPLocationManager {
    
    ECSPLocationCompletionHandler _locationCompletionHandler;
}


+(ECSPLocationManager *)defaultManager {
    static ECSPLocationManager * manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(instancetype)init {
    if (self = [super init]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
    }
    return self;
}


-(void)authorization:(ECSPLocationAuthorizationCompletionHandler)handler {
    //8.0以上的机器需要主动要求用户同意定位
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

-(void)currentLocation:(ECSPLocationCompletionHandler)handler {
    
    //如果用户没有同意定位提示用户在设置中改变设置
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        NSLog(@"%@",@"定位没有同意");
    }
    
    _locationCompletionHandler = handler;
    if([CLLocationManager locationServicesEnabled] &&
       ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)startLocation{
    
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    // 开始定位
    [self.locationManager startUpdatingLocation];
    
}


#pragma mark - CoreLocation Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status  {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        
        [manager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];

    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    
    if (_locationCompletionHandler) {
        _locationCompletionHandler(currentLocation,nil);
        _locationCompletionHandler = nil;
    }
    
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        
    }
    
    if (_locationCompletionHandler) {
        _locationCompletionHandler(nil,error);
        _locationCompletionHandler = nil;
    }
}
@end
