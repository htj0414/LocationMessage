//
//  HHLocationComposeViewController.m
//  LocationMessage
//
//  Created by hong7 on 16/9/17.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import "HHLocationComposeViewController.h"

#import "Masonry.h"

#import "HHLocationTableViewCell.h"
#import "HHLocationView.h"

#import "HHLocation.h"
#import "FAKIonIcons.h"


@interface HHLocationComposeViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) MKMapView * mapView;

@property (nonatomic,strong) UIImageView * pinView;
@property (nonatomic,strong) HHLocationView * locationView;


@property (nonatomic,strong) CLGeocoder * geocoder;
@property (nonatomic,strong) CLLocationManager * locationManager;
@property (nonatomic,assign,getter=isLocation) BOOL location;

@end

@implementation HHLocationComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mapView = [[MKMapView alloc] init];
    _mapView.showsCompass = YES;
    _mapView.showsScale = YES;
    _mapView.showsTraffic = YES;
    _mapView.showsBuildings = YES;
    _mapView.showsUserLocation = YES;
    _mapView.showsPointsOfInterest = YES;
    _mapView.delegate = self;
    
    //[_mapView addObserver:self forKeyPath:@"" options:NSKeyValueChangeSetting context:nil];
    
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self createSubmitButtons];
    

    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationManager requestWhenInUseAuthorization];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UserAction


-(void)location:(UIButton *)button {
    
    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
}

-(void)submit:(UIButton *)button {
    
    
    FAKIcon * icon = [FAKIonIcons iosLoopIconWithSize:64.0f];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [button setImage:[icon imageWithSize:CGSizeMake(64.0f, 64.0f)] forState:UIControlStateNormal];
    [button setEnabled:NO];
    
    NSTimeInterval animationDuration = 1;
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = 0;
    animation.toValue = [NSNumber numberWithFloat:M_PI*2];
    animation.duration = animationDuration;
    animation.timingFunction = linearCurve;
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    [button.layer addAnimation:animation forKey:@"rotate"];
    
    
    HHLocation * location = [[HHLocation alloc] init];
    location.corrdinate = _mapView.centerCoordinate;
    
    MKMapSnapshotOptions * options = [[MKMapSnapshotOptions alloc] init];
    [options setRegion:_mapView.region];
    
    [options setShowsBuildings:YES];
    [options setShowsPointsOfInterest:YES];
    [options setMapType:MKMapTypeStandard];
    [options setSize:CGSizeMake(500.0f, 300.0f)];
    
    
    MKMapSnapshotter * snapshot = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshot startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"生成缩略图错误!!" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
        }else {
            
            location.image = [self addPinImageByMapSnapshot:snapshot.image];
            
            if (_delegate && [_delegate respondsToSelector:@selector(composeViewController:choosedLocation:)]) {
                [_delegate composeViewController:self choosedLocation:location];
            }
            
            FAKIcon * icon = [FAKIonIcons iosArrowThinUpIconWithSize:64.0f];
            [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
            [button setImage:[icon imageWithSize:CGSizeMake(64.0f, 64.0f)] forState:UIControlStateNormal];
            [button setEnabled:YES];
            [button.layer removeAllAnimations];
            
        }
    }];
}


-(void)setRegion:(CLLocationCoordinate2D)coords animated:(BOOL)animated {
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:region animated:animated];
}

#pragma mark - Private


-(UIImage *)addPinImageByMapSnapshot:(UIImage *)image {
    FAKIcon * icon = [FAKIonIcons iosLocationIconWithSize:48.0f];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor]];
    
    UIImage *hatImage = [icon imageWithSize:CGSizeMake(48.0f, 48.0f)];
    
    
    CGSize finalSize = [image size];
    CGSize hatSize = [hatImage size];
    
    UIGraphicsBeginImageContext(finalSize);
    [image drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
    
    float x = (finalSize.width - hatSize.width)/ 2.0f - 20.0f;
    float y = (finalSize.height - hatSize.height) / 2.0f - 30.0f;
    
    [hatImage drawInRect:CGRectMake(x,y,hatSize.width,hatSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)createPinView {
    
    FAKIcon * icon = [FAKIonIcons iosLocationIconWithSize:48.0f];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor]];
    
    
    _pinView  = [[UIImageView alloc] initWithImage:[icon imageWithSize:CGSizeMake(48.0f, 48.0f)]];
    [self.view addSubview:_pinView];
    [_pinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mapView);
        make.bottom.equalTo(_mapView.mas_centerY).offset(5.0f);
    }];
}


-(void)createSubmitButtons {
    
    FAKIcon * icon = [FAKIonIcons iosArrowThinUpIconWithSize:64.0f];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    UIButton * submitButton = [UIButton new];
    [self.view addSubview:submitButton];
    [self.view bringSubviewToFront:submitButton];
    [submitButton setImage:[icon imageWithSize:CGSizeMake(64, 64)] forState:UIControlStateNormal];
    [submitButton setBackgroundColor:[UIColor orangeColor]];
    [submitButton.layer setCornerRadius:32.0f];
    [submitButton.layer setMasksToBounds:YES];
    [submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@64.0f);
        make.bottom.equalTo(self.view).offset(-100.0f);
    }];
    
}

-(void)createLocationButton {
    
    FAKIcon * outlineIcon = [FAKIonIcons iosNavigateOutlineIconWithSize:44.0f];
    [outlineIcon addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor]];
    
    UIButton * button = [UIButton new];
    [button setImage:[outlineIcon imageWithSize:CGSizeMake(44.0f, 44.0f)] forState:UIControlStateNormal];
    [button.layer setCornerRadius:22.0f];
    [button.layer setMasksToBounds:YES];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_mapView).offset(-15.0f);
        make.top.equalTo(_mapView).offset(95.0f);
    }];

}

-(void)createLocationView {
    
    _locationView = [[HHLocationView alloc] init];
    [self.view addSubview:_locationView];
    [_locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@150.0f);
    }];
}

-(void)updateLocationViewByCLPlacemark:(CLPlacemark *)placemark {
    
    if (_locationView == nil) {
        [self createLocationView];
    }
    
    [_locationView configViewByPlacemark:placemark];
    
}

-(void)reverseLocation:(CLLocation *)location {
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    if ([_geocoder isGeocoding]) {
        [_geocoder cancelGeocode];
    }
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil) {
            if (placemarks.count > 0) {
                CLPlacemark * placemark = placemarks[0];
                [self updateLocationViewByCLPlacemark:placemark];
            }
        }else {
            [self updateLocationViewByCLPlacemark:nil];
        }
    }];
}

#pragma mark - MKMapView Delegate

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    if (_pinView == nil) {
        [self createPinView];
    }
    
    CGRect originalFrame = _pinView.frame;
    
    [UIView animateKeyframesWithDuration:0.6f delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.25f animations:^{
            CGRect rect = CGRectOffset(originalFrame, 0.0f, -25.0f);
            _pinView.frame = rect;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.3f relativeDuration:0.25f animations:^{
            _pinView.frame = originalFrame;
        }];
    } completion:^(BOOL finished) {
        NSLog(@"%f,%f",_mapView.userLocation.coordinate.latitude,_mapView.userLocation.coordinate.longitude);
        if (_mapView.userLocation.coordinate.latitude != _mapView.centerCoordinate.latitude && _mapView.userLocation.coordinate.longitude != _mapView.centerCoordinate.longitude) {
            
            NSLog(@"asdf");
        }
    }];
    
    //先不根据位置信息去取地址列表,后面再做升级
    //CLLocation * location = [[CLLocation alloc] initWithCoordinate:_mapView.centerCoordinate altitude:5000.0f horizontalAccuracy:kCLLocationAccuracyKilometer verticalAccuracy:kCLLocationAccuracyKilometer timestamp:[NSDate new]];
    
    //[self reverseLocation:location];
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    if (self.isLocation) {
        [_mapView setCenterCoordinate:userLocation.coordinate animated:NO];
    }
    
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    [self setRegion:_mapView.centerCoordinate animated:NO];
    
    _location = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _location = NO;
    });
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self createLocationButton];
    }
}


@end
