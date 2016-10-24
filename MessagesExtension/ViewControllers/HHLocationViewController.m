//
//  HHLocationViewController.m
//  LocationMessage
//
//  Created by hong7 on 16/9/17.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import "HHLocationViewController.h"

#import "Masonry.h"
#import "FAKIonIcons.h"

@interface HHCustomAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (id)initWithLocation:(CLLocationCoordinate2D)coord;

// Other methods and properties.
@end


@implementation HHCustomAnnotation
@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}
@end


@interface HHLocationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) MKMapView * mapView;
@property (nonatomic,strong) CLLocationManager * locationManager;
@end

@implementation HHLocationViewController

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
    
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
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
    
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    
    [self setRegion:self.coordinate animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

#pragma mark - User Action

-(void)nav:(UIButton *)button {
    
    UIResponder *responder = self;
    while(responder){
        if ([responder respondsToSelector: @selector(openURL:options:completionHandler:)]){
            [responder performSelector: @selector(openURL:options:completionHandler:) withObject: [NSURL URLWithString:@"www.163.com" ] withObject:nil];
        }
        responder = [responder nextResponder];
    }

}

-(void)location:(UIButton *)button {
    
    [self setRegion:_mapView.userLocation.coordinate animated:YES];
}


-(void)setRegion:(CLLocationCoordinate2D)coords animated:(BOOL)animated {
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:region animated:animated];
}


- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
    HHCustomAnnotation * ann = [[HHCustomAnnotation alloc] initWithLocation:self.coordinate];
    [_mapView addAnnotation:ann];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[HHCustomAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView* pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotation"];
            
            
            FAKIcon * icon = [FAKIonIcons iosLocationIconWithSize:48.0f];
            [icon addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor]];
            

            pinView.canShowCallout = NO;
            pinView.image = [icon imageWithSize:CGSizeMake(48.0f, 48.0f)];
            pinView.centerOffset = CGPointMake(0.0f, -15.0f);
            
        }
        
        pinView.annotation = annotation;
        
        return pinView;     
    }
    return nil;
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
    }
}


@end
