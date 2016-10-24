//
//  HHLocationCompactComposeViewController.m
//  LocationMessage
//
//  Created by hong7 on 16/9/17.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import "HHLocationCompactComposeViewController.h"

#import <MapKit/MapKit.h>

#import "Masonry.h"

#import "HHLocationTableViewCell.h"
#import "HHLocationComposeViewController.h"
#import "HHLocation.h"

#import "ECSPGeocoder.h"
#import "FAKIonIcons.h"

@interface HHLocationCompactComposeViewController ()

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) ECSPGeocoder * geocoder;

@end

@implementation HHLocationCompactComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.98 green:0.96 blue:0.93 alpha:1.00]];
    
    UILabel * label = [UILabel new];
    [label setTextColor:[UIColor orangeColor]];
    [label setFont:[UIFont fontWithName:@"AmericanTypewriter" size:32.0f]];
    [label setText:@"Share Location"];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(32.0f);
    }];
    
    
    FAKIcon * icon = [FAKIonIcons iosPlusEmptyIconWithSize:64.0f];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    UIButton * button = [UIButton new];
    [button setImage:[icon imageWithSize:CGSizeMake(64, 64)] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button.layer setCornerRadius:32.0f];
    [button.layer setMasksToBounds:YES];
    [button addTarget:self action:@selector(shareCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100.0f);
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@64.0f);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - User Action

-(void)shareCurrentLocation:(UIButton *)button {
    
    if (_delegate && [_delegate respondsToSelector:@selector(compactComposeViewControllerChoosedShareCurrentLocation:)]) {
        [_delegate compactComposeViewControllerChoosedShareCurrentLocation:self];
    }
}

@end
