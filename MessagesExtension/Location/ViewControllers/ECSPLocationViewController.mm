//
//  ECSPLocationViewController.m
//  ecsp
//
//  Created by hong7 on 16/3/28.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import "ECSPLocationViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "ECSPLocationManager.h"

@interface ECSPLocationViewController ()<BMKMapViewDelegate>

@property (nonnull,nonatomic,strong) BMKMapView * mapView;
@end

@implementation ECSPLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.address;
    
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectZero];
    [self.mapView setShowsUserLocation:YES];
    [self.view addSubview:self.mapView];
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [[ECSPLocationManager defaultManager]currentLocation:^(CLLocation *location, NSError *error) {
        if(error)
        {
            
        }
        else
        {
            
//            BMKUserLocation * location = [BMKUserLocation new];
//            location setTitle:<#(NSString *)#>
//            [self.mapView updateLocationData:<#(BMKUserLocation *)#>
//            self.currentLocation = location;
//            [self getInfoByLocation:location];
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(self.coordinate, BMKCoordinateSpanMake(0.1f,0.1f));
    BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = self.coordinate;
    annotation.title = self.address;
    
    [self.mapView  addAnnotation:annotation];
}


@end
