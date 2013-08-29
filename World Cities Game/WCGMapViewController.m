//
//  WCGMapViewController.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 17/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGMapViewController.h"
#import "WCGCity.h"
#import "WCGCountry.h"
#import "WCGRegion.h"
#include <math.h>
#import "WCGWorldStore.h"
#import "WCGSettings.h"

@interface WCGMapViewController ()

@end

@implementation WCGMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
               
        points = 0;
        currentCityIndex = -1;
        progressBarTotalSeconds = 0;
        [[WCGWorldStore sharedStore] parseFullCountryInfo];
        

        // used for parsing cities and countries
        [[WCGWorldStore sharedStore] showAllItems:@"WCGRegion"];

        [[WCGWorldStore sharedStore] showAllItems:@"WCGCountry"];
        [[WCGWorldStore sharedStore] parseFullCountryInfo];
        [[WCGWorldStore sharedStore] saveChanges];
        /*
        [[WCGWorldStore sharedStore] addDefaultRegions];
        [[WCGWorldStore sharedStore] parseAllCountries];
        [[WCGWorldStore sharedStore] showAllItems:@"WCGRegion"];
        [[WCGWorldStore sharedStore] parseAllRegions];
        [[WCGWorldStore sharedStore] showAllItems:@"WCGCountry"];
        [[WCGWorldStore sharedStore] parseAllCities];
         [[WCGWorldStore sharedStore] parseFullCountryInfo];
         [[WCGWorldStore sharedStore] saveChanges];
         */
        
    }
    return self;
}

-(id)initWithParams:(NSDictionary*)params
{
    self = [super initWithNibName:@"WCGMapViewController" bundle:nil];
    if (self) {
               
        points = 0;
        currentCityIndex = -1;
        progressBarTotalSeconds = 0;
        gameType = [[NSMutableDictionary alloc] initWithDictionary:params];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[questionField setText:@"The game will start in a moment..."];
    //[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(preparations) userInfo:nil repeats:NO];
    [self preparations];
    
}

-(void)preparations
{
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    CLLocationCoordinate2D centre;
   // int x, y;
    
    if ([gameType objectForKey:@"type"])
    {
        if ([[gameType objectForKey:@"type"] isEqualToString:@"region"]) //focus on the centre of the region
        {
            NSString *regionStr = [gameType objectForKey:@"details"];
            allRegions = [[WCGWorldStore sharedStore] allRegions];
            centre = CLLocationCoordinate2DMake([[[allRegions objectForKey:regionStr] centreLat] intValue], [[[allRegions objectForKey:regionStr] centreLng] intValue]);
            currentZoomX = [[[allRegions objectForKey:regionStr] zoomX] intValue];
            currentZoomY = [[[allRegions objectForKey:regionStr] zoomY] intValue];
        }
        else if ([[gameType objectForKey:@"type"] isEqualToString:@"country"]) //still focus on the centre of the region, may change the db later
        {
            NSString *countryStr = [gameType objectForKey:@"details"];
            allCountries = [[WCGWorldStore sharedStore] allCountries];
            WCGCountry * curCountry = [allCountries objectForKey:countryStr];
            centre = CLLocationCoordinate2DMake([[[curCountry region] centreLat] intValue], [[[curCountry region] centreLng] intValue]);
            currentZoomX = [[[curCountry region] zoomX] intValue];
            currentZoomY = [[[curCountry region] zoomY] intValue];
        }
        
    }
    else
    {
        centre = [worldMap centerCoordinate];
        currentZoomX = currentZoomY = 1000000;
    }
           
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centre, currentZoomX, currentZoomY);
    [worldMap setRegion:region animated:YES];
    
    desiredPointAnnotation = [[MKPointAnnotation alloc] init];
    
    [progressBar setProgress:0.0];
    
    [self startGame];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)updateProgressBar
{    
    float actual = [progressBar progress];
    if (!progressBarTotalSeconds) return;
    if (actual < 1)
    {
        progressBar.progress = actual + ((float)1/(float)progressBarTotalSeconds);
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:NO];
    }
    else
    {
        [progressBar setHidden:YES];
        [self questionFailed];
    }    
}

- (void)stopProgressBar
{
    progressBarTotalSeconds = 0;
    [progressBar setHidden:YES];
}



-(void)startGame
{
    numberOfQuestions = [[gameType objectForKey:@"count"] intValue];
    if (!numberOfQuestions) numberOfQuestions = 10;
    
    currentCities = [[WCGWorldStore sharedStore] getCitiesWithParams:gameType];
    
    gameLevel = [[NSUserDefaults standardUserDefaults]
                       valueForKey:[[WCGSettings sharedStore] level]];  
    
    [self nextQuestion];
    
}

-(void)nextQuestion
{
    [worldMap removeAnnotations:[worldMap annotations]];
    currentCityIndex++;
    if (currentCityIndex == numberOfQuestions)
    {
       // points = (maxPointsNum - points) / 10000;
        [questionField setText:[NSString stringWithFormat:@"Yay! Game completed! Total points: %d", points]];
    }
    else
    {
        NSString * text = [NSString stringWithFormat:@"%d/%d %@", currentCityIndex + 1, numberOfQuestions, [[currentCities objectAtIndex:currentCityIndex] name]];
        WCGCountry * country = [[currentCities objectAtIndex:currentCityIndex] country];
        if ([gameLevel isEqualToString:@"Medium"] || [gameLevel isEqualToString:@"Easy"])
            text = [text stringByAppendingString:[NSString stringWithFormat:@", %@", [country name]]];
        [questionField setText:text];
        [self setNewProgressBar:10.0];
        [worldMap addGestureRecognizer:tapRecognizer];
    } 
}

- (void)questionAnswered:(CGPoint)pointXY
{
    [worldMap removeGestureRecognizer:tapRecognizer];
    [self stopProgressBar];    
    
    //show tapped point
    CLLocationCoordinate2D pointCoordinates = [worldMap convertPoint:pointXY toCoordinateFromView:self.view];
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = pointCoordinates;
    [worldMap addAnnotation:pointAnnotation];
    
    //find distance between tapped point and desired point
    CLLocation *tappedLocation = [[CLLocation alloc] initWithLatitude:pointCoordinates.latitude longitude:pointCoordinates.longitude];
    WCGCity *currentCity = [currentCities objectAtIndex:currentCityIndex];
    CLLocationCoordinate2D currentCityCoordinate = CLLocationCoordinate2DMake([currentCity getLat], [currentCity getLng]);
    
    CLLocation *desiredLocation = [[CLLocation alloc] initWithLatitude:currentCityCoordinate.latitude longitude:currentCityCoordinate.longitude];
    CLLocationDistance distance = [desiredLocation distanceFromLocation:tappedLocation];
    
    //show desired point
    [self showDesiredPoint:currentCityCoordinate withLocation:desiredLocation];
    
    //show distance
    int distanceNumber = round(distance/1000);
        
    points = [self earnedPoints:distanceNumber] + points;
    
    [questionField setText:[NSString stringWithFormat:@"Distance: %d km.", distanceNumber]];
    
    [self setTimerFor:2.0 withSelector:@selector(nextQuestion)];
}

-(int)earnedPoints:(int)distanceNumber
{
    int earnedPoints = 0;    
    if (distanceNumber < 25) earnedPoints = 3000;
    else if (distanceNumber < 50) earnedPoints = 2000;
    else if (distanceNumber < 100) earnedPoints = 1500;
    else if (distanceNumber < 500) earnedPoints = 1000;
    else if (distanceNumber < 1000) earnedPoints = 500;
    else if (distanceNumber < 1500) earnedPoints = 250;
    else if (distanceNumber < 2000) earnedPoints = 120;
    else if (distanceNumber <= 3000) earnedPoints = 30;
    
    return earnedPoints;
}

-(void)questionFailed
{
    [worldMap removeGestureRecognizer:tapRecognizer];
    
    CLLocationCoordinate2D defaultCoordinate;    
    [questionField setText:@"Question failed"];
    [self showDesiredPoint:defaultCoordinate withLocation:nil];
    
    [self setTimerFor:2.0 withSelector:@selector(nextQuestion)];
}

-(void)youLose
{
    [questionField setText:@"Game over"];
}

- (void)setNewProgressBar:(float)seconds
{
    [progressBar setHidden:NO];
    [progressBar setProgress:0.0];
    progressBarTotalSeconds = seconds;
    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
}

- (void)setTimerFor:(float)seconds withSelector:(SEL)sel
{
    [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:sel userInfo:nil repeats:NO];

}

-(IBAction)tapOnMap:(UITapGestureRecognizer *)recognizer
{
    if (currentCityIndex != -1)
    {
        CGPoint pointXY = [recognizer locationInView:worldMap];
        [self questionAnswered:pointXY];
    }
}

-(void)showDesiredPoint:(CLLocationCoordinate2D)currentCityCoordinate withLocation:(CLLocation*)desiredLocation
{
    if (desiredLocation == 0)
    {
        WCGCity *currentCity = [currentCities objectAtIndex:currentCityIndex];
        currentCityCoordinate = CLLocationCoordinate2DMake([currentCity getLat], [currentCity getLng]);
        desiredLocation = [[CLLocation alloc] initWithLatitude:currentCityCoordinate.latitude longitude:currentCityCoordinate.longitude];        
    }
    //show desired point
    desiredPointAnnotation.coordinate = currentCityCoordinate;
    [worldMap addAnnotation:desiredPointAnnotation];
    
    //center on desiredpoint
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([desiredLocation coordinate], currentZoomX, currentZoomY);
    [worldMap setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]   initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    if (annotation == desiredPointAnnotation)
        annView.pinColor = MKPinAnnotationColorGreen;
    else
        annView.pinColor = MKPinAnnotationColorRed;

   // MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]   initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
  
    return annView;
    
}







@end
