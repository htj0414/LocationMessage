//
//  IMLoctionViewController.h
//  ECSPFriendsChat
//
//  Created by 小房子 on 16/8/31.
//  Copyright © 2016年 小房子. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Search/BMKPoiSearchType.h>

@class LOCLocationViewController;
@protocol LOCLocationViewControllerDelegate <NSObject>

-(void)didSelectLocationbyController:(LOCLocationViewController *)controller info:(BMKPoiInfo*)info image:(UIImage *)image;

@end

@interface LOCLocationViewController : UIViewController

@property (nonatomic,strong) id<LOCLocationViewControllerDelegate>delegate;

@end
