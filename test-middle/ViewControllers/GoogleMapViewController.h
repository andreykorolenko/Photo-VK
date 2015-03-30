//
//  GoogleMapViewController.h
//  test-middle
//
//  Created by Андрей on 30.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GoogleMapViewController : UIViewController

+ (instancetype)mapWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

@end
