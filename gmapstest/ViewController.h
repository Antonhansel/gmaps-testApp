//
//  ViewController.h
//  gmapstest
//
//  Created by Apollo on 03/09/14.
//  Copyright (c) 2014 com.iosHello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) GMSMapView *mapView_;

- (void)placeMarker:(NSNumber *)latitude curLongitude:(NSNumber *)longitude stationName:(NSString *)name stationDetails:(NSString *)details;
- (void)getData;
- (void)showPlaces;

@property (strong, nonatomic) NSMutableDictionary *stationList;
@property (strong, nonatomic) NSMutableString *APIKey;

@end
