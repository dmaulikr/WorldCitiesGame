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

    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
    NSMutableDictionary *allCountries;
    
    CLLocationManager *locationManager;
    
    NSArray *currentCities;
    
    int points;
    int numberOfQuestions;
    
    NSInteger currentCityIndex;
    MKPointAnnotation *desiredPointAnnotation;
    
    float progressBarTotalSeconds;
    
    int maxPointsNum;
}

//preparations
- (void)showAllItems:(NSString*)tableName;
- (void)getCities:(int)numberOfCities;
- (BOOL)saveChanges;
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


// used for parsing cities and countries 
/*
-(void)parseAllCountries;
-(void)parseAllCities;
-(void)addCity:(NSString*)cityName;
-(void)addCity:(NSString*)cityName countyCode:(WCGCountry*)country population:(NSString*)population lat:(NSString*)lat lng:(NSString*)lng isCapital:(BOOL)isCapital;
-(void)addCountry:(NSString*)countryName countryCode:(NSString*)countryCode region:(WCGRegion*)region;
-(void)addRegion:(NSString*)regionName code:(NSString*)code;
*/

//this checks if city exists - used for tests
//-(void)checkCity;
- (NSString *)itemArchivePath;


@end
