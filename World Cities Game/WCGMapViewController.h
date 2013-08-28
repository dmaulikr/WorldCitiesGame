//
//  WCGMapViewController.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 17/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class WCGCity;
@class WCGCountry;
@class WCGRegion;



@interface WCGMapViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate>
{    
    __weak IBOutlet MKMapView *worldMap;
    __weak IBOutlet UILabel *questionField;
    __weak IBOutlet UIProgressView *progressBar;
    UITapGestureRecognizer *tapRecognizer;

    NSMutableDictionary *allCountries;
    NSMutableDictionary *allRegions;
    
    CLLocationManager *locationManager;
    
    NSMutableArray *currentCities;
    
    int points;
    int numberOfQuestions;
    
    NSInteger currentCityIndex;
    MKPointAnnotation *desiredPointAnnotation;
    
    float progressBarTotalSeconds;
    
    NSMutableDictionary *gameType;
    

}

//preparations
- (IBAction)tapOnMap:(UITapGestureRecognizer *)recognizer;

//game
- (void)startGame;
- (void)questionAnswered:(CGPoint)pointXY;
- (void)questionFailed;
- (void)setTimerFor:(float)seconds withSelector:(SEL)sel;
- (void)youLose;

- (void)setNewProgressBar:(float)seconds;
- (void)updateProgressBar;
- (void)stopProgressBar;

//show current city pin (desiredLocation is nil) or use params
- (void)showDesiredPoint:(CLLocationCoordinate2D)currentCityCoordinate withLocation:(CLLocation*)desiredLocation;

//this checks if city exists - used for tests
//-(void)checkCity;

-(id)initWithParams:(NSDictionary*)params;

@end
