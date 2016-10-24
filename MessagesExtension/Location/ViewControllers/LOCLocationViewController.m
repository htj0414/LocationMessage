//
//  IMLoctionViewController.m
//  ECSPFriendsChat
//
//  Created by 小房子 on 16/8/31.
//  Copyright © 2016年 小房子. All rights reserved.
//

#import "LOCLocationViewController.h"
#import "ECSPLocationManager.h"
#import "ECSPGeocoder.h"

#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>


#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface LOCLocationViewController ()<BMKMapViewDelegate,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) ECSPGeocoder * geocoder;
@property (nonatomic,strong) BMKGeoCodeSearch * searcher;
@property (nonatomic,strong) BMKPoiInfo * info;
@property (nonatomic,strong) NSArray * addressList;
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation LOCLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _mapView =[[BMKMapView alloc]initWithFrame:CGRectZero];
    [self.view addSubview: _mapView];
    [_mapView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(self.view.bounds.size.height/2.0f));
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_mapView.bottom);
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" actionHandler:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [self getCurrentLocation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

#pragma mark - UserAction

-(void)setTableViewCellSelectByIndex:(NSIndexPath *)indexPath
{
    for(int i=0;i<self.addressList.count;i++)
    {
        NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:index];
        cell.accessoryView = nil;
    }
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_choose_poi"]];
}

-(void)setRightNavigationBarItem
{
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendLocation)];
}

-(void)sendLocation
{
    if(self.info == NULL) return;
    
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectLocationbyController:info:image:)])
    {
        
        [_delegate didSelectLocationbyController:self info:self.info image:[self snapshot:self.mapView]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

-(void)getCurrentLocation
{
    self.geocoder = [[ECSPGeocoder alloc] init];
    [self.geocoder currentPlacemark:^(CLPlacemark *placemark, NSError *error) {
        if (error) {
        }else {
            CLLocation * city = placemark.location;
            NSLog(@"plasc== %f  %f",city.coordinate.latitude,city.coordinate.longitude);
            [self searchGeocodeBycoordinate:city.coordinate];
        }
    }];
    
}

-(void)setMapViewAnnotationBycoordinate:(CLLocationCoordinate2D)coordinate
{
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coordinate;
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:annotation];
    _mapView.centerCoordinate=coordinate;//让地图显示当前位置
    [_mapView selectAnnotation:annotation animated:YES];
    
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = coordinate;//中心点
    region.span.latitudeDelta = 0.01;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.01;//纬度范围
    [_mapView setRegion:region animated:YES];
}

-(void)searchGeocodeBycoordinate:(CLLocationCoordinate2D)coordinate
{
    _searcher = [[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = coordinate;
    //这段代码不要删
    NSLog(@"%d",[_searcher reverseGeoCode:rever]);
}

#pragma mark -BMKAnnotationView

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

#pragma mark - BMKGeocodeSearchDelegate

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%@  %@",result.address,result.poiList);
    self.addressList = [NSArray arrayWithArray:result.poiList];
    
    self.info = self.addressList[0];
    CLLocationCoordinate2D coordinate = self.info.pt;
    [self setMapViewAnnotationBycoordinate:coordinate];
    [self setRightNavigationBarItem];
    
    [self.tableView reloadData];
    
    [self setTableViewCellSelectByIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark - tableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ider = @"ider";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ider];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ider];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont preferredFontForTextStyle:ECSPFontTextStyleTitle1];
        cell.textLabel.textColor = [UIColor ECSPBlackColor];
        
        cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:ECSPFontTextStyleCaption1];
        cell.detailTextLabel.textColor = [UIColor ECSPGrayColor];
    }
    BMKPoiInfo * info = self.addressList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",info.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",info.address];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.info = self.addressList[indexPath.row];
    [self setMapViewAnnotationBycoordinate:self.info.pt];
    [self setTableViewCellSelectByIndex:indexPath];
}

@end
