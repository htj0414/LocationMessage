//
//  ECSPGeocoder.m
//  ecsp
//
//  Created by hong7 on 16/3/2.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import "ECSPGeocoder.h"

@interface ECSPGeocoder()<CLLocationManagerDelegate>

@property(nonatomic,retain)CLLocationManager *locationManager;

@end

@implementation ECSPGeocoder {
    
    ECSPReverseGeocodeCompletionHandler _locationCompletionHandler;
}

-(instancetype)init {
    if (self = [super init]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
    }
    return self;
}

-(void)authorization{
    //8.0以上的机器需要主动要求用户同意定位
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

-(void)startLocation {
    if([CLLocationManager locationServicesEnabled] &&
       ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
           [self.locationManager startUpdatingLocation];
       }else {
           
       }
}

-(void)placemarkByLocation:(CLLocation *)location {

    //106.527844,29.5715   重庆市
    //113.600308,24.818667  韶关市
    //CLLocation * loc = [[CLLocation alloc] initWithLatitude:29.5715 longitude:106.527844];
    // 获取当前所在的城市名
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];

            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            [self finishedWith:placemark];
        }else if (error == nil && [array count] == 0){
            [self failedWithError:[[NSError alloc] initWithDomain:@"" code:0 userInfo:@{}]];
        }else if (error != nil){
            [self failedWithError:error];
        }
    }];
}

//当前位置信息
-(void)currentPlacemark:(ECSPReverseGeocodeCompletionHandler)handler {
    _locationCompletionHandler = handler;
    [self authorization];
}

-(void)finishedWith:(CLPlacemark *)placemark {
    if (_locationCompletionHandler) {
        _locationCompletionHandler(placemark,nil);
        _locationCompletionHandler = nil;
    }
}

-(void)failedWithError:(NSError *)error {
    if (_locationCompletionHandler) {
        _locationCompletionHandler(nil,error);
        _locationCompletionHandler = nil;
    }
}


#pragma mark - CoreLocation Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status  {
    if (status == kCLAuthorizationStatusNotDetermined) {
        return;
    }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        
        [self startLocation];
    }else {
        [self failedWithError:[[NSError alloc] initWithDomain:@"" code:0 userInfo:@{@"ddd":@"asd"}]];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    [self placemarkByLocation:currentLocation];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self failedWithError:error];
}
@end
