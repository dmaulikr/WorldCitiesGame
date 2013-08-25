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

@interface WCGMapViewController ()

@end

@implementation WCGMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            [NSException raise:@"open failed" format:@"reason: %@", [error localizedDescription]];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        
        [context setUndoManager:nil];
        
        points = 0;
        currentCityIndex = -1;
        progressBarTotalSeconds = 0;
        
        // used for parsing cities and countries
        /*[self parseAllCountries];
        [self showAllItems:@"WCGCountry"];
        [self parseAllCities];
        [self saveChanges];*/
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

// used for parsing cities and countries 
/*
-(void)addCity:(NSString*)newCityName
{
    WCGCity *newCity = [NSEntityDescription insertNewObjectForEntityForName:@"WCGCity" inManagedObjectContext:context];
    [newCity setName:newCityName];
}

-(void)addCity:(NSString*)newCityName countyCode:(WCGCountry*)country population:(NSString*)population lat:(NSString*)lat lng:(NSString*)lng isCapital:(BOOL)isCapital
{
    WCGCity *newCity = [NSEntityDescription insertNewObjectForEntityForName:@"WCGCity" inManagedObjectContext:context];
    [newCity addName:newCityName countyCode:country population:population lat:lat lng:lng isCapital:isCapital];
}

-(void)addCountry:(NSString*)countryName countryCode:(NSString*)countryCode region:(WCGRegion*)region
{
    countryName = [countryName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    WCGCountry * newCountry = [NSEntityDescription insertNewObjectForEntityForName:@"WCGCountry" inManagedObjectContext:context];
    [newCountry addName:countryName countryCode:countryCode region:region];
    
}

-(void)addRegion:(NSString*)regionName code:(NSString*)code
{
    WCGRegion *newRegion = [NSEntityDescription insertNewObjectForEntityForName:@"WCGRegion" inManagedObjectContext:context];
    [newRegion addName:regionName code:code];
}


-(void)parseAllCountries
{
    NSString *fileContents = [NSString stringWithContentsOfFile:@"/Users/alexandrapozdnyakova/Desktop/geodata/countries.txt"];
    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    for (NSString * line in lines)
    {
        if ([line isEqualToString:@""]) continue;
        NSArray *countriesArr = [line componentsSeparatedByString:@"\t"];
        if (![[countriesArr objectAtIndex:2] isEqualToString:@"TLD"])
        {
            NSLog(@"county name: %@, country code: %@", [countriesArr objectAtIndex:3], [[countriesArr objectAtIndex:1] lowercaseString]);
            [self addCountry:[countriesArr objectAtIndex:3] countryCode:[[countriesArr objectAtIndex:1] lowercaseString] region:nil];
        }
    }
    
}

-(void)parseAllCities
{
    NSString *fileContents = [NSString stringWithContentsOfFile:@"/Users/alexandrapozdnyakova/Desktop/cities1000.txt"];
    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    int i = 0;
    for (NSString * line in lines)
    {
        i++;
        if ([line isEqualToString:@""]) continue;
        NSArray *citiesArr = [line componentsSeparatedByString:@"\t"];
        
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        NSNumber * populationNumber = [f numberFromString:[citiesArr objectAtIndex:14]];
        
        
        
        [self addCity:[citiesArr objectAtIndex:2] countyCode:[allCountries objectForKey:[[citiesArr objectAtIndex:8] lowercaseString]] population:populationNumber  lat:[citiesArr objectAtIndex:4] lng:[citiesArr objectAtIndex:5] isCapital:NO];
        
    }
    NSLog(@"Total count: %d", i);
    
}
*/


-(NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSError *error;
    NSString * resultString = [documentDirectory stringByAppendingPathComponent:@"store.wolrdcitiesgame"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:resultString];
    
    if (!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"store.wolrdcitiesgame"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:resultString error:&error];
        if (!success) {
            NSLog(@"Failed to create writable database file");
        }
    }
    
    return resultString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMap:)];    
    tapRecognizer.numberOfTapsRequired = 1;    
    tapRecognizer.numberOfTouchesRequired = 1;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([worldMap centerCoordinate], 10000000, 10000000);
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

-(void)showAllItems:(NSString*)tableName
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:tableName];
    [request setEntity:e];
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!result)
    {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    
    NSMutableArray *allItems = [[NSMutableArray alloc] initWithArray:result];
       
    
    allCountries = [[NSMutableDictionary alloc] init];
    
    for (WCGCountry *country in allItems)
    {
        //NSLog(@"name: %@. code: %@ ", [country name], [country code]);
        [allCountries setValue:country forKey:[country code]];
    }
    
}

-(BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful)
    {
        NSLog(@"error saving %@", [err localizedDescription]);
    }
    return successful;
    
}

//this checks if city exists - used for tests
/*
-(void)checkCity
{
    NSString *curCityName = [cityName text];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"WCGCity"];
    [request setEntity:e];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@", curCityName];
    [request setPredicate:pred];
    
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!result)
    {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    
    NSMutableArray *allItems = [[NSMutableArray alloc] initWithArray:result];
    for (WCGCity *city in allItems)
    {
        NSLog(@"city exists: %@, lat %@, lng %@, population %@", [city name], [city lat], [city lng], [city population]);
    }

}*/

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


//get some cities, set number of questions
- (void)getCities:(int)numberOfCities;
{
    if (!numberOfCities) numberOfCities = 10;
    
    
    numberOfQuestions = numberOfCities;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"WCGCity"];
    [request setEntity:e];
    
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"population" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    [request setFetchLimit:numberOfCities];
        
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!result)
    {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    
    currentCities = [[NSMutableArray alloc] initWithArray:result];
    for (WCGCity *city in currentCities)
    {
        NSLog(@"city exists: %@, lat %@, lng %@, population %@", [city name], [city lat], [city lng], [city population]);
    }
}

-(void)startGame
{
    [self getCities:10];
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
        [questionField setText:[[currentCities objectAtIndex:currentCityIndex] name]];
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([desiredLocation coordinate], 10000000, 10000000);
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
