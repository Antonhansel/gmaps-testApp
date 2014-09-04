//
//  ViewController.m
//  gmapstest
//
//  Created by Apollo on 03/09/14.
//  Copyright (c) 2014 com.iosHello. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:45.755038
                                                            longitude:4.85
                                                                 zoom:15];
    self.mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView_.myLocationEnabled = YES;
    self.view = self.mapView_;
    self.mapView_.mapType = kGMSTypeHybrid;
    self.mapView_.settings.compassButton = YES;
    self.mapView_.settings.myLocationButton = YES;
    self.APIKey = [[NSMutableString alloc] init];
    [self.APIKey appendString:@"&apiKey=330ce071949ce010e76b00671a988f6dd2791933"];
    [self getData];
}

- (void)getData
{
    NSMutableString *urlRequest = [[NSMutableString alloc] init];
    [urlRequest appendString:@"https://api.jcdecaux.com/vls/v1/stations?contract=lyon"];
    [urlRequest appendString:self.APIKey];
    NSURL *url = [[NSURL alloc] initWithString:[urlRequest stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError* error;
         self.stationList = [NSJSONSerialization
                               JSONObjectWithData:responseObject
                               options:kNilOptions
                               error:&error];
         [self showPlaces];

     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connexion failed"
                                                         message:[error localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
     }];
    [operation start];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    NSLog(@"test");
    return YES;
}

- (void)showPlaces
{
    NSMutableString *info = [[NSMutableString alloc] init];
    NSNumber *temp = [[NSNumber alloc] init];
    
    for (id key in self.stationList)
    {
        [info setString:@"Nombre de vélos: "];
        temp = key[@"available_bikes"];
        [info appendFormat:@"%@", temp];
        [info appendString:@"/"];
        temp = key[@"bike_stands"];
        [info appendFormat:@"%@", temp];
        [self placeMarker:key[@"position"][@"lat"] curLongitude:key[@"position"][@"lng"] stationName:key[@"name"] stationDetails:info];
    }
}

- (void)placeMarker:(NSNumber *)latitude curLongitude:(NSNumber *)longitude stationName:(NSString *)name stationDetails:(NSString *)details
{
    GMSMarker *marker = [[GMSMarker alloc] init];

    marker.position = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    marker.title = [name componentsSeparatedByString:@"- "][1];
    marker.snippet = details;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = self.mapView_;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
