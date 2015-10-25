//
//  WSViewController.m
//  GpsTracker
//
//  Original Created by Nick Fox on 1/1/14.
//  Copyright (c) 2014 Nick Fox. All rights reserved.
//
//  Modified for "Mobile Arduino Datalogger" project
//  for SF Science Hack Day 2015 by C. Ivan Cooper
//  Distributed under terms of MIT license (as original)

#import "WSViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AFHTTPRequestOperationManager.h"

@interface WSViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIButton *trackingButton;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionIDLabel;
@end

@implementation WSViewController
{
    CLLocationManager *locationManager;
    CLLocation *previousLocation;
    double totalDistanceInMeters;
    bool currentlyTracking;
    bool firstTimeGettingPosition;
    NSUUID *guid;
    NSDate *lastWebsiteUpdateTime;
    int timeIntervalInSeconds;
    bool increasedAccuracy;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentlyTracking = NO;
    timeIntervalInSeconds = 10; // change this to the time interval you want
    
    BOOL appIDIsSet = [[NSUserDefaults standardUserDefaults] boolForKey:@"appIDIsSet"];
    if (!appIDIsSet) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"appIDIsSet"];
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUUID UUID] UUIDString] forKey:@"appID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)startTracking
{
    NSLog(@"start tracking");
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.distanceFilter = 0; // meters
    //locationManager.pausesLocationUpdatesAutomatically = NO; // YES is default
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    locationManager.delegate = self;
    
    totalDistanceInMeters = 0;
    increasedAccuracy = YES;
    firstTimeGettingPosition = YES;
    lastWebsiteUpdateTime = [NSDate date]; // new timestamp
    [self updateAccuracyLevel:@"high"];
    
    [locationManager startUpdatingLocation];
}

- (void)stopTracking
{
    NSLog(@"stop tracking");
    
    [self sessionIDLabel].text = @"phoneNumber:";
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}

- (IBAction)handleTrackingButton:(id)sender
{
    if (currentlyTracking) {
        [self stopTracking];
        currentlyTracking = NO;
        [self.trackingButton setTitle:@"start tracking" forState:UIControlStateNormal];
    } else {
        [self startTracking];
        currentlyTracking = YES;
        [self.trackingButton setTitle:@"stop tracking" forState:UIControlStateNormal];
    }
}

- (void)reduceTrackingAccuracy
{
   locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    locationManager.distanceFilter = 5;
    increasedAccuracy = NO;
    [self updateAccuracyLevel:@"low"];
}

- (void)increaseTrackingAccuracy
{
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.distanceFilter = 0;
    increasedAccuracy = YES;
    [self updateAccuracyLevel:@"high"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    // I learned this method of getting a time interval from xs2bush on stackoverflow and wanted to give that person
    // credit for this, thanks. http://stackoverflow.com/a/6466152/125615
    
    NSTimeInterval secondsSinceLastWebsiteUpdate = fabs([lastWebsiteUpdateTime timeIntervalSinceNow]);
    if (firstTimeGettingPosition || (secondsSinceLastWebsiteUpdate > timeIntervalInSeconds)) { // currently one minute
        
        if (location.horizontalAccuracy < 500.0 && location.coordinate.latitude != 0 && location.coordinate.longitude != 0) {
            
            if (increasedAccuracy) {
                [self reduceTrackingAccuracy];
            }
            
            if (firstTimeGettingPosition) {
                firstTimeGettingPosition = NO;
            } else {
                CLLocationDistance distance = [location distanceFromLocation:previousLocation];
                totalDistanceInMeters += distance; 
            }
 
            previousLocation = location;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm:ss"]; // mysql format
            NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
            NSString *altitude = [NSString stringWithFormat:@"%d", (int)location.altitude];
            NSString *horizontalAccuracy = [NSString stringWithFormat:@"%d", (int)location.horizontalAccuracy];
            NSString *verticalAccuracy = [NSString stringWithFormat:@"%d", (int)location.verticalAccuracy];
            NSString *speed = [NSString stringWithFormat:@"%d", (int)location.speed];
            NSString *direction = [NSString stringWithFormat:@"%d", (int)location.course];
            NSString *totalDistanceString = [NSString stringWithFormat:@"%d", (int)totalDistanceInMeters];
            
            [self updateServer:latitude longitude:longitude altitude:altitude haccuracy:horizontalAccuracy vaccuracy:verticalAccuracy speed:speed direction:direction distance:totalDistanceString];
            
            lastWebsiteUpdateTime = [NSDate date]; // new timestamp
            
        } else if (!increasedAccuracy) {
            [self increaseTrackingAccuracy];
        }
    }
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [self updateUIWithLocationData:location];
    }
}

- (void)updateAccuracyLevel:(NSString *)accuracyLevel
{
    [self accuracyLevelLabel].text= [NSString stringWithFormat:@"accuracy level: %@", accuracyLevel];
}

- (void)updateUIWithLocationData:(CLLocation *)location
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    [self timestampLabel].text = [NSString stringWithFormat:@"timestamp: %@",[dateFormatter stringFromDate:location.timestamp]];
    [self latitudeLabel].text = [NSString stringWithFormat:@"latitude: %f", location.coordinate.latitude];
    [self longitudeLabel].text = [NSString stringWithFormat:@"longitude: %f", location.coordinate.longitude];
    [self accuracyLabel].text= [NSString stringWithFormat:@"accuracy: %dm", (int)location.horizontalAccuracy];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
        NSLog(@"locationManager error: %@", [error description]);
}

- (void)updateServer:(NSString *)latitude longitude:(NSString *)longitude altitude:(NSString *)altitude haccuracy:(NSString *)haccuracy vaccuracy:(NSString *)vaccuracy speed:(NSString *)speed direction:(NSString *)direction distance:(NSString *)distance
{
    NSString *defaultUploadWebsite = @"http://172.31.33.11:8080/loc";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"latitude": latitude,
                                 @"longitude": longitude,
                                 @"altitude": altitude,
                                 @"haccuracy": haccuracy,
                                 @"vaccuracy": vaccuracy,
                                 @"speed": speed,
                                 @"direction": direction,
                                 @"distance": distance };
    
    [manager GET:defaultUploadWebsite parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSLog(@"Response: %@", response);
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"AFHTTPRequestOperation Error: %@", [error description]);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
