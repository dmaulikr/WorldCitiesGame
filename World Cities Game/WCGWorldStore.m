//
//  WCGWorldStore.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 27/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGWorldStore.h"
#include <stdlib.h>

@implementation WCGWorldStore

@synthesize allRegions, allCountries;


+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (WCGWorldStore *)sharedStore
{
    static WCGWorldStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    return sharedStore;
}

-(id)init
{
    self = [super init];
    if (self)
    {
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
        allRegions = [[NSMutableDictionary alloc] init];
        allCountries = [[NSMutableDictionary alloc] init];

             
        //[self addRegion:@"Africa" code:@"AF"];
        //[self addRegion:@"Asia" code:@"AS"];
        //[self addRegion:@"Europe" code:@"EU"];
        //[self addRegion:@"North America" code:@"NA"];
        //[self addRegion:@"South America" code:@"SA"];
        //[self addRegion:@"Oceania" code:@"OC"];
        //[self addRegion:@"Antarctica" code:@"AN"];        
    }
    return self;
}

- (void)addDefaultRegions
{
    
    [self addRegion:@"Africa" code:@"AF" centreLat:@"2" centreLng:@"16" zoomX:[NSNumber numberWithInt:6000000] zoomY:[NSNumber numberWithInt:6000000]];
    
    [self addRegion:@"Asia" code:@"AS" centreLat:@"50" centreLng:@"97" zoomX:[NSNumber numberWithInt:5000000] zoomY:[NSNumber numberWithInt:5000000]];
    [self addRegion:@"Europe" code:@"EU" centreLat:@"59" centreLng:@"17" zoomX:[NSNumber numberWithInt:3000000] zoomY:[NSNumber numberWithInt:3000000]];
    
    
    [self addRegion:@"North America" code:@"NA" centreLat:@"40" centreLng:@"-97" zoomX:[NSNumber numberWithInt:6000000] zoomY:[NSNumber numberWithInt:6000000]];
    [self addRegion:@"South America" code:@"SA" centreLat:@"-20" centreLng:@"-58" zoomX:[NSNumber numberWithInt:6000000] zoomY:[NSNumber numberWithInt:6000000]];
    [self addRegion:@"Oceania" code:@"OC" centreLat:@"-28" centreLng:@"150" zoomX:[NSNumber numberWithInt:5000000] zoomY:[NSNumber numberWithInt:5000000]];

}

//get some cities, set number of questions
- (NSMutableArray *)getCitiesWithParams:(NSMutableDictionary*)params
{
    int numberOfCities = [[params objectForKey:@"count"] intValue];
    if (!numberOfCities) numberOfCities = 10;
       
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"WCGCity"];
    [request setEntity:e];
    
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"population" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    [request setFetchLimit:numberOfCities*10];
    
    if ([params objectForKey:@"type"])
    {
        if ([[params objectForKey:@"type"] isEqualToString:@"region"])
        {
            WCGRegion *region = [[[WCGWorldStore sharedStore] allRegions] objectForKey:[params objectForKey:@"details"]];
            if (region)
            {
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"country.region == %@", region];
                [request setPredicate:pred];
            }
        }
        else if ([[params objectForKey:@"type"] isEqualToString:@"country"])
        {
            WCGCountry *country = [[[WCGWorldStore sharedStore] allCountries] objectForKey:[params objectForKey:@"details"]];
            if (country)
            {
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"country == %@", country];
                [request setPredicate:pred];
            }        
        }            
    }
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!result)
    {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    
    currentCities = [[NSMutableArray alloc] init];
    int r;
    for (WCGCity *city in result)
    {
        r = arc4random() % [result count];
        
        if (![currentCities containsObject:[result objectAtIndex:r]])
            [currentCities addObject:[result objectAtIndex:r]];
        if ([currentCities count] == numberOfCities) break;
    }
    
    
    
    return currentCities;
    /*
     for (WCGCity *city in currentCities)
    {
        NSLog(@"city: %@, country %@", [city name], [[city country] name]);
    }
     */
}


-(NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSError *error;
    NSString * resultString = [documentDirectory stringByAppendingPathComponent:@"store.wolrdcitiesgame"];
    
    
    /*
     NSFileManager *fileManager = [NSFileManager defaultManager];
     BOOL success = [fileManager fileExistsAtPath:resultString];
     
     if (!success)
     {
         NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"store.wolrdcitiesgame"];
         success = [fileManager copyItemAtPath:defaultDBPath toPath:resultString error:&error];
         if (!success)
         {
             NSLog(@"Failed to create writable database file");
         }
     }
     
    */
    
    return resultString;
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

-(NSMutableArray *)getAllRegions
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"WCGRegion"];
    [request setEntity:e];
    
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!result)
    {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    
    if ([allRegions count] == 0)
    {
        for (WCGRegion * region in result)
        {
            [allRegions setValue:region forKey:[region code]];
        }
    }
    return [[NSMutableArray alloc] initWithArray:result];
}

-(NSMutableArray *)getAllCountriesForRegion:(WCGRegion*)region
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"WCGCountry"];
    [request setEntity:e];
    
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    if (region)
    {
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"code != 'ax' and region == %@", region];
        [request setPredicate:pred];
    }
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!result)
    {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    
    if ([allCountries count] == 0)
    {
        for (WCGCountry * country in result)
        {
            [allCountries setValue:country forKey:[country code]];
        }
    }
    return result;
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
    
    
    if ([tableName isEqualToString:@"WCGCountry"])
    {
        allCountries = [[NSMutableDictionary alloc] init];
        
        for (WCGCountry *country in allItems)
        {
            WCGRegion *reg = [country region];
            NSLog(@"%@", [reg name]);
            NSLog(@"name: %@. lat: %@, lng: %@ , capital: %@ ", [country name], [country centreLat], [country centreLng], [[country capital] name]);
            [allCountries setValue:country forKey:[country code]];
        }
    }
    else if ([tableName isEqualToString:@"WCGRegion"])
    {
        allRegions = [[NSMutableDictionary alloc] init];
        
        for (WCGRegion *region in allItems)
        {
            //NSLog(@"name: %@. code: %@ ", [country name], [country code]);
            [allRegions setValue:region forKey:[region code]];
        }
    }
}


// used for parsing cities and countries

 
-(void)setRegion:(WCGRegion*)region toCountry:(NSString*)countryCode
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"WCGCountry"];
    [request setEntity:e];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"code == %@", countryCode];
    
    [request setPredicate:pred];
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!result)
    {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    
    currentCities = [[NSMutableArray alloc] initWithArray:result];
    if ([currentCities count] > 0)
    {
        WCGCountry *newCountry = [currentCities objectAtIndex:0];
        NSLog(@"%@, region: %@",[newCountry name], [region name]);
        [newCountry addWorldRegion:region];
        [self saveChanges];
    }
    
}


-(void)addCity:(NSString*)newCityName
{
    WCGCity *newCity = [NSEntityDescription insertNewObjectForEntityForName:@"WCGCity" inManagedObjectContext:context];
    [newCity setName:newCityName];
}

-(void)addCity:(NSString*)newCityName countyCode:(WCGCountry*)country population:(NSString*)population lat:(NSString*)lat lng:(NSString*)lng isCapital:(BOOL)isCapital
{
    WCGCity *newCity = [NSEntityDescription insertNewObjectForEntityForName:@"WCGCity" inManagedObjectContext:context];
    [newCity addName:newCityName countyCode:country population:[NSNumber numberWithInt:[population intValue]] lat:lat lng:lng isCapital:isCapital];
   // [newCity addName:newCityName countyCode:country population:population lat:lat lng:lng isCapital:isCapital];
}

-(void)addCountry:(NSString*)countryName countryCode:(NSString*)countryCode region:(WCGRegion*)region
{
    countryName = [countryName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    WCGCountry * newCountry = [NSEntityDescription insertNewObjectForEntityForName:@"WCGCountry" inManagedObjectContext:context];
    [newCountry addName:countryName countryCode:countryCode region:region];
    
}

-(void)addRegion:(NSString*)regionName code:(NSString*)code centreLat:(NSString*)lat centreLng:(NSString*)lng zoomX:(NSNumber*)zoomX zoomY:(NSNumber*)zoomY
{
    WCGRegion *newRegion = [NSEntityDescription insertNewObjectForEntityForName:@"WCGRegion" inManagedObjectContext:context];
    [newRegion addName:regionName code:code centreLat:lat centreLng:lng zoomX:zoomX zoomY:zoomY];
}
 
-(void)parseAllRegions
{
    NSString *fileContents = [NSString stringWithContentsOfFile:@"/Users/alexandrapozdnyakova/Desktop/countries_regions.txt"];
    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    for (NSString * line in lines)
    {
        if ([line isEqualToString:@""]) continue;
        NSArray *countriesArr = [line componentsSeparatedByString:@" "];
        
        NSString * countryStr = [[countriesArr objectAtIndex:1] lowercaseString];
        NSString * regionStr = [countriesArr objectAtIndex:0];
        
        [self setRegion:[allRegions objectForKey:regionStr] toCountry:countryStr];
        
        
    }
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

-setCountryCapital:(WCGCity *)city toCountry:(NSString*)countryCode lat:(NSString*)lat lng:(NSString*)lng
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"WCGCountry"];
    [request setEntity:e];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"code == %@", countryCode];
    
    [request setPredicate:pred];
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!result)
    {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    
    currentCities = [[NSMutableArray alloc] initWithArray:result];
    if ([currentCities count] > 0)
    {
        WCGCountry *newCountry = [currentCities objectAtIndex:0];
        [newCountry setCountryCapital:city lat:lat lng:lng];
        [self saveChanges];
    }

    
}
 
- (void)parseFullCountryInfo
{
    NSString *fileContents = [NSString stringWithContentsOfFile:@"/Users/alexandrapozdnyakova/Desktop/cow.txt"];
    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    for (NSString * line in lines)
    {
        if ([line length] < 1 || [line characterAtIndex:0] == '#' || [line characterAtIndex:0] == ' ' || [line isEqualToString:@""]) continue;
        
        NSArray *countriesArr = [line componentsSeparatedByString:@";"];
        if ([countriesArr count] < 10) continue;
        if ([[countriesArr objectAtIndex:35] intValue] != 1) continue;
        
        WCGCity * capital = [self checkCity:[countriesArr objectAtIndex:36]];
        if (capital)
        {
            [self setCountryCapital:capital toCountry:[[countriesArr objectAtIndex:0] lowercaseString] lat:[countriesArr objectAtIndex:61] lng:[countriesArr objectAtIndex:62]];
        }
        
        
        //lat - 61, lng - 62
        //hasCapital - 35, capital Name - 36
        
        
        
      /*  int i = 0;
        for (NSString *element in countriesArr)
            NSLog(@"%d: %@ ",i++,element);
       */
       
               
        //NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
       // NSNumber * populationNumber = [f numberFromString:[citiesArr objectAtIndex:14]];
        
        
        
       // [self addCity:[citiesArr objectAtIndex:2] countyCode:[allCountries objectForKey:[[citiesArr objectAtIndex:8] lowercaseString]] population:populationNumber  lat:[citiesArr objectAtIndex:4] lng:[citiesArr objectAtIndex:5] isCapital:NO];
        
    }
    
}

//this checks if city exists - used for tests

-(WCGCity*)checkCity:(NSString*)curCityName
{
   
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"WCGCity"];
    [request setEntity:e];
    
   // NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"population" ascending:NO];
    //[request setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@", curCityName];
    [request setPredicate:pred];
    [request setFetchLimit:1];

    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!result)
    {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    
    NSMutableArray *allItems = [[NSMutableArray alloc] initWithArray:result];
    if ([allItems count] > 0)
        return (WCGCity*)[allItems objectAtIndex:0];
    else return nil;
    
}

@end
