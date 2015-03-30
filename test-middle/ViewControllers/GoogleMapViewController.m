//
//  GoogleMapViewController.m
//  test-middle
//
//  Created by Андрей on 30.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "GoogleMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GoogleMapViewController ()

@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, strong) GMSMapView *mapView;

@end

@implementation GoogleMapViewController

+ (instancetype)mapWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    return [[self alloc] initWithLatitude:latitude longitude:longitude];
}

- (instancetype)initWithLatitude:(CLLocationDegrees)latitide longitude:(CLLocationDegrees)longitude
{
    self = [super init];
    if (self) {
        self.latitude = latitide;
        self.longitude = longitude;
    }
    return self;
}

- (void)viewDidLoad {
    
    [self customizeNavigationBar];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                                            longitude:self.longitude
                                                                 zoom:15];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    marker.map = self.mapView;
}

- (void)customizeNavigationBar {
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeMap)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"main_color"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.title = [MCLocalization stringForKey:@"photo_location"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont regularFontWithSize:18.f],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)closeMap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
